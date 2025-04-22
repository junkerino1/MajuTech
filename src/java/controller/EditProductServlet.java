package controller;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import jakarta.annotation.Resource;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.util.List;

import jakarta.transaction.UserTransaction;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;
import model.Category;
import model.Product;
import service.ProductService;
import service.CategoryService;
import utils.CloudinaryConfig;
import utils.SSLUtil;

public class EditProductServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        try {
            // Disable SSL verification at startup
            SSLUtil.disableSslVerification();
        } catch (Exception e) {
            throw new ServletException("Error disabling SSL verification", e);
        }
    }

    @Inject
    private ProductService productService;

    @Inject
    private CategoryService categoryService;

    @Resource
    private UserTransaction utx;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String productName = request.getParameter("product_name");
        int categoryId = Integer.parseInt(request.getParameter("category_id"));
        double unitPrice = Double.parseDouble(request.getParameter("unit_price"));
        String description = request.getParameter("description");
        String specification = request.getParameter("specification");
        String status = request.getParameter("status");

        String message;

        Cloudinary cloudinary = CloudinaryConfig.getInstance();
        String[] imageUrls = new String[4];

        try {
            utx.begin();
            for (int i = 0; i < 4; i++) {
                Part filePart = request.getPart("image" + i);
                String existingImage = request.getParameter("existingImage" + i);

                if (filePart != null && filePart.getSize() > 0) {
                    InputStream imageStream = filePart.getInputStream();
                    byte[] imageBytes = imageStream.readAllBytes();

                    Map uploadResult = cloudinary.uploader().upload(imageBytes,
                            ObjectUtils.asMap("folder", "majutech_products/"));

                    imageUrls[i] = uploadResult.get("secure_url").toString();
                } else {
                    // Use existing image if no new upload
                    imageUrls[i] = existingImage;
                }
            }

            Product product = new Product(productName, unitPrice, categoryId, specification, description, status, imageUrls[0], imageUrls[1], imageUrls[2], imageUrls[3]);
            productService.updateProduct(product);
            utx.commit();
            message = "Successfully updated product details";

        } catch (Exception e) {
            try {
                utx.rollback();
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
            message = "Failed to update product details";
        }

        request.setAttribute("message", message);
        request.getRequestDispatcher("/view/list-product.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int productId = Integer.parseInt(request.getParameter("productId"));
        Product product = productService.getProductById(productId);
        List<Category> categories = categoryService.getAllCategory();

        request.setAttribute("categories", categories);
        request.setAttribute("product", product);
        request.getRequestDispatcher("/view/edit-product.jsp").forward(request, response);

    }

}
