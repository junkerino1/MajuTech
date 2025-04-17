package service;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import model.Product;

import java.util.List;

@Stateless
public class ProductService {

    @PersistenceContext(unitName = "MajuTechPU")
    private EntityManager em;

    public void addProduct(Product product) {
        em.persist(product);
    }

    public List<Product> getAllProducts() {
        return em.createQuery("SELECT p FROM Product p", Product.class).getResultList();
    }
    
    public Product getProductById(int productId) {
        return em.find(Product.class, productId);
    }
    
}
