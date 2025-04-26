package service;

import jakarta.ejb.Stateless;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import model.Product;

import java.util.List;
import model.Category;
import jakarta.persistence.EntityNotFoundException;

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
        if (product == null) {
            throw new EntityNotFoundException("Product with ID " + productId + " not found");
        }
        
        if ("promotion".equalsIgnoreCase(product.getStatus())) {
            product.setEffectivePrice(campaignService.getDiscountedPrice(productId));
        } else {
            product.setEffectivePrice(product.getUnitPrice());
        }
        return product;
    }

    @Transactional
    public boolean updateProduct(Product product) {
        try {
            em.merge(product);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates product quantity after successful payment
     * @param productId ID of the product to update
     * @param quantityToDeduct Quantity to subtract from current inventory
     * @return true if update successful, false otherwise
     */
    @Transactional
    public boolean updateProductQuantity(int productId, int quantityToDeduct) {
        try {
            Product product = getProductById(productId);
            int currentQuantity = product.getQuantity();
            
            // Validate we have enough inventory
            if (currentQuantity < quantityToDeduct) {
                return false;
            }
            
            // Update the quantity
            int newQuantity = currentQuantity - quantityToDeduct;
            product.setQuantity(newQuantity);
            
            // Save the updated product
            em.merge(product);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Batch update product quantities for multiple products in a single transaction
     * @param productQuantities Map of product IDs and quantities to deduct
     * @return true if all updates successful, false if any fail
     */
    @Transactional
    public boolean batchUpdateProductQuantities(List<ProductQuantity> productQuantities) {
        try {
            for (ProductQuantity pq : productQuantities) {
                boolean updated = updateProductQuantity(pq.getProductId(), pq.getQuantity());
                if (!updated) {
                    return false;
                }
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Transactional
    public void deleteProduct(int productId) {
        Product product = em.find(Product.class, productId);
        if (product != null) {
            em.remove(product);
        }
    }

    public String getCategoryNameById(int categoryId) {
        return em.createQuery("SELECT c.categoryName FROM Category c WHERE c.id = :id", String.class)
                .setParameter("id", categoryId)
                .getSingleResult();
    }
    
    /**
     * Checks if a product has sufficient quantity available
     * @param productId ID of the product to check
     * @param requestedQuantity Quantity requested
     * @return true if sufficient quantity available, false otherwise
     */
    public boolean isProductAvailable(int productId, int requestedQuantity) {
        try {
            Product product = getProductById(productId);
            return product != null && product.getQuantity() >= requestedQuantity;
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * Helper class to store product ID and quantity pairs for batch updates
     */
    public static class ProductQuantity {
        private int productId;
        private int quantity;
        
        public ProductQuantity(int productId, int quantity) {
            this.productId = productId;
            this.quantity = quantity;
        }
        
        public int getProductId() {
            return productId;
        }
        
        public int getQuantity() {
            return quantity;
        }
    }
}