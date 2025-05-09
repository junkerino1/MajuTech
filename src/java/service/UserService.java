package service;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;
import model.User;

@Stateless
public class UserService {

    @PersistenceContext(unitName = "MajuTechPU")
    private EntityManager em;

    public void createUser(User user) {
        em.persist(user);
    }

    public User findByUsername(String username) {
        try {
            return em.createQuery("SELECT u FROM User u WHERE u.username = :username", User.class)
                    .setParameter("username", username)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }

    public List<User> getAllUser() {
        return em.createQuery("SELECT u FROM User u", User.class)
                .getResultList();
    }
    public void deleteUser(int userId) {
        User user = em.find(User.class, userId);
        em.remove(user);
    }
}
