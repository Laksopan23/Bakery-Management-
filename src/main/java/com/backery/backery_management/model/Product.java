package com.backery.backery_management.model;

public class Product {

    private int id;
    private String name;
    private String description;
    private String category;
    private double price;
    private int quantityAvailable;
    private int initialStock;
    private int currentStock;
    private String image;

    public Product(int id, String name, String description, String category, double price, int quantityAvailable,
            int initialStock, int currentStock, String image) {
        this.id = id;
        this.name = name != null ? name.trim() : "";
        this.description = description != null ? description.trim() : "";
        this.category = category != null ? category.trim() : "";
        this.price = price;
        this.quantityAvailable = quantityAvailable;
        this.initialStock = initialStock;
        this.currentStock = currentStock;
        this.image = image != null ? image.trim() : "";
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name != null ? name.trim() : "";
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description != null ? description.trim() : "";
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category != null ? category.trim() : "";
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantityAvailable() {
        return quantityAvailable;
    }

    public void setQuantityAvailable(int quantityAvailable) {
        this.quantityAvailable = quantityAvailable;
    }

    public int getInitialStock() {
        return initialStock;
    }

    public void setInitialStock(int initialStock) {
        this.initialStock = initialStock;
    }

    public int getCurrentStock() {
        return currentStock;
    }

    public void setCurrentStock(int currentStock) {
        this.currentStock = currentStock;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image != null ? image.trim() : "";
    }

    @Override
    public String toString() {
        return String.format("%d|||%s|||%s|||%s|||%.2f|||%d|||%d|||%d|||%s",
                id, name, description, category, price, quantityAvailable, initialStock, currentStock, image);
    }
}
