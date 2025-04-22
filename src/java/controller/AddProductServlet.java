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

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class AddProductServlet extends HttpServlet {

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
        
        try {
            // Handle multiple image uploads
            List<Part> imageParts = request.getParts()
                    .stream()
                    .filter(part -> "images".equals(part.getName()) && part.getSize() > 0)
                    .toList();

            utx.begin();

            Cloudinary cloudinary = CloudinaryConfig.getInstance();
            String[] imageUrls = new String[4];

            for (int i = 0; i < Math.min(4, imageParts.size()); i++) {
                Part imagePart = imageParts.get(i);
                InputStream imageStream = imagePart.getInputStream();
                byte[] imageBytes = imageStream.readAllBytes();

                Map uploadResult = cloudinary.uploader().upload(imageBytes,
                        ObjectUtils.asMap("folder", "majutech_products/"));
                imageUrls[i] = uploadResult.get("secure_url").toString();

                // Debugging purpose 
                System.out.println("Image URL: " + imageUrls[i]);
            }

            // Create Product entity
            Product product = new Product(productName, unitPrice, categoryId, specification, description, status, imageUrls[0], imageUrls[1], imageUrls[2], imageUrls[3]);

            productService.addProduct(product);
            utx.commit();

            // Redirect after success
            response.sendRedirect("products-list");

        } catch (Exception e) {
            try {
                utx.rollback();
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
            throw new ServletException("Error adding product", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Category> categories = categoryService.getAllCategory();
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/view/add-product.jsp").forward(request, response);
    }

}
