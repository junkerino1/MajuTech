package controller;

import jakarta.inject.Inject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Product;
import service.CartService;
import service.ProductService;

import java.io.IOException;
import model.Cart;
import model.User;
import model.CartItem;

public class RemoveFromCartServlet extends HttpServlet {

    @Inject
    private ProductService productService;

    @Inject
    private CartService cartService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int cartItemId = Integer.parseInt(request.getPathInfo().substring(1));

        cartService.removeFromCart(cartItemId);
        response.sendRedirect(request.getContextPath() + "/cart");

    }
}
