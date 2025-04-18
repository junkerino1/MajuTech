package service;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import model.Cart;
import model.User;
import model.Product;
import model.CartItem;

import java.util.List;
import model.ShippingAddress;

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

    public void addToCart(Cart cart, Product product, int quantity) {

        List<CartItem> items = em.createQuery(
                "SELECT ci FROM CartItem ci WHERE ci.cart = :cart AND ci.product = :product", CartItem.class)
                .setParameter("cart", cart)
                .setParameter("product", product)
                .getResultList();

        if (!items.isEmpty()) {
            CartItem item = items.get(0);
            item.setQuantity(item.getQuantity() + quantity);
        } else {
            CartItem newItem = new CartItem(cart, product, quantity);
            em.persist(newItem);
        }
    }

    public List<CartItem> displayAllCart(Cart cart) {

        List<CartItem> cartitems = em.createQuery("SELECT ci FROM CartItem ci WHERE ci.cart = :cart", CartItem.class)
                .setParameter("cart", cart)
                .getResultList();

        return cartitems;
    }

    public void removeFromCart(int cartItemId) {

        CartItem item = em.find(CartItem.class, cartItemId);
        if (item != null) {
            em.remove(item);
        }

    }

    public List<CartItem> getCartById(int cartId) {
        
        Cart cart = em.find(Cart.class, cartId);

        List<CartItem> cartitems = displayAllCart(cart);
        
        return cartitems;

    }

    public List<ShippingAddress> getAddressByUserId(int userId) {

        User user = em.find(User.class, userId);
        
        List<ShippingAddress> address = em.createQuery("SELECT ad FROM ShippingAddress ad WHERE ad.user = :user", ShippingAddress.class)
                .setParameter("user", user)
                .getResultList();

        return address;
    }
    
    public ShippingAddress getAddressById(int addressId){
        
        ShippingAddress address = em.find(ShippingAddress.class, addressId);
        
        return address;
    }
    
    public int createNewAddress(ShippingAddress newAddress){
        
        em.persist(newAddress);
        
        return newAddress.getId();
  
    }

}
