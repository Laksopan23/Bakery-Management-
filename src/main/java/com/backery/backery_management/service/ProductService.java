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
        List<Product> products = productDAO.getAllProducts();

        // Step 1: Bubble Sort by Price (Ascending)
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

        return sortedProducts;
    }

    public boolean addProduct(Product product) {
        if (product.getPrice() < 0) {
            return false; // Reject negative prices
        }
        List<Product> products = productDAO.getAllProducts();
        int newId = products.isEmpty() ? 1 : products.get(products.size() - 1).getId() + 1;
        product.setId(newId);
        productDAO.saveProduct(product);
        return true;
    }

    public boolean updateProduct(Product product) {
        if (product.getPrice() < 0) {
            return false; // Reject negative prices
        }
        productDAO.updateProduct(product);
        return true;
    }

    public void deleteProduct(int id) {
        productDAO.deleteProduct(id);
    }

    public Product getProductById(int id) {
        return productDAO.getProductById(id);
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
