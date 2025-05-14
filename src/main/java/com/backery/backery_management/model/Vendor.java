package com.backery.backery_management.model;

public class Vendor {
    private int id;
    private String name;
    private String email;
    private String phone;
    private String company;

    public Vendor(int id, String name, String email, String phone, String company) {
        this.id = id;
        this.name = name != null ? name : "";
        this.email = email != null ? email : "";
        this.phone = phone != null ? phone : "";
        this.company = company != null ? company : "";
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name != null ? name : ""; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email != null ? email : ""; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone != null ? phone : ""; }
    public String getCompany() { return company; }
    public void setCompany(String company) { this.company = company != null ? company : ""; }

    @Override
    public String toString() {
        return id + "," + name + "," + email + "," + phone + "," + company;
    }
} 