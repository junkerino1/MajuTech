package service;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import model.Admin;

@Stateless
public class AdminService {

    @PersistenceContext(unitName = "MajuTechPU")
    private EntityManager em;

    public void createAdmin(Admin admin) {
        em.persist(admin);
    }
    
    public Admin findByUsername(String username) {
    try {
        return em.createQuery("SELECT a FROM Admin a WHERE a.username = :username", Admin.class)
                 .setParameter("username", username)
                 .getSingleResult();
    } catch (Exception e) {
        return null;
    }
}
}
