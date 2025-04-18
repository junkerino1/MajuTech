package controller;

import jakarta.inject.Inject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import service.CartService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.Cart;
import model.CartItem;
import model.Order;
import model.OrderItem;
import model.Product;
import model.ShippingAddress;
import model.User;
import service.OrderService;
import service.ProductService;

public class ProcessPaymentServlet extends HttpServlet {

    @Inject
    private CartService cartService;

    @Inject
    private OrderService orderService;

    @Inject
    private ProductService productService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int cartId = Integer.parseInt(request.getParameter("cartId"));
        int addressId = Integer.parseInt(request.getParameter("addressId"));
        String paymentMethod = request.getParameter("paymentMethod");
        
        ShippingAddress address = cartService.getAddressById(addressId);
        List<CartItem> cartItems = cartService.getCartById(cartId);
        List<Product> productsInCart = new ArrayList<>();

        for (CartItem item : cartItems) {
            int productId = item.getProduct().getId();
            Product product = productService.getProductById(productId);
            productsInCart.add(product);
        }

        double totalAmount = countTotalAmount(productsInCart, cartItems);
        String status = "Processing";

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Order order = new Order(user, totalAmount, paymentMethod, address, status);

        orderService.createNewOrder(order);

        int orderId = order.getOrderId();

        // ensure transfering process is completed before redirecting
        int complete = transferCartToOrder(order, cartItems);

        // Redirect to confirmation
        if (complete == 1) {
            response.sendRedirect("confirmation?orderId=" + orderId);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get parameters from URL
        int cartId = Integer.parseInt(request.getParameter("cartId"));
        int addressId = Integer.parseInt(request.getParameter("addressId"));

        List<CartItem> cartItems = cartService.getCartById(cartId);
        List<Product> productsInCart = new ArrayList<>();

        for (CartItem item : cartItems) {
            int productId = item.getProduct().getId();
            Product product = productService.getProductById(productId);
            productsInCart.add(product);
        }

        double totalAmount = countTotalAmount(productsInCart, cartItems);

        // Pass data to JSP
        request.setAttribute("cartId", cartId);
        request.setAttribute("addressId", addressId);
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("productsInCart", productsInCart);
        request.setAttribute("totalAmount", totalAmount);

        request.getRequestDispatcher("/view/payment-gateway.jsp").forward(request, response);
    }

    public double countTotalAmount(List<Product> productsInCart, List<CartItem> cartItems) {
        double total = 0.0;
        double shipping;

        for (int i = 0; i < cartItems.size(); i++) {
            Product product = productsInCart.get(i);
            CartItem item = cartItems.get(i);

            double price = product.getEffectivePrice() * item.getQuantity();
            total += price;
        }

        if (total > 1000) {
            shipping = 0.0;
        } else {
            shipping = 10.0;
        }

        return total + shipping;
    }

    public int transferCartToOrder(Order order, List<CartItem> cartItems) {

        for (CartItem item : cartItems) {
            int productId = item.getProduct().getId();
            Product product = productService.getProductById(productId);
            double currentPrice = product.getEffectivePrice();
            OrderItem orderItem = new OrderItem(item.getProduct(), order, item.getQuantity(), currentPrice);

            orderService.createNewOrderItem(orderItem);
            cartService.removeFromCart(item.getId());
        }

        return 1;
    }

}
