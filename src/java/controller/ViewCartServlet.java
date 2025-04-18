package controller;

import jakarta.inject.Inject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Product;
import service.CartService;
import service.ProductService;

import java.io.IOException;
import java.util.*;
import model.Cart;
import model.User;
import model.CartItem;

public class ViewCartServlet extends HttpServlet {

    @Inject
    private ProductService productService;

    @Inject
    private CartService cartService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // get user_id from session
        User user = (User) request.getSession().getAttribute("user");
        System.out.println("user:" + user);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if cart exists for this user
        Cart cart = cartService.getOrCreateCart(user);
        int cartId = cart.getCartId();

        List<CartItem> cartItems = cartService.displayAllCart(cart);
        List<Product> productsInCart = new ArrayList<>();

        for (CartItem item : cartItems) {
            int productId = item.getProduct().getId();
            Product product = productService.getProductById(productId);
            productsInCart.add(product);
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("productsInCart", productsInCart);
        request.setAttribute("cartId", cartId);
        request.getRequestDispatcher("/view/cart.jsp").forward(request, response);
    }
}
