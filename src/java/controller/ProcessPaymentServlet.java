package controller;

import jakarta.inject.Inject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import service.CartService;

import java.io.IOException;
import java.util.List;
import model.Cart;
import model.CartItem;
import model.Order;
import model.OrderItem;
import model.ShippingAddress;
import model.User;
import service.OrderService;

public class ProcessPaymentServlet extends HttpServlet {

    @Inject
    private CartService cartService;

    @Inject
    private OrderService orderService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int cartId = Integer.parseInt(request.getParameter("cartId"));
        int addressId = Integer.parseInt(request.getParameter("addressId"));
        ShippingAddress address = cartService.getAddressById(addressId);
        String paymentMethod = request.getParameter("paymentMethod");
        List<CartItem> cartItems = cartService.getCartById(cartId);
        double grandTotal = countTotalAmount(cartItems);
        String status = "Processing";

        User user = (User) request.getSession().getAttribute("user");
        System.out.println("user:" + user);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Order order = new Order(user, grandTotal, paymentMethod, address, status);

        orderService.createNewOrder(order);

        int orderId = order.getOrderId();
        System.out.println("orderid: " + orderId);

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

        // Pass data to JSP
        request.setAttribute("cartId", cartId);
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("addressId", addressId);
        request.getRequestDispatcher("/view/payment-gateway.jsp").forward(request, response);
    }

    public double countTotalAmount(List<CartItem> cartItems) {

        double total = 0.0;
        double shipping;

        for (CartItem item : cartItems) {
            double price = item.getProduct().getUnitPrice() * item.getQuantity();
            total += price;
        }
        if (total > 1000) {
            shipping = 0.0;
        } else {
            shipping = 10.0;
        }

        double grandTotal = total + shipping;

        return grandTotal;
    }

    public int transferCartToOrder(Order order, List<CartItem> cartItems) {

        for (CartItem item : cartItems) {
            OrderItem orderItem = new OrderItem(item.getProduct(), order, item.getQuantity());

            orderService.createNewOrderItem(orderItem);
            cartService.removeFromCart(item.getId());
        }

        return 1;
    }

}
