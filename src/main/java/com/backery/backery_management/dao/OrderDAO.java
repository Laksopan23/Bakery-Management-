package com.backery.backery_management.dao;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.backery.backery_management.model.Order;

public class OrderDAO {

    private final String filePath = "data/orders/all_orders.txt";

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        File file = new File(filePath);
        try {
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
                StringBuilder currentOrder = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    if (line.startsWith("=".repeat(80))) {
                        if (currentOrder.length() > 0) {
                            orders.add(Order.fromString(currentOrder.toString()));
                            currentOrder = new StringBuilder();
                        }
                    } else {
                        currentOrder.append(line).append("\n");
                    }
                }
                if (currentOrder.length() > 0) {
                    orders.add(Order.fromString(currentOrder.toString()));
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading all_orders.txt: " + e.getMessage());
        }
        return orders;
    }

    public void saveOrder(Order order) {
        // Handled by OrderFileService
    }
}
