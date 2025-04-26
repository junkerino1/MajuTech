package model;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "REPLIES")
public class Reply implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @OneToOne
    @JoinColumn(name = "review_id")
    private Review review; 

    @Column(name = "username")
    private String username;

    @Column(name = "comment")
    private String comment;

    public Reply() {
    }

    public Reply(Review review, String username, String comment) {
        this.review = review;
        this.username = username;
        this.comment = comment;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Review getReview() {
        return review;
    }

    public void setReview(Review review) {
        this.review = review;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }
}
