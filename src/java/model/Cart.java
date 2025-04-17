package model;

import jakarta.persistence.*;

@Entity
@Table(name = "Cart")
public class Cart {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int cart_id;

    @Column(name = "user_id")
    private int user_id;

    public Cart() {
    }

    public Cart(int user_id) {
        this.user_id = user_id;
    }

    public int getCartId() {
        return cart_id;
    }

    public void setCartId(int cart_id) {
        this.cart_id = cart_id;
    }

    public int getUserId() {
        return user_id;
    }

    public void setUserId(int user_id) {
        this.user_id = user_id;
    }


}
