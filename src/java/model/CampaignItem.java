package model;

import jakarta.persistence.*;

@Entity
@Table(name = "Campaign_Item")
public class CampaignItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "campaign_id")
    private int campaignId;

    @Column(name = "product_id")
    private int productId;

    @Column(name = "discounted_price")
    private double discountedPrice;

    public CampaignItem() {
    }

    public CampaignItem(int campaignId, int productId, double discountedPrice) {
        this.campaignId = campaignId;
        this.productId = productId;
        this.discountedPrice = discountedPrice;
    }

    // ==== Getters and Setters ====

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCampaignId() {
        return campaignId;
    }

    public void setCampaignId(int campaignId) {
        this.campaignId = campaignId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public double getDiscountedPrice() {
        return discountedPrice;
    }

    public void setDiscountedPrice(double discountedPrice) {
        this.discountedPrice = discountedPrice;
    }
}
