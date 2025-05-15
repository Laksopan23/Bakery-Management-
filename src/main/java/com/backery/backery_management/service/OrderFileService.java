package com.backery.backery_management.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import org.springframework.stereotype.Service;

import com.backery.backery_management.model.Order;

@Service
public class OrderFileService {

    private static final String ORDERS_DIRECTORY = "data/orders";
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();

    public OrderFileService() {
        createOrdersDirectory();
    }

    private void createOrdersDirectory() {
        try {
            Path ordersPath = Paths.get(ORDERS_DIRECTORY);
            if (!Files.exists(ordersPath)) {
                Files.createDirectories(ordersPath);
            }
        } catch (IOException e) {
            System.err.println("Error creating orders directory: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void saveOrder(Order order) {
        lock.writeLock().lock();
        try {
            // Create user-specific file
            String userFileName = String.format("%s/user_%d_orders.txt", ORDERS_DIRECTORY, order.getUserId());
            File userFile = new File(userFileName);

            // Create all orders file
            String allOrdersFileName = String.format("%s/all_orders.txt", ORDERS_DIRECTORY);
            File allOrdersFile = new File(allOrdersFileName);

            // Save to user-specific file
            saveToFile(userFile, order, true);

            // Save to all orders file
            saveToFile(allOrdersFile, order, false);
        } catch (IOException e) {
            System.err.println("Error saving order: " + e.getMessage());
            e.printStackTrace();
        } finally {
            lock.writeLock().unlock();
        }
    }

    private void saveToFile(File file, Order order, boolean isUserFile) throws IOException {
        try (PrintWriter writer = new PrintWriter(new FileWriter(file, true))) {
            // Add separator if file is not empty
            if (file.length() > 0) {
                writer.println("\n" + "=".repeat(80));
            }

            // Write order details
            writer.println("Order ID: " + order.getId());
            writer.println("Date: " + order.getOrderDate().format(DATE_FORMATTER));
            writer.println("Status: " + order.getStatus());
            writer.println("Product: " + order.getProductName());
            writer.println("Quantity: " + order.getQuantity());
            writer.println("Total Amount: Rs. " + (order.getQuantity() * order.getPrice()));
            writer.println("Payment Method: " + order.getPaymentMethod());

            // Write delivery details
            writer.println("\nDelivery Details:");
            writer.println("Name: " + order.getFullName());
            writer.println("Phone: " + order.getPhone());
            writer.println("Email: " + order.getEmail());
            writer.println("Address: " + order.getAddress());
            writer.println("City: " + order.getCity());
            writer.println("Postal Code: " + order.getPostalCode());
            if (order.getDeliveryNotes() != null && !order.getDeliveryNotes().isEmpty()) {
                writer.println("Delivery Notes: " + order.getDeliveryNotes());
            }

            // Add user ID only in all orders file
            if (!isUserFile) {
                writer.println("\nUser ID: " + order.getUserId());
            }
        }
    }

    public List<String> getUserOrders(int userId) {
        lock.readLock().lock();
        try {
            String userFileName = String.format("%s/user_%d_orders.txt", ORDERS_DIRECTORY, userId);
            File userFile = new File(userFileName);
            if (!userFile.exists()) {
                return new ArrayList<>();
            }

            List<String> orders = new ArrayList<>();
            try (BufferedReader reader = new BufferedReader(new FileReader(userFile))) {
                StringBuilder currentOrder = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    if (line.startsWith("=".repeat(80))) {
                        if (currentOrder.length() > 0) {
                            orders.add(currentOrder.toString());
                            currentOrder = new StringBuilder();
                        }
                    } else {
                        currentOrder.append(line).append("\n");
                    }
                }
                if (currentOrder.length() > 0) {
                    orders.add(currentOrder.toString());
                }
            }
            return orders;
        } catch (IOException e) {
            System.err.println("Error reading user orders: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            lock.readLock().unlock();
        }
    }

    public List<String> getAllOrders() {
        lock.readLock().lock();
        try {
            String allOrdersFileName = String.format("%s/all_orders.txt", ORDERS_DIRECTORY);
            File allOrdersFile = new File(allOrdersFileName);
            if (!allOrdersFile.exists()) {
                return new ArrayList<>();
            }

            List<String> orders = new ArrayList<>();
            try (BufferedReader reader = new BufferedReader(new FileReader(allOrdersFile))) {
                StringBuilder currentOrder = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    if (line.startsWith("=".repeat(80))) {
                        if (currentOrder.length() > 0) {
                            orders.add(currentOrder.toString());
                            currentOrder = new StringBuilder();
                        }
                    } else {
                        currentOrder.append(line).append("\n");
                    }
                }
                if (currentOrder.length() > 0) {
                    orders.add(currentOrder.toString());
                }
            }
            return orders;
        } catch (IOException e) {
            System.err.println("Error reading all orders: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            lock.readLock().unlock();
        }
    }
}
