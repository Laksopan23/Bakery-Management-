package com.backery.backery_management.controller;

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

    // Validation patterns
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

        // Validate product and quantity
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

        // Validate delivery details
        if (!NAME_PATTERN.matcher(fullName).matches()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid full name format.");
            return "redirect:/orders/place/" + productId + "?quantity=" + quantity;
        }

        if (!PHONE_PATTERN.matcher(phone).matches()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid phone number format. Please enter 10 digits.");
            return "redirect:/orders/place/" + productId + "?quantity=" + quantity;
        }

        if (!EMAIL_PATTERN.matcher(email).matches()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid email format.");
            return "redirect:/orders/place/" + productId + "?quantity=" + quantity;
        }

        if (address.length() < 10 || address.length() > 200) {
            redirectAttributes.addFlashAttribute("errorMessage", "Address must be between 10 and 200 characters.");
            return "redirect:/orders/place/" + productId + "?quantity=" + quantity;
        }

        if (!CITY_PATTERN.matcher(city).matches()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid city name format.");
            return "redirect:/orders/place/" + productId + "?quantity=" + quantity;
        }

        if (!POSTAL_CODE_PATTERN.matcher(postalCode).matches()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid postal code format. Please enter 5 digits.");
            return "redirect:/orders/place/" + productId + "?quantity=" + quantity;
        }

        if (deliveryNotes != null && deliveryNotes.length() > 200) {
            redirectAttributes.addFlashAttribute("errorMessage", "Delivery notes cannot exceed 200 characters.");
            return "redirect:/orders/place/" + productId + "?quantity=" + quantity;
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

        // Redirect to payment page
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

        // Validate payment details based on payment method
        if ("CARD".equals(paymentMethod)) {
            if (cardNumber == null || !CARD_NUMBER_PATTERN.matcher(cardNumber).matches()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Invalid card number format.");
                return "redirect:/orders/payment";
            }

            if (!validateLuhn(cardNumber)) {
                redirectAttributes.addFlashAttribute("errorMessage", "Invalid card number.");
                return "redirect:/orders/payment";
            }

            if (expiryDate == null || !EXPIRY_DATE_PATTERN.matcher(expiryDate).matches()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Invalid expiry date format. Please use MM/YY format.");
                return "redirect:/orders/payment";
            }

            if (!isValidExpiryDate(expiryDate)) {
                redirectAttributes.addFlashAttribute("errorMessage", "Card has expired or invalid expiry date.");
                return "redirect:/orders/payment";
            }

            if (cvv == null || !CVV_PATTERN.matcher(cvv).matches()) {
                redirectAttributes.addFlashAttribute("errorMessage", "CVV must be exactly 3 digits.");
                return "redirect:/orders/payment";
            }
        } else if ("MOBILE".equals(paymentMethod)) {
            if (mobileNumber == null || !PHONE_PATTERN.matcher(mobileNumber).matches()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Invalid mobile number.");
                return "redirect:/orders/payment";
            }
            if (mobileBank == null || mobileBank.isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Please select a mobile bank.");
                return "redirect:/orders/payment";
            }
        }

        // Update order with payment details
        order.setPaymentMethod(paymentMethod);
        order.setStatus("PAID");
        orderService.updateOrder(order);

        // Update product stock
        Product product = productService.getProductById(order.getProductId());
        int newStock = product.getCurrentStock() - order.getQuantity();
        product.setCurrentStock(newStock);
        productService.updateProduct(product);

        redirectAttributes.addFlashAttribute("successMessage",
                "Payment successful! Order ID: " + orderId
                + ". We will contact you shortly at " + order.getPhone() + " for delivery confirmation.");
        return "redirect:/products/customer";
    }

    // Luhn algorithm for card validation
    private boolean validateLuhn(String cardNumber) {
        int sum = 0;
        boolean isEven = false;

        // Loop through values starting from the rightmost digit
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

    // Validate card expiry date
    private boolean isValidExpiryDate(String expiryDate) {
        try {
            String[] parts = expiryDate.split("/");
            int month = Integer.parseInt(parts[0]);
            int year = Integer.parseInt(parts[1]);

            // Validate month
            if (month < 1 || month > 12) {
                return false;
            }

            // Get current date
            java.time.YearMonth current = java.time.YearMonth.now();
            int currentYear = current.getYear() % 100; // Get last 2 digits
            int currentMonth = current.getMonthValue();

            // Check if card is expired
            if (year < currentYear || (year == currentYear && month < currentMonth)) {
                return false;
            }

            // Check if year is too far in the future (e.g., more than 10 years)
            if (year > currentYear + 10) {
                return false;
            }

            return true;
        } catch (Exception e) {
            return false;
        }
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
