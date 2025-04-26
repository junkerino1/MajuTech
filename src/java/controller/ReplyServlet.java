package controller;

import jakarta.annotation.Resource;
import jakarta.inject.Inject;
import model.Reply;
import model.Review;
import service.ReviewService;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.transaction.UserTransaction;
import java.io.IOException;
import model.Admin;

public class ReplyServlet extends HttpServlet {

    @Inject
    private ReviewService reviewService;

    @Resource
    private UserTransaction utx;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int reviewId = Integer.parseInt(request.getParameter("reviewId"));
        String comment = request.getParameter("comment");

        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("admin");

        String username = admin.getUsername();

        Review review = reviewService.getReviewById(reviewId);

        try {
            if (review != null) {
                Reply reply = new Reply(review, username, comment);

                utx.begin();
                reviewService.saveReply(reply);
                utx.commit();

                response.sendRedirect(request.getContextPath() + "/admin/review");
            } else {
                request.setAttribute("message", "Review not found.");
                request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
            }
        } catch (Exception e) {
            try {
                utx.rollback();
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
            throw new ServletException("Error replying ", e);
        }
    }
}
