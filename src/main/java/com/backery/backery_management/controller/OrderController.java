package com.backery.backery_management.controller;

import java.time.LocalDateTime;
import java.util.List;
import java.util.regex.Pattern;

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
import com.backery.backery_management.service.OrderFileService;
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

    @Autowired
    private OrderFileService orderFileService;

    private static final Pattern NAME_PATTERN = Pattern.compile("^[A-Za-z\\s]{2,50}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9]{10}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern CITY_PATTERN = Pattern.compile("^[A-Za-z\\s]{2,50}$");
    private static final Pattern POSTAL_CODE_PATTERN = Pattern.compile("^[0-9]{5}$");
    private static final Pattern CARD_NUMBER_PATTERN = Pattern.compile("^(4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9]{2})[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\\d{3})\\d{11})$");
    private static final Pattern EXPIRY_DATE_PATTERN = Pattern.compile("^(0[1-9]|1[0-2])/([0-9]{2})$");
    private static final Pattern CVV_PATTERN = Pattern.compile("^[0-9]{3}$");

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
            redirectAttributes.addFlashAttribute("formData", createFormDataMap(fullName, phone, email, address, city, postalCode, deliveryNotes));
            return "redirect:/orders/place/" + productId + "?quantity=" + quantity;
        }

        if (!NAME_PATTERN.matcher(fullName).matches()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid full name format.");
            redirectAttributes.addFlashAttribute("formData", createFormDataMap(fullName, phone, email, address, city, postalCode, deliveryNotes));
            return "redirect:/orders/place/" + productId + "?quantity=" + quantity;
        }
        if (!PHONE_PATTERN.matcher(phone).matches()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid phone number format. Please enter 10 digits.");
            redirectAttributes.addFlashAttribute("formData", createFormDataMap(fullName, phone, email, address, city, postalCode, deliveryNotes));
            return "redirect:/orders/place/" + productId + "?quantity=" + quantity;
        }
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid email format.");
            redirectAttributes.addFlashAttribute("formData", createFormDataMap(fullName, phone, email, address, city, postalCode, deliveryNotes));
            return "redirect:/orders/place/" + productId + "?quantity=" + quantity;
        }
        if (address.length() < 10 || address.length() > 200) {
            redirectAttributes.addFlashAttribute("errorMessage", "Address must be between 10 and 200 characters.");
            redirectAttributes.addFlashAttribute("formData", createFormDataMap(fullName, phone, email, address, city, postalCode, deliveryNotes));
            return "redirect:/orders/place/" + productId + "?quantity=" + quantity;
        }
        if (!CITY_PATTERN.matcher(city).matches()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid city name format.");
            redirectAttributes.addFlashAttribute("formData", createFormDataMap(fullName, phone, email, address, city, postalCode, deliveryNotes));
            return "redirect:/orders/place/" + productId + "?quantity=" + quantity;
        }
        if (!POSTAL_CODE_PATTERN.matcher(postalCode).matches()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid postal code format. Please enter 5 digits.");
            redirectAttributes.addFlashAttribute("formData", createFormDataMap(fullName, phone, email, address, city, postalCode, deliveryNotes));
            return "redirect:/orders/place/" + productId + "?quantity=" + quantity;
        }
        if (deliveryNotes != null && deliveryNotes.length() > 200) {
            redirectAttributes.addFlashAttribute("errorMessage", "Delivery notes cannot exceed 200 characters.");
            redirectAttributes.addFlashAttribute("formData", createFormDataMap(fullName, phone, email, address, city, postalCode, deliveryNotes));
            return "redirect:/orders/place/" + productId + "?quantity=" + quantity;
        }

        int newOrderId = orderService.getAllOrders().stream()
                .mapToInt(Order::getId)
                .max()
                .orElse(0) + 1;

        Order order = new Order(newOrderId, userId, productId, quantity);
        order.setPrice(product.getPrice());
        order.setProductName(product.getName());
        order.setDeliveryDetails(fullName, phone, email, address, city, postalCode, deliveryNotes);
        orderService.addOrder(order);

        redirectAttributes.addFlashAttribute("order", order);
        redirectAttributes.addFlashAttribute("product", product);
        return "redirect:/orders/payment";
    }

    @GetMapping("/payment")
    public String showPaymentPage(Model model, HttpSession session) {
        Order order = (Order) model.getAttribute("order");
        Product product = (Product) model.getAttribute("product");
        if (order == null || product == null) {
            return "redirect:/products/customer";
        }
        model.addAttribute("order", order);
        model.addAttribute("product", product);
        return "payment-options";
    }

    @PostMapping("/process-payment")
    public String processPayment(
            @RequestParam("orderId") int orderId,
            @RequestParam("paymentMethod") String paymentMethod,
            @RequestParam(value = "cardNumber", required = false) String cardNumber,
            @RequestParam(value = "expiryDate", required = false) String expiryDate,
            @RequestParam(value = "cvv", required = false) String cvv,
            @RequestParam(value = "mobileNumber", required = false) String mobileNumber,
            @RequestParam(value = "mobileBank", required = false) String mobileBank,
            RedirectAttributes redirectAttributes) {

        Order order = orderService.getOrderById(orderId);
        if (order == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Order not found.");
            return "redirect:/products/customer";
        }

        // Set status based on payment method
        if ("COD".equals(paymentMethod)) {
            order.setStatus("PENDING"); // Set to Pending for COD
        } else if ("CARD".equals(paymentMethod)) {
            if (cardNumber == null || !CARD_NUMBER_PATTERN.matcher(cardNumber).matches() || !validateLuhn(cardNumber)) {
                redirectAttributes.addFlashAttribute("errorMessage", "Invalid card number.");
                return "redirect:/orders/payment";
            }
            if (expiryDate == null || !EXPIRY_DATE_PATTERN.matcher(expiryDate).matches() || !isValidExpiryDate(expiryDate)) {
                redirectAttributes.addFlashAttribute("errorMessage", "Invalid expiry date. Use MM/YY format.");
                return "redirect:/orders/payment";
            }
            if (cvv == null || !CVV_PATTERN.matcher(cvv).matches()) {
                redirectAttributes.addFlashAttribute("errorMessage", "CVV must be 3 digits.");
                return "redirect:/orders/payment";
            }
            order.setStatus("PAID");
        } else if ("MOBILE".equals(paymentMethod)) {
            if (mobileNumber == null || !PHONE_PATTERN.matcher(mobileNumber).matches()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Invalid mobile number.");
                return "redirect:/orders/payment";
            }
            if (mobileBank == null || mobileBank.isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Select a mobile bank.");
                return "redirect:/orders/payment";
            }
            order.setStatus("PAID");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid payment method.");
            return "redirect:/orders/payment";
        }

        order.setPaymentMethod(paymentMethod);
        order.setOrderDate(LocalDateTime.now());
        orderService.updateOrder(order);

        // Update stock only for PAID orders (not for COD)
        if ("PAID".equals(order.getStatus())) {
            Product product = productService.getProductById(order.getProductId());
            if (product != null) {
                product.setCurrentStock(product.getCurrentStock() - order.getQuantity());
                productService.updateProduct(product);
            }
        }

        redirectAttributes.addFlashAttribute("order", order);
        redirectAttributes.addFlashAttribute("product", productService.getProductById(order.getProductId()));
        return "redirect:/orders/payment-success";
    }

    @GetMapping("/payment-success")
    public String showPaymentSuccess(Model model) {
        Order order = (Order) model.getAttribute("order");
        if (order == null) {
            return "redirect:/products/customer";
        }
        return "payment-success";
    }

    @GetMapping("/customer/history")
    public String showCustomerOrders(Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");
        if (username == null) {
            return "redirect:/";
        }
        int userId = userService.getUserByUsername(username).getId();
        List<Order> orders = orderService.getOrdersByUserId(userId);
        for (Order order : orders) {
            Product product = productService.getProductById(order.getProductId());
            if (product != null) {
                order.setProductName(product.getName());
            }
        }
        model.addAttribute("orders", orders);
        return "customer-orders";
    }

    @GetMapping("/admin/all")
    public String showAllOrders(Model model) {
        model.addAttribute("orders", orderFileService.getAllOrders());
        return "admin-orders";
    }

    @GetMapping("/my-orders")
    public String showMyOrders(Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");
        if (username == null) {
            return "redirect:/";
        }
        int userId = userService.getUserByUsername(username).getId();
        model.addAttribute("orders", orderFileService.getUserOrders(userId));
        return "my-orders";
    }

    private boolean validateLuhn(String cardNumber) {
        int sum = 0;
        boolean isEven = false;
        for (int i = cardNumber.length() - 1; i >= 0; i--) {
            int digit = Character.getNumericValue(cardNumber.charAt(i));
            if (isEven) {
                digit *= 2;
                if (digit > 9) {
                    digit -= 9;
                }
            }
            sum += digit;
            isEven = !isEven;
        }
        return (sum % 10) == 0;
    }

    private boolean isValidExpiryDate(String expiryDate) {
        try {
            String[] parts = expiryDate.split("/");
            int month = Integer.parseInt(parts[0]);
            int year = Integer.parseInt(parts[1]);
            if (month < 1 || month > 12) {
                return false;
            }
            java.time.YearMonth current = java.time.YearMonth.now();
            int currentYear = current.getYear() % 100;
            int currentMonth = current.getMonthValue();
            if (year < currentYear || (year == currentYear && month < currentMonth)) {
                return false;
            }
            if (year > currentYear + 10) {
                return false;
            }
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    private java.util.Map<String, String> createFormDataMap(String fullName, String phone, String email, String address, String city, String postalCode, String deliveryNotes) {
        java.util.Map<String, String> formData = new java.util.HashMap<>();
        formData.put("fullName", fullName);
        formData.put("phone", phone);
        formData.put("email", email);
        formData.put("address", address);
        formData.put("city", city);
        formData.put("postalCode", postalCode);
        formData.put("deliveryNotes", deliveryNotes);
        return formData;
    }
}
