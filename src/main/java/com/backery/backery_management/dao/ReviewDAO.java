package com.backery.backery_management.dao;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import com.backery.backery_management.model.Review;

public class ReviewDAO {
    private final String filePath = "data/reviews.txt";
    private final DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;

    public List<Review> getReviewsByProductId(int productId) {
        List<Review> reviews = new ArrayList<>();
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
                    if (parts.length >= 6) {
                        int id = Integer.parseInt(parts[0].trim());
                        int prodId = Integer.parseInt(parts[1].trim());
                        if (prodId == productId) {
                            String customerName = parts[2].trim();
                            int rating = Integer.parseInt(parts[3].trim());
                            String comment = parts[4].trim();
                            LocalDateTime createdAt = LocalDateTime.parse(parts[5].trim(), formatter);
                            reviews.add(new Review(id, prodId, customerName, rating, comment, createdAt));
                        }
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return reviews;
    }

    public boolean addReview(Review review) {
        try {
            File file = new File(filePath);
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }

            List<Review> reviews = getAllReviews();
            int newId = reviews.isEmpty() ? 1 : reviews.get(reviews.size() - 1).getId() + 1;
            review.setId(newId);
            review.setCreatedAt(LocalDateTime.now());

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath, true))) {
                writer.write(String.format("%d,%d,%s,%d,%s,%s%n",
                    review.getId(),
                    review.getProductId(),
                    review.getCustomerName(),
                    review.getRating(),
                    review.getComment(),
                    review.getCreatedAt().format(formatter)));
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateReview(Review updatedReview) {
        try {
            List<Review> reviews = getAllReviews();
            boolean found = false;
            
            for (int i = 0; i < reviews.size(); i++) {
                if (reviews.get(i).getId() == updatedReview.getId()) {
                    reviews.set(i, updatedReview);
                    found = true;
                    break;
                }
            }
            
            if (!found) {
                return false;
            }
            
            // Write all reviews back to file
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
                for (Review review : reviews) {
                    writer.write(String.format("%d,%d,%s,%d,%s,%s%n",
                        review.getId(),
                        review.getProductId(),
                        review.getCustomerName(),
                        review.getRating(),
                        review.getComment(),
                        review.getCreatedAt().format(formatter)));
                }
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteReview(int reviewId) {
        try {
            List<Review> reviews = getAllReviews();
            boolean removed = reviews.removeIf(review -> review.getId() == reviewId);
            
            if (!removed) {
                return false;
            }
            
            // Write remaining reviews back to file
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
                for (Review review : reviews) {
                    writer.write(String.format("%d,%d,%s,%d,%s,%s%n",
                        review.getId(),
                        review.getProductId(),
                        review.getCustomerName(),
                        review.getRating(),
                        review.getComment(),
                        review.getCreatedAt().format(formatter)));
                }
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Review getReviewById(int reviewId) {
        List<Review> reviews = getAllReviews();
        return reviews.stream()
                .filter(review -> review.getId() == reviewId)
                .findFirst()
                .orElse(null);
    }

    private List<Review> getAllReviews() {
        List<Review> reviews = new ArrayList<>();
        File file = new File(filePath);
        try {
            if (!file.exists()) {
                return reviews;
            }
            try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    if (line.trim().isEmpty()) {
                        continue;
                    }
                    String[] parts = line.split(",");
                    if (parts.length >= 6) {
                        int id = Integer.parseInt(parts[0].trim());
                        int productId = Integer.parseInt(parts[1].trim());
                        String customerName = parts[2].trim();
                        int rating = Integer.parseInt(parts[3].trim());
                        String comment = parts[4].trim();
                        LocalDateTime createdAt = LocalDateTime.parse(parts[5].trim(), formatter);
                        reviews.add(new Review(id, productId, customerName, rating, comment, createdAt));
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return reviews;
    }
} 