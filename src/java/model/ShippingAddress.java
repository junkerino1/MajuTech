package model;

import jakarta.persistence.*;

@Entity
@Table(name = "SHIPPING_ADDRESS")
public class ShippingAddress {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
    
    @Column(name = "name")
    private String name;

    @Column(name = "street1")
    private String street1;
    
    @Column(name = "street2")
    private String street2;
    
    @Column(name = "state")
    private String state;
    
    @Column(name = "postcode")
    private int postcode;
    
    @Column(name = "phone_number")
    private String phoneNumber;

    public ShippingAddress() {
    }

    public ShippingAddress(String name, User user, String street1, String street2, String state, int postcode, String phoneNumber) {
        this.name = name;
        this.user = user;
        this.street1 = street1;
        this.street2 = street2;
        this.state = state;
        this.postcode = postcode;
        this.phoneNumber = phoneNumber;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getStreet1() {
        return street1;
    }

    public void setStreet1(String street1) {
        this.street1 = street1;
    }

    public String getStreet2() {
        return street2;
    }

    public void setStreet2(String street2) {
        this.street2 = street2;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public int getPostcode() {
        return postcode;
    }

    public void setPostcode(int postcode) {
        this.postcode = postcode;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }


}
