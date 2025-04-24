/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Admin;
import service.AdminService;

public class AdminListServlet extends HttpServlet {
    
    @Inject
    private AdminService adminService;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Admin> adminList = adminService.getAllAdmin();
        
        request.setAttribute("adminList", adminList);
        request.getRequestDispatcher("/view/admin-list.jsp").forward(request, response);
        
    }

    
}
