package com.backery.backery_management.model;

public class Product {

    private int id;
    private String name;
    private String description;
    private String category;
    private double price;
    private int initialStock;
    private int currentStock;
    private String image;

    public Product(int id, String name, String description, String category, double price, int initialStock, int currentStock, String image) {
        this.id = id;
        this.name = name != null ? name : "";
        this.description = description != null ? description : "";
        this.category = category != null ? category : "";
        this.price = price;
        this.initialStock = initialStock;
        this.currentStock = currentStock;
        this.image = image != null ? image : "";
    }

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
        this.name = name != null ? name : "";
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description != null ? description : "";
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category != null ? category : "";
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
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
        this.image = image != null ? image : "";
    }

    @Override
    public String toString() {
        return id + "," + name + "," + description + "," + category + "," + price + "," + initialStock + "," + currentStock + "," + image;
    }
}
