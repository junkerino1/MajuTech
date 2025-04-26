package service;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.time.LocalDate;
import java.util.Date;
import model.Order;

import java.util.List;
import model.OrderItem;
import model.User;

@Stateless
public class OrderService {

    @PersistenceContext(unitName = "MajuTechPU")
    private EntityManager em;

    public List<Order> getAllOrder() {
        return em.createQuery("SELECT o FROM Order o", Order.class).getResultList();
    }

    public List<Order> getAllOrderDesc() {
        return em.createQuery("SELECT o FROM Order o ORDER BY o.date DESC", Order.class)
                .getResultList();
    }

    public void createNewOrder(Order order) {
        em.persist(order);
    }

    public void createNewOrderItem(OrderItem orderItem) {
        em.persist(orderItem);
    }

    public List<OrderItem> getOrderItemByOrder(Order order) {

        return em.createQuery(
                "SELECT ot FROM OrderItem ot WHERE ot.order = :order", OrderItem.class)
                .setParameter("order", order)
                .getResultList();
    }

    public Order getOrderById(int orderId) {
        return em.createQuery(
                "SELECT o FROM Order o WHERE o.order_id = :orderId", Order.class)
                .setParameter("orderId", orderId)
                .getSingleResult();
    }

    public List<Order> getOrderByUser(User user) {
        return em.createQuery(
                "SELECT o FROM Order o WHERE o.user = :user", Order.class)
                .setParameter("user", user)
                .getResultList();
    }

    public void updateOrder(Order order) {
        em.merge(order);
    }

    public List<Order> getOrderByMonth(int year, int month) {

        String query = """
        SELECT o FROM Order o
        WHERE FUNCTION('YEAR', o.date) = :year
        AND FUNCTION('MONTH', o.date) = :month""";

        return em.createQuery(query, Order.class)
                .setParameter("year", year)
                .setParameter("month", month)
                .getResultList();
    }

    public List<Order> getOrderByDate(LocalDate date) {

        String query = """
        SELECT o FROM Order o
        WHERE FUNCTION('DATE', o.date) = :date""";

        return em.createQuery(query, Order.class)
                .setParameter("date", date)
                .getResultList();

    }
    
    public List<Object[]> getTop10SellingProducts() {
        return em.createQuery(
                "SELECT p.id, p.productName, p.unitPrice, p.image1, p.category_id, SUM(oi.quantity) "
                + "FROM OrderItem oi JOIN oi.product p "
                + "GROUP BY p.id, p.productName, p.unitPrice, p.image1, p.category_id "
                + "ORDER BY SUM(oi.quantity) DESC", Object[].class)
                .setMaxResults(10)
                .getResultList();
    }
    
    public boolean deleteOrder(int orderId) {
        try {
            // First use find instead of query to get the order - safer approach
            Order order = em.find(Order.class, orderId);
            
            // Check if order exists
            if (order == null) {
                return false;  // Order doesn't exist, nothing to delete
            }
            
            // Get related order items
            List<OrderItem> orderItems = getOrderItemByOrder(order);
            
            // Delete order items first
            for (OrderItem item : orderItems) {
                if (item != null) {
                    em.remove(em.contains(item) ? item : em.merge(item));
                }
            }
            
            // Then delete the order using a safer approach
            em.remove(em.contains(order) ? order : em.merge(order));
            
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


}
