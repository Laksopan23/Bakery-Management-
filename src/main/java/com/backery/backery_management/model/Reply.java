package com.backery.backery_management.model;

import java.time.LocalDateTime;

public class Reply {
    private int id;
    private int reviewId;
    private String adminName;
    private String comment;
    private LocalDateTime createdAt;

    public Reply(int id, int reviewId, String adminName, String comment, LocalDateTime createdAt) {
        this.id = id;
        this.reviewId = reviewId;
        this.adminName = adminName;
        this.comment = comment;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public String getAdminName() {
        return adminName;
    }

    public void setAdminName(String adminName) {
        this.adminName = adminName;
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
} 