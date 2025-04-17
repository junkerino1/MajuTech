package service;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import model.Category;

import java.util.List;

@Stateless
public class CategoryService {
    
    @PersistenceContext(unitName = "MajuTechPU")
    private EntityManager em;

    public List<Category> getAllCategory() {
        return em.createQuery("SELECT c FROM Category c", Category.class).getResultList();
    }
    
}
