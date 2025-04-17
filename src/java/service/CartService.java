package service;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import model.Cart;
import model.User;
import model.CartItem;

import java.util.List;

@Stateless
public class CartService {
    
    @PersistenceContext(unitName = "MajuTechPU")
    private EntityManager em;
    
    public Cart getOrCreateCart(User user) {
        // Check if cart already exists
        List<Cart> carts = em.createQuery("SELECT c FROM Cart c WHERE c.user_id = :userId", Cart.class)
                .setParameter("userId", user.getId())
                .getResultList();

        if (!carts.isEmpty()) {
            return carts.get(0); // Existing cart
        }

        // If not found, create a new cart
        Cart cart = new Cart(user.getId());
        em.persist(cart);
        return cart;
    }

    public void addToCart(int cartId, int productId, int quantity) {

        // Check if item already exists in cart
        List<CartItem> items = em.createQuery("SELECT ci FROM CartItem ci WHERE ci.cartid = :cartId AND ci.productid = :productId", CartItem.class)
                .setParameter("cartId", cartId)
                .setParameter("productId", productId)
                .getResultList();

        if (!items.isEmpty()) {
            // Update quantity
            CartItem item = items.get(0);
            item.setQuantity(item.getQuantity() + quantity);
        } else {
            // Create new cart item
            CartItem newItem = new CartItem(cartId, productId, quantity);
            em.persist(newItem);
        }
    }
    
}
