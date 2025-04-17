package controller;

import jakarta.inject.Inject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import service.CartService;
import model.Cart;
import model.User;

import java.io.IOException;

public class AddToCartServlet extends HttpServlet {
    
    @Inject
    private CartService cartService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        
        System.out.println("product_id" + productId);
        System.out.println("quantity" + quantity);

        // get user_id from session
        User user = (User) request.getSession().getAttribute("user");
        System.out.println("user:" + user);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = user.getId();

        // Check if cart exists for this user
        Cart cart = cartService.getOrCreateCart(user);
        // return cart_id

        // add or update item into cartitem table
        cartService.addToCart(cart.getCartId(), productId, quantity);

        response.sendRedirect(request.getContextPath() + "/cart");
    }

}
