package controller;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

import model.User;
import service.UserService;

public class LoginServlet extends HttpServlet {

    @Inject
    private UserService userService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            User user = userService.findByUsername(username);

            if (user != null && user.getPassword().equals(password)) {
                // Success
                request.getSession().setAttribute("user", user);
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                request.setAttribute("errorMessage", "Invalid username or password");
                request.getRequestDispatcher("/view/login-register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            throw new ServletException("Login failed", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/view/login-register.jsp").forward(request, response);

    }
}
