package com.backery.backery_management.dao;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.backery.backery_management.model.Product;

public class ProductDAO {

    private final String filePath = "data/products.txt";

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
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
                    if (parts.length >= 4) {
                        int id = Integer.parseInt(parts[0].trim());
                        String name = parts[1].trim();
                        double price = Double.parseDouble(parts[2].trim());
                        String image = parts[3].trim();
                        products.add(new Product(id, name, price, image));
                    }
                }
            }
        } catch (IOException | NumberFormatException e) {
            System.err.println("Error reading products.txt: " + e.getMessage());
        }
        return products;
    }

    public void saveProduct(Product product) {
        File file = new File(filePath);
        try {
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath, true))) {
                writer.write(product.toString());
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error writing to products.txt: " + e.getMessage());
        }
    }

    public void updateProduct(Product updatedProduct) {
        List<Product> products = getAllProducts();
        File file = new File(filePath);
        try {
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
                for (Product p : products) {
                    if (p.getId() == updatedProduct.getId()) {
                        writer.write(updatedProduct.toString());
                    } else {
                        writer.write(p.toString());
                    }
                    writer.newLine();
                }
            }
        } catch (IOException e) {
            System.err.println("Error updating products.txt: " + e.getMessage());
        }
    }

    public void deleteProduct(int id) {
        List<Product> products = getAllProducts();
        File file = new File(filePath);
        try {
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
                for (Product p : products) {
                    if (p.getId() != id) {
                        writer.write(p.toString());
                        writer.newLine();
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error deleting from products.txt: " + e.getMessage());
        }
    }

    public Product getProductById(int id) {
        return getAllProducts().stream()
                .filter(p -> p.getId() == id)
                .findFirst()
                .orElse(null);
    }
}
