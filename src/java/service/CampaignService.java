package service;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import java.time.LocalDate;
import model.Campaign;
import model.CampaignItem;

import java.util.List;

@Stateless
public class CampaignService {

    @PersistenceContext(unitName = "MajuTechPU")
    private EntityManager em;

    // Get all campaigns
    public List<Campaign> getAllCampaign() {
        return em.createQuery("SELECT c FROM Campaign c", Campaign.class)
                .getResultList();
    }

    public List<CampaignItem> getCampaignItem(int campaignId) {
        return em.createQuery("SELECT ci FROM CampaignItem ci WHERE ci.campaignId = :campaignId", CampaignItem.class)
                .setParameter("campaignId", campaignId)
                .getResultList();
    }

    public double getDiscountedPrice(int productId) {
        return em.createQuery("SELECT ci.discountedPrice FROM CampaignItem ci WHERE ci.productId = :prod", Double.class)
                .setParameter("prod", productId)
                .getSingleResult();
    }

    public void createNewCampaign(Campaign newCampaign) {
        em.persist(newCampaign);
    }

    public void createCampaignItems(CampaignItem item) {
        em.persist(item);
    }

    public Campaign getOngoingCampaign() {
        LocalDate currentDate = LocalDate.now();

        try {
            // Query to get the ongoing campaign based on current date
            Campaign currentCampaign = em.createQuery(
                    "SELECT c FROM Campaign c WHERE c.dateStart <= :currentDate AND c.dateEnd >= :currentDate", Campaign.class)
                    .setParameter("currentDate", currentDate)
                    .getSingleResult();

            // Return the found campaign
            return currentCampaign;

        } catch (NoResultException e) {
            // Handle case when no campaign is found
            return null;
        }
    }
}
