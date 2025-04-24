package model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "ORDERS")
public class Order implements Serializable{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int order_id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "total_amount")
    private double total_amount;

    @Column(name = "payment_method")
    private String payment_method;

    @ManyToOne
    @JoinColumn(name = "address_id")
    private ShippingAddress shipping_address;

    @Column(name = "status")
    private String status;

    @Column(name = "date")
    private LocalDateTime date;

    public Order() {
    }

    public Order(User user, double total_amount, String payment_method, ShippingAddress shipping_address, String status) {
        this.user = user;
        this.total_amount = total_amount;
        this.payment_method = payment_method;
        this.shipping_address = shipping_address;
        this.status = status;
        this.date = LocalDateTime.now();
    }

    public int getOrderId() {
        return order_id;
    }

    public void setOrderId(int order_id) {
        this.order_id = order_id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public double getTotalAmount() {
        return total_amount;
    }

    public void setTotalAmount(double total_amount) {
        this.total_amount = total_amount;
    }

    public String getPaymentMethod() {
        return payment_method;
    }

    public void setPaymentMethod(String payment_method) {
        this.payment_method = payment_method;
    }

    public ShippingAddress getShippingAddress() {
        return shipping_address;
    }

    public void setShippingAddress(ShippingAddress shipping_address) {
        this.shipping_address = shipping_address;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getDate() {
        return date;
    }
    
    public void setDate(LocalDateTime date){
        this.date = date;
    }

   
}
