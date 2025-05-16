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

import com.backery.backery_management.model.Reply;

public class ReplyDAO {
    private final String filePath = "data/replies.txt";
    private final DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;

    public List<Reply> getRepliesByReviewId(int reviewId) {
        List<Reply> replies = new ArrayList<>();
        File file = new File(filePath);
        try {
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
                return replies;
            }
            try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    if (line.trim().isEmpty()) {
                        continue;
                    }
                    String[] parts = line.split(",");
                    if (parts.length >= 5) {
                        int id = Integer.parseInt(parts[0].trim());
                        int revId = Integer.parseInt(parts[1].trim());
                        if (revId == reviewId) {
                            String adminName = parts[2].trim();
                            String comment = parts[3].trim();
                            LocalDateTime createdAt = LocalDateTime.parse(parts[4].trim(), formatter);
                            replies.add(new Reply(id, revId, adminName, comment, createdAt));
                        }
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return replies;
    }

    public boolean addReply(Reply reply) {
        try {
            File file = new File(filePath);
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }

            List<Reply> replies = getAllReplies();
            int newId = replies.isEmpty() ? 1 : replies.get(replies.size() - 1).getId() + 1;
            reply.setId(newId);
            reply.setCreatedAt(LocalDateTime.now());

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath, true))) {
                writer.write(String.format("%d,%d,%s,%s,%s%n",
                    reply.getId(),
                    reply.getReviewId(),
                    reply.getAdminName(),
                    reply.getComment(),
                    reply.getCreatedAt().format(formatter)));
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    private List<Reply> getAllReplies() {
        List<Reply> replies = new ArrayList<>();
        File file = new File(filePath);
        try {
            if (!file.exists()) {
                return replies;
            }
            try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    if (line.trim().isEmpty()) {
                        continue;
                    }
                    String[] parts = line.split(",");
                    if (parts.length >= 5) {
                        int id = Integer.parseInt(parts[0].trim());
                        int reviewId = Integer.parseInt(parts[1].trim());
                        String adminName = parts[2].trim();
                        String comment = parts[3].trim();
                        LocalDateTime createdAt = LocalDateTime.parse(parts[4].trim(), formatter);
                        replies.add(new Reply(id, reviewId, adminName, comment, createdAt));
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return replies;
    }

    public boolean deleteRepliesByReviewId(int reviewId) {
        try {
            List<Reply> allReplies = getAllReplies();
            List<Reply> remainingReplies = allReplies.stream()
                    .filter(reply -> reply.getReviewId() != reviewId)
                    .toList();

            // Write remaining replies back to file
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
                for (Reply reply : remainingReplies) {
                    writer.write(String.format("%d,%d,%s,%s,%s%n",
                        reply.getId(),
                        reply.getReviewId(),
                        reply.getAdminName(),
                        reply.getComment(),
                        reply.getCreatedAt().format(formatter)));
                }
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
} 