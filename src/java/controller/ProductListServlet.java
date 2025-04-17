package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import model.Product;
import service.ProductService;

import jakarta.persistence.*;
import java.io.*;
import java.util.List;

public class ProductListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        EntityManagerFactory emf = null;
        EntityManager em = null;

        try {
            // Create EntityManagerFactory and EntityManager
            emf = Persistence.createEntityManagerFactory("MajuTechPU");
            em = emf.createEntityManager();

            // Query all products
            List<Product> products = em.createQuery("SELECT p FROM Product p", Product.class).getResultList();

            // Set products as request attribute
            request.setAttribute("products", products);

            // Forward request to list-products.jsp
            request.getRequestDispatcher("/view/list-product.jsp").forward(request, response);

        } catch (PersistenceException e) {
            e.printStackTrace(); // Log the exception (or use a logger)
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred.");

        } finally {
            // Close resources if they were initialized
            if (em != null) em.close();
            if (emf != null) emf.close();
        }
    }
}


