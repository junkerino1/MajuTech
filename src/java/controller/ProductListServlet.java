package controller;

import jakarta.inject.Inject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Product;
import service.ProductService;

import jakarta.persistence.*;
import java.io.*;
import java.util.List;
import model.Category;
import service.CategoryService;

public class ProductListServlet extends HttpServlet {

    @Inject
    public ProductService productService;

    @Inject
    public CategoryService categoryService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> products = productService.getAllProducts();
        List<Category> categories = categoryService.getAllCategory();

        request.setAttribute("categories", categories);
        request.setAttribute("products", products);
        request.getRequestDispatcher("/view/list-product.jsp").forward(request, response);
    }
}
