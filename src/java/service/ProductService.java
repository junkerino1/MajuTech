package service;

import jakarta.ejb.Stateless;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import model.Product;

import java.util.List;

@Stateless
public class ProductService {

    @PersistenceContext(unitName = "MajuTechPU")
    private EntityManager em;

    @Inject
    private CampaignService campaignService;

    public void addProduct(Product product) {
        em.persist(product);
    }

    public List<Product> getAllProducts() {
        List<Product> products = em.createQuery("SELECT p FROM Product p", Product.class).getResultList();
        for (Product product : products) {
            if ("promotion".equalsIgnoreCase(product.getStatus())) {
                product.setEffectivePrice(campaignService.getDiscountedPrice(product.getId()));
            } else {
                product.setEffectivePrice(product.getUnitPrice());
            }
        }
        return products;
    }

    public Product getProductById(int productId) {
        Product product = em.find(Product.class, productId);
        if ("promotion".equalsIgnoreCase(product.getStatus())) {
            product.setEffectivePrice(campaignService.getDiscountedPrice(productId));
        } else {
            product.setEffectivePrice(product.getUnitPrice());
        }
        return product;
    }

    public void updateProduct(Product product) {

        em.merge(product);

    }

    public void deleteProduct(int productId) {
        Product product = em.find(Product.class, productId);
        em.remove(product);
    }

}
