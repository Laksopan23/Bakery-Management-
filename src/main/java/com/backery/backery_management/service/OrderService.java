package com.backery.backery_management.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.backery.backery_management.model.Order;

@Service
public class OrderService {

    private List<Order> orders = new ArrayList<>();

    @Autowired
    private OrderFileService orderFileService;

    public OrderService() {
        loadOrdersFromFiles();
    }

    private void loadOrdersFromFiles() {
        try {
            File ordersDir = new File("data/orders");
            if (!ordersDir.exists()) {
                ordersDir.mkdirs();
                return;
            }

            // Load from all_orders.txt
            File allOrdersFile = new File(ordersDir, "all_orders.txt");
            if (allOrdersFile.exists()) {
                try (BufferedReader reader = new BufferedReader(new FileReader(allOrdersFile))) {
                    String line;
                    int currentId = 0;
                    int currentUserId = 0;
                    int currentProductId = 0;
                    int currentQuantity = 0;
                    Order currentOrder = null;

                    while ((line = reader.readLine()) != null) {
                        if (line.startsWith("Order ID:")) {
                            if (currentOrder != null) {
                                orders.add(currentOrder);
                            }
                            currentId = Integer.parseInt(line.substring(9).trim());
                        } else if (line.startsWith("User ID:")) {
                            currentUserId = Integer.parseInt(line.substring(8).trim());
                            currentOrder = new Order(currentId, currentUserId, currentProductId, currentQuantity);
                        } else if (currentOrder != null) {
                            if (line.startsWith("Product:")) {
                                currentOrder.setProductName(line.substring(8).trim());
                            } else if (line.startsWith("Quantity:")) {
                                currentQuantity = Integer.parseInt(line.substring(9).trim());
                                currentOrder.setQuantity(currentQuantity);
                            } else if (line.startsWith("Status:")) {
                                currentOrder.setStatus(line.substring(7).trim());
                            } else if (line.startsWith("Payment Method:")) {
                                currentOrder.setPaymentMethod(line.substring(15).trim());
                            }
                        }
                    }
                    if (currentOrder != null) {
                        orders.add(currentOrder);
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error loading orders from files: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public List<Order> getAllOrders() {
        return new ArrayList<>(orders);
    }

    public Order getOrderById(int id) {
        return orders.stream()
                .filter(order -> order.getId() == id)
                .findFirst()
                .orElse(null);
    }

    public void addOrder(Order order) {
        orders.add(order);
        orderFileService.saveOrder(order);
    }

    public void updateOrder(Order updatedOrder) {
        for (int i = 0; i < orders.size(); i++) {
            if (orders.get(i).getId() == updatedOrder.getId()) {
                orders.set(i, updatedOrder);
                orderFileService.saveOrder(updatedOrder);
                break;
            }
        }
    }

    public List<Order> getOrdersByUserId(int userId) {
        return orders.stream()
                .filter(order -> order.getUserId() == userId)
                .collect(Collectors.toList());
    }
}
