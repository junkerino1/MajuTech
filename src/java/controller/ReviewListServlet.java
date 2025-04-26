package controller;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Review;
import model.Reply;
import service.ReviewService;

public class ReviewListServlet extends HttpServlet {

    @Inject
    private ReviewService reviewService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Fetch all reviews
        List<Review> reviews = reviewService.getAllReviews();

        for (Review review : reviews) {
            Reply reply = reviewService.getReplyByReviewId(review.getId());
            if (reply != null) {
                review.setReply(reply);
            }
        }

        request.setAttribute("reviews", reviews);

        request.getRequestDispatcher("/view/reply-review.jsp").forward(request, response);
    }
}
