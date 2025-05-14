package com.backery.backery_management.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Review {
    private int id;
    private int productId;
    private String customerName;
    private int rating;
    private String comment;
    private LocalDateTime createdAt;
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");

    public Review(int id, int productId, String customerName, int rating, String comment, LocalDateTime createdAt) {
        this.id = id;
        this.productId = productId;
        this.customerName = customerName;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return createdAt != null ? createdAt.format(formatter) : "";
    }
} 