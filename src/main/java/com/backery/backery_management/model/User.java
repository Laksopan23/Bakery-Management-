package com.backery.backery_management.model;

public class User {

    private int id;
    private String username;
    private String password;
    private String email;
    private String role;

    public User(int id, String username, String password, String email, String role) {
        this.id = id;
        this.username = username != null ? username : "";
        this.password = password != null ? password : "";
        this.email = email != null ? email : "";
        this.role = role != null ? role : "User";
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username != null ? username : "";
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password != null ? password : "";
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email != null ? email : "";
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role != null ? role : "User";
    }

    @Override
    public String toString() {
        return id + "," + username + "," + password + "," + email + "," + role;
    }
}
