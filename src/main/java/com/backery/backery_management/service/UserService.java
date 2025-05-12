package com.backery.backery_management.service;

import java.util.List;
import java.util.regex.Pattern;

import org.springframework.stereotype.Service;

import com.backery.backery_management.dao.UserDAO;
import com.backery.backery_management.model.User;

@Service
public class UserService {

    private final UserDAO userDAO = new UserDAO();
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");

    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }

    public boolean addUser(User user) {
        if (!isValidUser(user)) {
            return false;
        }
        List<User> users = userDAO.getAllUsers();
        int newId = users.isEmpty() ? 1 : users.get(users.size() - 1).getId() + 1;
        user.setId(newId);
        if (!userExists(newId)) {
            userDAO.saveUser(user);
            return true;
        }
        return false;
    }

    public boolean updateUser(User user) {
        if (!isValidUser(user)) {
            return false;
        }
        User existingUser = getUserById(user.getId());
        if (existingUser != null) {
            userDAO.updateUser(user);
            return true;
        }
        return false;
    }

    public boolean deleteUser(int id) {
        User user = getUserById(id);
        if (user != null) {
            userDAO.deleteUser(id);
            return true;
        }
        return false;
    }

    public User getUserById(int id) {
        return userDAO.getUserById(id);
    }

    private boolean isValidUser(User user) {
        if (user == null || user.getName() == null || user.getName().trim().isEmpty()
                || user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            return false;
        }
        return EMAIL_PATTERN.matcher(user.getEmail().trim()).matches();
    }

    private boolean userExists(int id) {
        return getUserById(id) != null;
    }
}
