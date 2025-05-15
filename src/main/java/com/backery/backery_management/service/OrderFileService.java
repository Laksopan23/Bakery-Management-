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
import java.time.LocalDateTime;
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
        }
    }

    public void saveOrder(Order order) {
        lock.writeLock().lock();
        try {
            String allOrdersFileName = String.format("%s/all_orders.txt", ORDERS_DIRECTORY);
            File allOrdersFile = new File(allOrdersFileName);
            boolean orderExists = false;

            if (allOrdersFile.exists()) {
                try (BufferedReader reader = new BufferedReader(new FileReader(allOrdersFile))) {
                    StringBuilder currentOrder = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) {
                        if (line.startsWith("=".repeat(80))) {
                            if (currentOrder.length() > 0) {
                                Order existingOrder = Order.fromString(currentOrder.toString());
                                if (existingOrder.getId() == order.getId()) {
                                    orderExists = true;
                                    break;
                                }
                                currentOrder = new StringBuilder();
                            }
                        }
                        currentOrder.append(line).append("\n");
                    }
                    if (currentOrder.length() > 0) {
                        Order existingOrder = Order.fromString(currentOrder.toString());
                        if (existingOrder.getId() == order.getId()) {
                            orderExists = true;
                        }
                    }
                }
            }

            if (!orderExists) {
                // Ensure orderDate is set if null
                if (order.getOrderDate() == null) {
                    order.setOrderDate(LocalDateTime.now());
                }
                saveToFile(allOrdersFile, order, false);
                String userFileName = String.format("%s/user_%d_orders.txt", ORDERS_DIRECTORY, order.getUserId());
                saveToFile(new File(userFileName), order, true);
            }
        } catch (IOException e) {
            System.err.println("Error saving order: " + e.getMessage());
        } finally {
            lock.writeLock().unlock();
        }
    }

    private void saveToFile(File file, Order order, boolean isUserFile) throws IOException {
        try (PrintWriter writer = new PrintWriter(new FileWriter(file, true))) {
            if (file.length() > 0) {
                writer.println("\n" + "=".repeat(80));
            }
            writer.println("Order ID: " + order.getId());
            writer.println("Date: " + (order.getOrderDate() != null ? order.getOrderDate().format(DATE_FORMATTER) : LocalDateTime.now().format(DATE_FORMATTER)));
            writer.println("Status: " + (order.getStatus() != null ? order.getStatus() : ""));
            writer.println("Product: " + (order.getProductName() != null ? order.getProductName() : ""));
            writer.println("Quantity: " + order.getQuantity());
            writer.println("Total Amount: Rs. " + (order.getPrice() * order.getQuantity()));
            writer.println("Payment Method: " + (order.getPaymentMethod() != null ? order.getPaymentMethod() : "null"));
            writer.println("\nDelivery Details:");
            writer.println("Name: " + (order.getFullName() != null ? order.getFullName() : ""));
            writer.println("Phone: " + (order.getPhone() != null ? order.getPhone() : ""));
            writer.println("Email: " + (order.getEmail() != null ? order.getEmail() : ""));
            writer.println("Address: " + (order.getAddress() != null ? order.getAddress() : ""));
            writer.println("City: " + (order.getCity() != null ? order.getCity() : ""));
            writer.println("Postal Code: " + (order.getPostalCode() != null ? order.getPostalCode() : ""));
            if (order.getDeliveryNotes() != null && !order.getDeliveryNotes().isEmpty()) {
                writer.println("Delivery Notes: " + order.getDeliveryNotes());
            }
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
                    if (line.startsWith("=.repeat(80)")) {
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
            return new ArrayList<>();
        } finally {
            lock.readLock().unlock();
        }
    }
}
