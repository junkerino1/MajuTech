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

public class DashboardServlet extends HttpServlet {

    @Inject
    private CartService cartService;
    
    @Inject
    private ProductService productService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
         request.getRequestDispatcher("/view/dashboard.jsp").forward(request, response);
        
    }
    
}
