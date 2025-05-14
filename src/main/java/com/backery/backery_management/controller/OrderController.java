package com.backery.backery_management.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.backery.backery_management.model.Order;
import com.backery.backery_management.model.Product;
import com.backery.backery_management.service.OrderService;
import com.backery.backery_management.service.ProductService;
import com.backery.backery_management.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/orders")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private ProductService productService;

    @Autowired
    private UserService userService;

    @GetMapping
    public String showOrders(Model model) {
        model.addAttribute("orders", orderService.getAllOrders());
        return "orders";
    }

    @GetMapping("/place/{productId}")
    public String placeOrder(@PathVariable("productId") int productId,
            @RequestParam("quantity") int quantity,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        String username = (String) session.getAttribute("username");
        if (username == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Please login to place an order.");
            return "redirect:/";
        }

        Product product = productService.getProductById(productId);
        if (product == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Product not found.");
            return "redirect:/products/customer";
        }

        if (quantity <= 0 || quantity > product.getCurrentStock()) {
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Invalid quantity. Please select between 1 and " + product.getCurrentStock() + " units.");
            return "redirect:/products/view/" + productId;
        }

        model.addAttribute("product", product);
        model.addAttribute("quantity", quantity);
        model.addAttribute("userId", userService.getUserByUsername(username).getId());
        return "order-confirmation";
    }

    @PostMapping("/confirm")
    public String confirmOrder(
            @RequestParam("userId") int userId,
            @RequestParam("productId") int productId,
            @RequestParam("quantity") int quantity,
            @RequestParam("fullName") String fullName,
            @RequestParam("phone") String phone,
            @RequestParam("email") String email,
            @RequestParam("address") String address,
            @RequestParam("city") String city,
            @RequestParam("postalCode") String postalCode,
            @RequestParam(value = "deliveryNotes", required = false) String deliveryNotes,
            RedirectAttributes redirectAttributes) {

        Product product = productService.getProductById(productId);
        if (product == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Product not found.");
            return "redirect:/products/customer";
        }
        if (quantity <= 0 || quantity > product.getCurrentStock()) {
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Invalid quantity. Please select between 1 and " + product.getCurrentStock() + " units.");
            return "redirect:/products/view/" + productId;
        }

        // Generate new order ID (simple increment)
        int newOrderId = orderService.getAllOrders().stream()
                .mapToInt(Order::getId)
                .max()
                .orElse(0) + 1;

        // Create order with delivery details
        Order order = new Order(newOrderId, userId, productId, quantity);
        order.setDeliveryDetails(fullName, phone, email, address, city, postalCode, deliveryNotes);
        orderService.addOrder(order);

        // Update product stock
        int newStock = product.getCurrentStock() - quantity;
        product.setCurrentStock(newStock);
        productService.updateProduct(product);

        redirectAttributes.addFlashAttribute("successMessage",
                "Order placed successfully! Order ID: " + newOrderId
                + ". We will contact you shortly at " + phone + " for delivery confirmation.");
        return "redirect:/products/customer";
    }

    @GetMapping("/customer/history")
    public String showCustomerOrders(Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");
        if (username == null) {
            return "redirect:/";
        }
        int userId = userService.getUserByUsername(username).getId();
        model.addAttribute("orders", orderService.getAllOrders().stream()
                .filter(o -> o.getUserId() == userId)
                .toList());
        return "customer-orders";
    }
}
