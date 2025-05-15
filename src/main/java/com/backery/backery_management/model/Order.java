package com.backery.backery_management.model;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;

public class Order {

    private int id;
    private int userId;
    private int productId;
    private int quantity;
    private double price;
    private String status;
    private String productName;
    private LocalDateTime orderDate;
    private String paymentMethod;

    // Delivery details
    private String fullName;
    private String phone;
    private String email;
    private String address;
    private String city;
    private String postalCode;
    private String deliveryNotes;

    public Order(int id, int userId, int productId, int quantity) {
        this.id = id;
        this.userId = userId;
        this.productId = productId;
        this.quantity = quantity;
        this.status = "PENDING";
        this.orderDate = LocalDateTime.now();
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public LocalDateTime getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(LocalDateTime orderDate) {
        this.orderDate = orderDate;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getPostalCode() {
        return postalCode;
    }

    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }

    public String getDeliveryNotes() {
        return deliveryNotes;
    }

    public void setDeliveryNotes(String deliveryNotes) {
        this.deliveryNotes = deliveryNotes;
    }

    public void setDeliveryDetails(String fullName, String phone, String email, String address, String city,
            String postalCode, String deliveryNotes) {
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.city = city;
        this.postalCode = postalCode;
        this.deliveryNotes = deliveryNotes;
    }

    // Convert LocalDateTime to Date for JSP compatibility
    public Date getOrderDateAsDate() {
        if (orderDate == null) {
            return null;
        }
        return Date.from(orderDate.atZone(ZoneId.systemDefault()).toInstant());
    }

    @Override
    public String toString() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        return id + "," + userId + "," + productId + "," + quantity + "," + price + "," + status + "," + productName + ","
                + (orderDate != null ? orderDate.format(formatter) : "") + ","
                + paymentMethod + "," + fullName + "," + phone + "," + email + "," + address + "," + city + "," + postalCode + ","
                + (deliveryNotes != null ? deliveryNotes : "");
    }

    public static Order fromString(String orderText) {
        Order order = new Order(0, 0, 0, 0);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        DateTimeFormatter shortFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"); // For cases without seconds
        String[] lines = orderText.split("\n");
        for (String line : lines) {
            if (line.startsWith("Order ID:")) {
                order.setId(Integer.parseInt(line.split(":")[1].trim())); 
            }else if (line.startsWith("User ID:")) {
                order.setUserId(Integer.parseInt(line.split(":")[1].trim())); 
            }else if (line.startsWith("Product:")) {
                order.setProductName(line.split(":")[1].trim()); 
            }else if (line.startsWith("Quantity:")) {
                order.setQuantity(Integer.parseInt(line.split(":")[1].trim())); 
            }else if (line.startsWith("Total Amount:")) {
                String amount = line.split(":")[1].trim().replace("Rs. ", "").replace(",", "");
                order.setPrice(Double.parseDouble(amount) / (order.getQuantity() > 0 ? order.getQuantity() : 1));
            } else if (line.startsWith("Status:")) {
                order.setStatus(line.split(":")[1].trim()); 
            }else if (line.startsWith("Payment Method:")) {
                order.setPaymentMethod(line.split(":")[1].trim()); 
            }else if (line.startsWith("Date:")) {
                String dateStr = line.split(":")[1].trim();
                if (!dateStr.isEmpty()) {
                    try {
                        order.setOrderDate(LocalDateTime.parse(dateStr, formatter)); // Try full format first
                    } catch (Exception e) {
                        order.setOrderDate(LocalDateTime.parse(dateStr + ":00", shortFormatter)); // Append :00 if short format
                    }
                }
            } else if (line.startsWith("Name:")) {
                order.setFullName(line.split(":")[1].trim()); 
            }else if (line.startsWith("Phone:")) {
                order.setPhone(line.split(":")[1].trim()); 
            }else if (line.startsWith("Email:")) {
                order.setEmail(line.split(":")[1].trim()); 
            }else if (line.startsWith("Address:")) {
                order.setAddress(line.split(":")[1].trim()); 
            }else if (line.startsWith("City:")) {
                order.setCity(line.split(":")[1].trim()); 
            }else if (line.startsWith("Postal Code:")) {
                order.setPostalCode(line.split(":")[1].trim()); 
            }else if (line.startsWith("Delivery Notes:")) {
                order.setDeliveryNotes(line.split(":")[1].trim());
            }
        }
        return order;
    }
}
