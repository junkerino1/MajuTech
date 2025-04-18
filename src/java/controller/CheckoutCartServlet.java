package controller;

import jakarta.inject.Inject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import service.CartService;

import java.io.IOException;
import java.util.List;
import model.User;
import model.CartItem;
import model.ShippingAddress;

public class CheckoutCartServlet extends HttpServlet {

    @Inject
    private CartService cartService;

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
        
        List<ShippingAddress> address = cartService.getAddressByUserId(user.getId());
        
        request.setAttribute("cartId", cartId);
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("address", address);

        
        request.getRequestDispatcher("/view/shipping-address.jsp").forward(request, response);
        
    }
    
}