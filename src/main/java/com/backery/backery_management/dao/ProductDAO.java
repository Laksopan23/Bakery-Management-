package com.backery.backery_management.dao;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import com.backery.backery_management.model.Product;

public class ProductDAO {

    private final String filePath;

    public ProductDAO() {
        // Get the absolute path to the data directory
        String baseDir = System.getProperty("user.dir");
        this.filePath = baseDir + File.separator + "data" + File.separator + "products.txt";
        System.out.println("ProductDAO initialized with file path: " + this.filePath);
    }

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        File file = new File(filePath);
        System.out.println("ProductDAO: Reading products from: " + file.getAbsolutePath());
        System.out.println("ProductDAO: File exists: " + file.exists());
        System.out.println("ProductDAO: File size: " + (file.exists() ? file.length() : "N/A") + " bytes");

        try {
            if (!file.exists()) {
                System.out.println("ProductDAO: Products file does not exist, creating it...");
                file.getParentFile().mkdirs();
                file.createNewFile();
            }

            try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
                String line;
                int lineNumber = 0;
                while ((line = reader.readLine()) != null) {
                    lineNumber++;
                    if (line.trim().isEmpty()) {
                        System.out.println("ProductDAO: Skipping empty line " + lineNumber);
                        continue;
                    }
                    System.out.println("ProductDAO: Reading product line " + lineNumber + ": " + line);
                    String[] parts = line.split(",");
                    System.out.println("ProductDAO: Found " + parts.length + " parts in line " + lineNumber);

                    if (parts.length >= 9) {
                        try {
                            int id = Integer.parseInt(parts[0].trim());
                            String name = parts[1].trim();
                            String description = parts[2].trim();
                            String category = parts[3].trim();
                            double price = Double.parseDouble(parts[4].trim());
                            int quantityAvailable = Integer.parseInt(parts[5].trim());
                            int initialStock = Integer.parseInt(parts[6].trim());
                            int currentStock = Integer.parseInt(parts[7].trim());
                            String image = parts[8].trim();

                            Product product = new Product(id, name, description, category, price, quantityAvailable, initialStock, currentStock, image);
                            products.add(product);
                            System.out.println("ProductDAO: Successfully added product: " + product.toString());
                        } catch (NumberFormatException e) {
                            System.err.println("ProductDAO: Error parsing product data at line " + lineNumber + ": " + line);
                            System.err.println("ProductDAO: Error details: " + e.getMessage());
                            e.printStackTrace();
                        }
                    } else {
                        System.err.println("ProductDAO: Invalid product data at line " + lineNumber + ": " + line);
                        System.err.println("ProductDAO: Expected 9 parts, found " + parts.length);
                    }
                }
            }
            System.out.println("ProductDAO: Total products read: " + products.size());
            System.out.println("ProductDAO: Product IDs: " + products.stream().map(p -> p.getId()).collect(Collectors.toList()));
        } catch (IOException e) {
            System.err.println("ProductDAO: Error reading products.txt: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    public void saveProduct(Product product) {
        File file = new File(filePath);
        System.out.println("Saving product to: " + file.getAbsolutePath());
        System.out.println("Product to save: " + product.toString());

        try {
            if (!file.exists()) {
                System.out.println("Products file does not exist, creating it...");
                file.getParentFile().mkdirs();
                file.createNewFile();
            }

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
                String productLine = product.toString();
                writer.write(productLine);
                writer.newLine();
                System.out.println("Successfully wrote product to file: " + productLine);
            }
        } catch (IOException e) {
            System.err.println("Error writing to products.txt: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void updateProduct(Product updatedProduct) {
        System.out.println("Updating product: " + updatedProduct.toString());
        List<Product> products = getAllProducts();
        File file = new File(filePath);

        try {
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                for (Product p : products) {
                    if (p.getId() == updatedProduct.getId()) {
                        writer.write(updatedProduct.toString());
                        System.out.println("Updated product: " + updatedProduct.toString());
                    } else {
                        writer.write(p.toString());
                    }
                    writer.newLine();
                }
            }
        } catch (IOException e) {
            System.err.println("Error updating products.txt: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void deleteProduct(int id) {
        System.out.println("Deleting product with ID: " + id);
        List<Product> products = getAllProducts();
        File file = new File(filePath);

        try {
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                for (Product p : products) {
                    if (p.getId() != id) {
                        writer.write(p.toString());
                        writer.newLine();
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error deleting from products.txt: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public Product getProductById(int id) {
        System.out.println("Getting product by ID: " + id);
        return getAllProducts().stream()
                .filter(p -> p.getId() == id)
                .findFirst()
                .orElse(null);
    }
}
