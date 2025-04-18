package service;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
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
}
