package service;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import java.time.LocalDate;
import model.Campaign;
import model.CampaignItem;

import java.util.List;
import model.Product;

@Stateless
public class CampaignService {

    @PersistenceContext(unitName = "MajuTechPU")
    private EntityManager em;

    // Get all campaigns
    public List<Campaign> getAllCampaign() {
        return em.createQuery("SELECT c FROM Campaign c", Campaign.class)
                .getResultList();
    }

    public Campaign getCampaignById(int campaignId) {
        return em.find(Campaign.class, campaignId);
    }

    public void editCampaign(Campaign campaign) {
        em.merge(campaign);
    }

    public List<CampaignItem> getCampaignItem(int campaignId) {
        return em.createQuery("SELECT ci FROM CampaignItem ci WHERE ci.campaignId = :campaignId", CampaignItem.class)
                .setParameter("campaignId", campaignId)
                .getResultList();
    }

    public Double getDiscountedPrice(int productId) {
        try {
            return em.createQuery("SELECT ci.discountedPrice FROM CampaignItem ci WHERE ci.productId = :prod", Double.class)
                    .setParameter("prod", productId)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }

    }

    public void createNewCampaign(Campaign newCampaign) {
        em.persist(newCampaign);
    }

    public void createCampaignItems(CampaignItem item) {
        em.persist(item);
    }

    public void deleteCampaignItem(int campaignId) {

        List<CampaignItem> items = getCampaignItem(campaignId);

        for (CampaignItem item : items) {

            Product product = em.find(Product.class, item.getProductId());
            product.setStatus("normal");
            em.merge(product);

            em.remove(item);
        }
    }

    public Campaign getOngoingCampaign() {
//        LocalDate currentDate = LocalDate.now();
        LocalDate currentDate = LocalDate.of(2025, 5, 2);

        try {
            // get the ongoing campaign based on current date
            Campaign currentCampaign = em.createQuery(
                    "SELECT c FROM Campaign c WHERE c.dateStart <= :currentDate AND c.dateEnd >= :currentDate", Campaign.class)
                    .setParameter("currentDate", currentDate)
                    .getSingleResult();

            // Return the found campaign
            return currentCampaign;

        } catch (NoResultException e) {
            // return null if no event
            return null;
        }
    }

    public void checkOngoingCampaign() {
//        LocalDate currentDate = LocalDate.now();
        LocalDate currentDate = LocalDate.of(2025, 5, 2);
        
        Campaign activeCampaign;
        try {
            activeCampaign = em.createQuery(
                    "SELECT c FROM Campaign c WHERE c.status = 'active'", Campaign.class)
                    .getSingleResult();
        } catch (NoResultException e) {
            activeCampaign = null;
            System.out.println("no active campaign");
        }

        if (activeCampaign != null) {
            // Check if campaign is expired (currentDate is after endDate)
            if (currentDate.isAfter(activeCampaign.getDateEnd())) {

                // Fetch old campaign items
                List<CampaignItem> activeCampaignItems = getCampaignItem(activeCampaign.getId());

                // Reset status of all related products to "normal"
                for (CampaignItem item : activeCampaignItems) {
                    Product product = em.find(Product.class, item.getProductId());
                    if (product != null) {
                        product.setStatus("normal");
                        em.merge(product);
                    }
                }

                // Mark old campaign as expired
                activeCampaign.setStatus("expired");
                em.merge(activeCampaign);
                
                setNewCampaign();

            }
            else{
                
            }
        } else{
            setNewCampaign();
        }        
    }
    
    public void setNewCampaign(){
        Campaign newCampaign = getOngoingCampaign();

        if (newCampaign != null) {
            newCampaign.setStatus("active");
            em.merge(newCampaign);

            List<CampaignItem> newCampaignItems = getCampaignItem(newCampaign.getId());
            for (CampaignItem item : newCampaignItems) {
                Product product = em.find(Product.class, item.getProductId());
                if (product != null) {
                    product.setStatus("promotion");
                    em.merge(product);
                }
            }
        }
    }
    
    public void deleteCampaign(int campaignId){
        Campaign c = em.find(Campaign.class, campaignId);
        em.remove(c);
    }

}
