package controller;

import jakarta.annotation.Resource;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.transaction.UserTransaction;
import java.io.IOException;
import java.util.List;

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
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String gender = request.getParameter("gender");

            if (!password.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Passwords are not the same!");
                request.getRequestDispatcher("/view/login-register.jsp").forward(request, response);
            }

            List<User> userList = userService.getAllUser();

            for (User u : userList) {

                if (username.equals(u.getUsername())) {
                    request.setAttribute("errorMessage", "Username existed!");
                    request.getRequestDispatcher("/view/login-register.jsp").forward(request, response);
                }
            }

            User user = new User(username, password, email, phone, gender);

            utx.begin();
            userService.createUser(user);
            utx.commit();

            response.sendRedirect("/MajuTech/home");

        } catch (Exception e) {
            try {
                utx.rollback();
            } catch (Exception ignore) {
            }
            throw new ServletException(e);
        }
    }

}
