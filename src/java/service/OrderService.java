package service;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import model.Order;

import java.util.List;
import model.OrderItem;

@Stateless
public class OrderService {

    @PersistenceContext(unitName = "MajuTechPU")
    private EntityManager em;

    public List<Order> getAllOrder() {
        return em.createQuery("SELECT o FROM Order o", Order.class).getResultList();
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

}
