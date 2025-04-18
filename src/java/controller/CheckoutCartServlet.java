package controller;

import jakarta.inject.Inject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import service.CartService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.User;
import model.CartItem;
import model.Product;
import model.ShippingAddress;
import service.ProductService;

public class CheckoutCartServlet extends HttpServlet {

    @Inject
    private CartService cartService;
    
    @Inject
    private ProductService productService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int cartId = Integer.parseInt(request.getPathInfo().substring(1));
        
        List<CartItem> cartItems = cartService.getCartById(cartId);
        
        User user = (User) request.getSession().getAttribute("user");
        System.out.println("user:" + user);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        List<Product> productsInCart = new ArrayList<>();

        for (CartItem item : cartItems) {
            int productId = item.getProduct().getId();
            Product product = productService.getProductById(productId);
            productsInCart.add(product);
        }
        
        
        List<ShippingAddress> address = cartService.getAddressByUserId(user.getId());
        
        request.setAttribute("cartId", cartId);
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("productsInCart", productsInCart);
        request.setAttribute("address", address);

        
        request.getRequestDispatcher("/view/shipping-address.jsp").forward(request, response);
        
    }
    
}