package com.backery.backery_management.dao;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.backery.backery_management.model.Order;

public class OrderDAO {

    private final String filePath = "data/orders.txt";

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
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
                    if (parts.length == 4) {
                        try {
                            int id = Integer.parseInt(parts[0].trim());
                            int userId = Integer.parseInt(parts[1].trim());
                            int productId = Integer.parseInt(parts[2].trim());
                            int quantity = Integer.parseInt(parts[3].trim());
                            orders.add(new Order(id, userId, productId, quantity));
                        } catch (NumberFormatException e) {
                            System.err.println("Invalid data format in orders.txt: " + line);
                        }
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading orders.txt: " + e.getMessage());
        }
        return orders;
    }

    public void saveOrder(Order order) {
        File file = new File(filePath);
        try {
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath, true))) {
                writer.write(order.toString());
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error writing to orders.txt: " + e.getMessage());
        }
    }
}
