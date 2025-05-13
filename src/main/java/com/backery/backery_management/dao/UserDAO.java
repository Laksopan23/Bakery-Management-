package com.backery.backery_management.dao;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.backery.backery_management.model.User;

public class UserDAO {

    private final String filePath = "data/users.txt";

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        File file = new File(filePath);
        try {
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    if (line.trim().isEmpty()) {
                        continue;
                    }
                    String[] parts = line.split(",");
                    if (parts.length == 5) {
                        try {
                            int id = Integer.parseInt(parts[0].trim());
                            String username = parts[1].trim();
                            String password = parts[2].trim();
                            String email = parts[3].trim();
                            String role = parts[4].trim();
                            users.add(new User(id, username, password, email, role));
                        } catch (NumberFormatException e) {
                            System.err.println("Invalid ID format in users.txt: " + line);
                        }
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading users.txt: " + e.getMessage());
        }
        return users;
    }

    public boolean saveUser(User user) {
        try {
            File file = new File(filePath);
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath, true))) {
                writer.write(user.toString());
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            System.err.println("Error saving user: " + e.getMessage());
            return false;
        }
    }

    public void updateUser(User updatedUser) {
        List<User> users = getAllUsers();
        File file = new File(filePath);
        try {
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
                boolean updated = false;
                for (User u : users) {
                    if (u.getId() == updatedUser.getId()) {
                        writer.write(updatedUser.toString());
                        updated = true;
                    } else {
                        writer.write(u.toString());
                    }
                    writer.newLine();
                }
                if (!updated && updatedUser.getId() > 0) {
                    writer.write(updatedUser.toString());
                    writer.newLine();
                }
            }
        } catch (IOException e) {
            System.err.println("Error updating users.txt: " + e.getMessage());
        }
    }

    public void deleteUser(int id) {
        List<User> users = getAllUsers();
        File file = new File(filePath);
        try {
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
                boolean deleted = false;
                for (User u : users) {
                    if (u.getId() != id) {
                        writer.write(u.toString());
                        writer.newLine();
                    } else {
                        deleted = true;
                    }
                }
                if (!deleted) {
                    System.err.println("User with ID " + id + " not found for deletion.");
                }
            }
        } catch (IOException e) {
            System.err.println("Error deleting from users.txt: " + e.getMessage());
        }
    }

    public User getUserById(int id) {
        return getAllUsers().stream()
                .filter(u -> u.getId() == id)
                .findFirst()
                .orElse(null);
    }

    public boolean authenticateUser(String username, String password) {
        User user = findByUsername(username);
        return user != null && user.getPassword().equals(password);
    }

    public boolean isUsernameExists(String username) {
        return findByUsername(username) != null;
    }

    public User findByUsername(String username) {
        List<User> users = getAllUsers();
        return users.stream()
                .filter(user -> user.getUsername().equals(username))
                .findFirst()
                .orElse(null);
    }
}
