package service;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.Product;
import model.Review;

@Stateless
public class ReviewService {

    @PersistenceContext(unitName = "MajuTechPU")
    private EntityManager em;

    public void addReview(Review review) {
        em.persist(review);
    }

    public boolean reviewExists(int orderId, int productId) {

        Order order = em.find(Order.class, orderId);
        Product product = em.find(Product.class, productId);

        Long count = (Long) em.createQuery("SELECT COUNT(r) FROM Review r WHERE r.order = :orderId AND r.product = :productId")
                .setParameter("orderId", order)
                .setParameter("productId", product)
                .getSingleResult();
        return count > 0;
    }

    public List<Review> getReviewByProduct(Product product) {
        try {
            List<Review> reviews = em.createQuery("SELECT r FROM Review r WHERE r.product = :product", Review.class)
                    .setParameter("product", product)
                    .getResultList();
            if (reviews == null || reviews.isEmpty()) {
                return new ArrayList<>();
            }

            return reviews;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}
