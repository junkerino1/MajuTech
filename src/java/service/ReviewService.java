package service;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
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

}
