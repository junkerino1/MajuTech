package controller;

import jakarta.annotation.Resource;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.transaction.UserTransaction;
import java.io.IOException;

import model.User;
import service.UserService;

public class RegisterServlet extends HttpServlet {

    @Inject
    private UserService userService;

    @Resource
    private UserTransaction utx;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            System.out.println("username:" + username);
            
            User user = new User(username, password);

            utx.begin();
            userService.createUser(user);
            utx.commit();
            
            response.sendRedirect("/home");
            
        } catch (Exception e) {
            try {
                utx.rollback();
            } catch (Exception ignore) {
            }
            throw new ServletException(e);
        }
    }
   
}