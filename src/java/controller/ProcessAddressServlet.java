package controller;

import jakarta.annotation.Resource;
import jakarta.inject.Inject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.transaction.UserTransaction;
import service.CartService;

import java.io.IOException;
import java.util.List;
import model.User;
import model.CartItem;
import model.ShippingAddress;

public class ProcessAddressServlet extends HttpServlet {

    @Inject
    private CartService cartService;

    @Resource
    private UserTransaction utx;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int cartId = Integer.parseInt(request.getParameter("cartId"));
            int addressId;

            ShippingAddress shippingAddress;

            // get user_id from session
            User user = (User) request.getSession().getAttribute("user");
            System.out.println("user:" + user);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // if user enter a new address
            if ("true".equals(request.getParameter("newAddress"))) {

                String name = request.getParameter("name");
                String street1 = request.getParameter("street1");
                String street2 = request.getParameter("street2");
                String state = request.getParameter("state");
                int postcode = Integer.parseInt(request.getParameter("postcode"));
                String phoneNumber = request.getParameter("phoneNumber");

                shippingAddress = new ShippingAddress(name, user, street1, street2, state, postcode, phoneNumber);

                utx.begin();
                cartService.createNewAddress(shippingAddress);
                utx.commit();

                addressId = shippingAddress.getId();

            } // if user click the existing address
            else {
                // Handle existing address
                addressId = Integer.parseInt(request.getParameter("existingAddressId"));
            }

            // Redirect to confirmation
            response.sendRedirect("payment?cartId=" + cartId + "&addressId=" + addressId);

        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/checkout").forward(request, response);
        }
    }

}
