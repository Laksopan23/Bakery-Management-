package com.backery.backery_management.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.backery.backery_management.dao.OrderDAO;
import com.backery.backery_management.model.Order;

@Service
public class OrderService {

    private final OrderDAO orderDAO = new OrderDAO();

    public List<Order> getAllOrders() {
        return orderDAO.getAllOrders();
    }

    public void addOrder(Order order) {
        orderDAO.saveOrder(order);
    }
}
