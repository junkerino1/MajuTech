package controller;

import jakarta.annotation.Resource;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.transaction.UserTransaction;
import java.io.IOException;
import service.ProductService;

public class DeleteProductServlet extends HttpServlet {

    @Inject
    private ProductService productService;

    @Resource
    private UserTransaction utx;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int productId = Integer.parseInt(request.getParameter("id"));
        String message;
        try {
            utx.begin();
            productService.deleteProduct(productId);
            utx.commit();
            message = "Product with ID " + productId + " deleted successfully";
        } catch (Exception e) {
            try {
                utx.rollback();
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
            message = "Failed to delete product";
        }
        
        request.getSession().setAttribute("message", message);
        response.sendRedirect(request.getContextPath() + "/admin/product");
    }

}
