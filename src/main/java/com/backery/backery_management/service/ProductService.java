package com.backery.backery_management.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Stack;

import org.springframework.stereotype.Service;

import com.backery.backery_management.dao.ProductDAO;
import com.backery.backery_management.model.Product;

@Service
public class ProductService {

    private final ProductDAO productDAO = new ProductDAO();

    public List<Product> getAllProducts() {
        try {
            System.out.println("ProductService: Getting all products");
            List<Product> products = productDAO.getAllProducts();
            System.out.println("ProductService: Retrieved " + (products != null ? products.size() : 0) + " products from DAO");

            if (products == null || products.isEmpty()) {
                System.out.println("ProductService: No products found, returning empty list");
                return new ArrayList<>();
            }

            // Step 1: Bubble Sort by Price (Ascending)
            System.out.println("ProductService: Sorting products by price");
            bubbleSortByPrice(products);

            // Step 2: Use Stack to process sorted products (LIFO - Last In First Out)
            Stack<Product> productStack = new Stack<>();
            for (Product p : products) {
                productStack.push(p);
            }

            // Step 3: Pop from Stack to reverse order for display (highest price first)
            List<Product> sortedProducts = new ArrayList<>();
            while (!productStack.isEmpty()) {
                sortedProducts.add(productStack.pop());
            }

            System.out.println("ProductService: Returning " + sortedProducts.size() + " sorted products");
            return sortedProducts;
        } catch (Exception e) {
            System.err.println("Error in getAllProducts: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public boolean addProduct(Product product) {
        try {
            System.out.println("ProductService: Adding new product: " + product.toString());

            if (product.getPrice() < 0 || product.getQuantityAvailable() < 0) {
                System.out.println("ProductService: Rejected product due to negative price or quantity");
                return false; // Reject negative price or quantity
            }

            List<Product> products = productDAO.getAllProducts();
            int newId = products.isEmpty() ? 1 : products.get(products.size() - 1).getId() + 1;
            product.setId(newId);
            System.out.println("ProductService: Setting new product ID to: " + newId);

            productDAO.saveProduct(product);
            System.out.println("ProductService: Successfully saved product");
            return true;
        } catch (Exception e) {
            System.err.println("Error in addProduct: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateProduct(Product product) {
        try {
            System.out.println("ProductService: Updating product: " + product.toString());

            if (product.getPrice() < 0 || product.getQuantityAvailable() < 0) {
                System.out.println("ProductService: Rejected update due to negative price or quantity");
                return false; // Reject negative price or quantity
            }

            productDAO.updateProduct(product);
            System.out.println("ProductService: Successfully updated product");
            return true;
        } catch (Exception e) {
            System.err.println("Error in updateProduct: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public void deleteProduct(int id) {
        try {
            System.out.println("ProductService: Deleting product with ID: " + id);
            productDAO.deleteProduct(id);
            System.out.println("ProductService: Successfully deleted product");
        } catch (Exception e) {
            System.err.println("Error in deleteProduct: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public Product getProductById(int id) {
        try {
            System.out.println("ProductService: Getting product by ID: " + id);
            Product product = productDAO.getProductById(id);
            System.out.println("ProductService: Found product: " + (product != null ? product.toString() : "null"));
            return product;
        } catch (Exception e) {
            System.err.println("Error in getProductById: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    private void bubbleSortByPrice(List<Product> products) {
        int n = products.size();
        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                if (products.get(j).getPrice() > products.get(j + 1).getPrice()) {
                    Product temp = products.get(j);
                    products.set(j, products.get(j + 1));
                    products.set(j + 1, temp);
                }
            }
        }
    }
}
