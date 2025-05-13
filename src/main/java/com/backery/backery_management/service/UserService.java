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

    public boolean registerUser(String username, String password, String email, String role) {
        if (!isValidRegistration(username, password, email)) {
            return false;
        }
        if (userDAO.isUsernameExists(username)) {
            return false;
        }
        List<User> users = userDAO.getAllUsers();
        int newId = users.isEmpty() ? 1 : users.get(users.size() - 1).getId() + 1;
        User newUser = new User(newId, username, password, email, role);
        return userDAO.saveUser(newUser);
    }

    public boolean authenticateUser(String username, String password) {
        return userDAO.authenticateUser(username, password);
    }

    private boolean isValidRegistration(String username, String password, String email) {
        if (username == null || username.trim().isEmpty()
                || email == null || email.trim().isEmpty()) {
            return false;
        }
        // Password can be empty for non-admin users, but required for admin
        return EMAIL_PATTERN.matcher(email.trim()).matches();
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
        if (user == null || user.getUsername() == null || user.getUsername().trim().isEmpty()
                || user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            return false;
        }
        // Validate role
        if (user.getRole() == null || (!user.getRole().equals("Admin") && !user.getRole().equals("User"))) {
            return false;
        }
        return EMAIL_PATTERN.matcher(user.getEmail().trim()).matches();
    }

    private boolean userExists(int id) {
        return getUserById(id) != null;
    }
}
