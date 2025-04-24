package service;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;
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

    public List<Admin> getAllAdmin() {
        return em.createQuery("SELECT a FROM Admin a", Admin.class)
                .getResultList();
    }
    
    public void deleteAdmin(int adminId) {
        Admin admin = em.find(Admin.class, adminId);
        em.remove(admin);
    }


}
