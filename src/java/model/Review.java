package model;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(
    name = "REVIEWS",
    uniqueConstraints = @UniqueConstraint(columnNames = {"order_id", "product_id"})
)
public class Review implements Serializable{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "order_id", nullable = false)
    private Order order;

    @ManyToOne
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    @Column(name ="username")
    private String username;

    @Column(name ="rating")
    private int rating;

    @Column(name= "comment")
    private String comment;
    
    @OneToOne
    @JoinColumn(name = "reply_id")
    private Reply reply;

    public Review(Order order, Product product, String username, int rating, String comment) {
        this.order = order;
        this.product = product;
        this.username = username;
        this.rating = rating;
        this.comment = comment;
    }
    

    public Review() {
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Reply getReply() {
        return reply;
    }

    public void setReply(Reply reply) {
        this.reply = reply;
    }
    
    
    
}