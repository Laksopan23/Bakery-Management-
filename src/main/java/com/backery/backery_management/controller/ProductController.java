package com.backery.backery_management.controller;

import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.stream.Collectors;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.ImageOutputStream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.backery.backery_management.dao.ReviewDAO;
import com.backery.backery_management.model.Product;
import com.backery.backery_management.model.Review;
import com.backery.backery_management.model.User;
import com.backery.backery_management.service.OrderService;
import com.backery.backery_management.service.ProductService;
import com.backery.backery_management.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/products")
public class ProductController {

    @Autowired
    private ProductService productService;
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Autowired
    private OrderService orderService;

    @Autowired
    private UserService userService; // Add this

    private static final String UPLOAD_DIR = "src/main/webapp/resources/images/products/";
    private static final long MAX_FILE_SIZE = 20 * 1024 * 1024; // 20MB limit
    private static final String[] ALLOWED_IMAGE_TYPES = {
        "image/jpeg",
        "image/jpg",
        "image/pjpeg", // Progressive JPEG
        "image/x-jpeg", // Alternative JPEG MIME type
        "image/png",
        "image/gif"
    };
    private static final int MAX_IMAGE_DIMENSION = 2000; // Maximum dimension for width or height
    private static final float IMAGE_QUALITY = 0.9f; // 90% quality for JPEG

    private boolean isValidImageType(String contentType) {
        if (contentType == null) {
            return false;
        }
        String normalizedType = contentType.toLowerCase();
        for (String type : ALLOWED_IMAGE_TYPES) {
            if (type.equals(normalizedType)) {
                return true;
            }
        }
        return false;
    }

    private boolean isValidImageExtension(String filename) {
        if (filename == null) {
            return false;
        }
        String lowerFilename = filename.toLowerCase();
        return lowerFilename.endsWith(".jpg")
                || lowerFilename.endsWith(".jpeg")
                || lowerFilename.endsWith(".jpe")
                || // Alternative JPG extension
                lowerFilename.endsWith(".png")
                || lowerFilename.endsWith(".gif");
    }

    private String getImageFormat(String contentType, String filename) {
        if (contentType != null) {
            String type = contentType.toLowerCase();
            if (type.contains("jpeg") || type.contains("jpg")) {
                return "JPEG";
            } else if (type.contains("png")) {
                return "PNG";
            } else if (type.contains("gif")) {
                return "GIF";
            }
        }

        // Fallback to filename extension
        if (filename != null) {
            String lowerFilename = filename.toLowerCase();
            if (lowerFilename.endsWith(".jpg") || lowerFilename.endsWith(".jpeg") || lowerFilename.endsWith(".jpe")) {
                return "JPEG";
            } else if (lowerFilename.endsWith(".png")) {
                return "PNG";
            } else if (lowerFilename.endsWith(".gif")) {
                return "GIF";
            }
        }

        return "JPEG"; // Default to JPEG
    }

    private void optimizeImage(MultipartFile file, Path targetPath) throws IOException {
        BufferedImage originalImage = ImageIO.read(file.getInputStream());
        if (originalImage == null) {
            throw new IOException("Invalid image format");
        }

        // Calculate new dimensions while maintaining aspect ratio
        int originalWidth = originalImage.getWidth();
        int originalHeight = originalImage.getHeight();
        int newWidth = originalWidth;
        int newHeight = originalHeight;

        if (originalWidth > MAX_IMAGE_DIMENSION || originalHeight > MAX_IMAGE_DIMENSION) {
            if (originalWidth > originalHeight) {
                newWidth = MAX_IMAGE_DIMENSION;
                newHeight = (int) ((double) originalHeight / originalWidth * MAX_IMAGE_DIMENSION);
            } else {
                newHeight = MAX_IMAGE_DIMENSION;
                newWidth = (int) ((double) originalWidth / originalHeight * MAX_IMAGE_DIMENSION);
            }
        }

        // Create new image with calculated dimensions
        BufferedImage resizedImage = new BufferedImage(newWidth, newHeight, originalImage.getType());
        Graphics2D g = resizedImage.createGraphics();

        // Set rendering hints for better quality
        g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
        g.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);

        g.drawImage(originalImage, 0, 0, newWidth, newHeight, null);
        g.dispose();

        // Get the image format
        String format = getImageFormat(file.getContentType(), file.getOriginalFilename());

        // Save the optimized image
        if (format.equals("JPEG")) {
            // For JPEG, we can control quality
            Iterator<ImageWriter> writers = ImageIO.getImageWritersByFormatName("jpeg");
            ImageWriter writer = writers.next();
            ImageWriteParam param = writer.getDefaultWriteParam();
            param.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
            param.setCompressionQuality(IMAGE_QUALITY);

            ImageOutputStream output = ImageIO.createImageOutputStream(targetPath.toFile());
            writer.setOutput(output);
            writer.write(null, new IIOImage(resizedImage, null, null), param);
            writer.dispose();
            output.close();
        } else {
            // For PNG and GIF, we just save as is
            ImageIO.write(resizedImage, format, targetPath.toFile());
        }
    }

    @GetMapping
    public String showProducts(Model model, HttpSession session) {
        System.out.println("ProductController: Showing products page");

        // Check if user is admin
        String role = (String) session.getAttribute("role");
        if (!"Admin".equals(role)) {
            System.out.println("ProductController: User is not admin, redirecting to home");
            return "redirect:/";
        }

        List<Product> products = productService.getAllProducts();
        System.out.println("ProductController: Retrieved " + (products != null ? products.size() : 0) + " products");

        if (products == null || products.isEmpty()) {
            System.out.println("ProductController: No products found");
            model.addAttribute("products", new ArrayList<>());
        } else {
            System.out.println("ProductController: Adding products to model");
            model.addAttribute("products", products);
        }

        return "products";
    }

    @GetMapping("/add")
    public String showAddProductForm(Model model) {
        model.addAttribute("product", new Product(0, "", "", "", 0.0, 0, 0, 0, ""));
        return "add-product";
    }

    @PostMapping("/add")
    public String addProduct(
            @RequestParam("name") String name,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam("category") String category,
            @RequestParam("price") String priceStr,
            @RequestParam("quantityAvailable") String quantityAvailableStr,
            @RequestParam("initialStock") String initialStockStr,
            @RequestParam("currentStock") String currentStockStr,
            @RequestParam("image") MultipartFile image,
            RedirectAttributes redirectAttributes,
            HttpSession session) {

        // Check if user is admin
        String role = (String) session.getAttribute("role");
        if (!"Admin".equals(role)) {
            System.out.println("ProductController: User is not admin, redirecting to home");
            return "redirect:/";
        }

        System.out.println("ProductController: Adding new product");
        System.out.println("Name: " + name);
        System.out.println("Category: " + category);
        System.out.println("Price: " + priceStr);

        double price;
        int quantityAvailable;
        int initialStock;
        int currentStock;
        try {
            price = priceStr.isEmpty() ? 0.0 : Double.parseDouble(priceStr);
            quantityAvailable = quantityAvailableStr.isEmpty() ? 0 : Integer.parseInt(quantityAvailableStr);
            initialStock = initialStockStr.isEmpty() ? 0 : Integer.parseInt(initialStockStr);
            currentStock = currentStockStr.isEmpty() ? 0 : Integer.parseInt(currentStockStr);
        } catch (NumberFormatException e) {
            System.err.println("Error parsing numeric values: " + e.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid price, quantity, initial stock, or current stock format.");
            return "redirect:/products/add";
        }

        String imageName = "";
        if (!image.isEmpty()) {
            // Check file size
            if (image.getSize() > MAX_FILE_SIZE) {
                redirectAttributes.addFlashAttribute("errorMessage", "Image size exceeds 20MB limit.");
                return "redirect:/products/add";
            }

            // Check file type
            String contentType = image.getContentType();
            String originalFilename = image.getOriginalFilename();

            if (!isValidImageType(contentType) || !isValidImageExtension(originalFilename)) {
                redirectAttributes.addFlashAttribute("errorMessage",
                        "Invalid file format. Allowed formats: JPG, JPEG, PNG, and GIF files.");
                return "redirect:/products/add";
            }

            try {
                File uploadDir = new File(UPLOAD_DIR);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Generate unique filename with original extension
                String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
                imageName = System.currentTimeMillis() + "_" + name.replaceAll("[^a-zA-Z0-9]", "_") + extension;

                Path filePath = Paths.get(UPLOAD_DIR, imageName);
                optimizeImage(image, filePath);
                System.out.println("ProductController: Saved optimized image: " + imageName);
            } catch (IOException e) {
                e.printStackTrace();
                redirectAttributes.addFlashAttribute("errorMessage", "Error processing image. Please ensure it's a valid image file.");
                return "redirect:/products/add";
            }
        }

        Product product = new Product(0, name, description, category, price, quantityAvailable, initialStock, currentStock, imageName);
        System.out.println("ProductController: Created product object: " + product.toString());

        if (productService.addProduct(product)) {
            System.out.println("ProductController: Product added successfully");
            redirectAttributes.addFlashAttribute("successMessage", "Product added successfully!");
        } else {
            System.out.println("ProductController: Failed to add product");
            redirectAttributes.addFlashAttribute("errorMessage", "Price or quantity cannot be less than 0.");
            return "redirect:/products/add";
        }
        return "redirect:/products";
    }

    @GetMapping("/edit/{id}")
    public String showEditProductForm(@PathVariable("id") int id, Model model, RedirectAttributes redirectAttributes) {
        Product product = productService.getProductById(id);
        if (product == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Product not found.");
            return "redirect:/products";
        }
        model.addAttribute("product", product);
        return "edit-product";
    }

    @PostMapping("/edit/{id}")
    public String editProduct(
            @PathVariable("id") int id,
            @RequestParam("name") String name,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam("category") String category,
            @RequestParam("price") String priceStr,
            @RequestParam("quantityAvailable") String quantityAvailableStr,
            @RequestParam("initialStock") String initialStockStr,
            @RequestParam("currentStock") String currentStockStr,
            @RequestParam("image") MultipartFile image,
            @RequestParam(value = "existingImage", required = false) String existingImage,
            RedirectAttributes redirectAttributes) {
        double price;
        int quantityAvailable;
        int initialStock;
        int currentStock;
        try {
            price = priceStr.isEmpty() ? 0.0 : Double.parseDouble(priceStr);
            quantityAvailable = quantityAvailableStr.isEmpty() ? 0 : Integer.parseInt(quantityAvailableStr);
            initialStock = initialStockStr.isEmpty() ? 0 : Integer.parseInt(initialStockStr);
            currentStock = currentStockStr.isEmpty() ? 0 : Integer.parseInt(currentStockStr);
        } catch (NumberFormatException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid price, quantity, initial stock, or current stock format.");
            return "redirect:/products/edit/" + id;
        }

        String imageName = existingImage != null ? existingImage : "";
        if (!image.isEmpty()) {
            // Check file size
            if (image.getSize() > MAX_FILE_SIZE) {
                redirectAttributes.addFlashAttribute("errorMessage", "Image size exceeds 20MB limit.");
                return "redirect:/products/edit/" + id;
            }

            // Check file type
            String contentType = image.getContentType();
            String originalFilename = image.getOriginalFilename();

            if (!isValidImageType(contentType) || !isValidImageExtension(originalFilename)) {
                redirectAttributes.addFlashAttribute("errorMessage", "Invalid file format. Only JPG, JPEG, PNG, and GIF files are allowed.");
                return "redirect:/products/edit/" + id;
            }

            try {
                File uploadDir = new File(UPLOAD_DIR);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Generate unique filename with original extension
                String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
                imageName = System.currentTimeMillis() + "_" + name.replaceAll("[^a-zA-Z0-9]", "_") + extension;

                Path filePath = Paths.get(UPLOAD_DIR, imageName);
                optimizeImage(image, filePath);

                // Delete old image if it exists
                if (existingImage != null && !existingImage.isEmpty()) {
                    Path oldFilePath = Paths.get(UPLOAD_DIR, existingImage);
                    Files.deleteIfExists(oldFilePath);
                }
            } catch (IOException e) {
                e.printStackTrace();
                redirectAttributes.addFlashAttribute("errorMessage", "Error processing image.");
                return "redirect:/products/edit/" + id;
            }
        }

        Product updatedProduct = new Product(id, name, description, category, price, quantityAvailable, initialStock, currentStock, imageName);
        if (productService.updateProduct(updatedProduct)) {
            redirectAttributes.addFlashAttribute("successMessage", "Product updated successfully!");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Price or quantity cannot be less than 0.");
            return "redirect:/products/edit/" + id;
        }
        return "redirect:/products";
    }

    @GetMapping("/delete/{id}")
    public String deleteProduct(@PathVariable("id") int id, RedirectAttributes redirectAttributes) {
        Product product = productService.getProductById(id);
        if (product != null && product.getImage() != null && !product.getImage().isEmpty()) {
            try {
                Path filePath = Paths.get(UPLOAD_DIR, product.getImage());
                Files.deleteIfExists(filePath);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        productService.deleteProduct(id);
        redirectAttributes.addFlashAttribute("successMessage", "Product deleted successfully!");
        return "redirect:/products";
    }

    @GetMapping("/customer")
    public String showCustomerProducts(
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "category", required = false) String category,
            Model model) {
        List<Product> products = productService.getAllProducts();

        if (search != null && !search.trim().isEmpty()) {
            String searchLower = search.toLowerCase();
            products = products.stream()
                    .filter(p -> p.getName().toLowerCase().contains(searchLower)
                    || (p.getDescription() != null && p.getDescription().toLowerCase().contains(searchLower)))
                    .collect(Collectors.toList());
        }

        if (category != null && !category.trim().isEmpty() && !category.equals("All")) {
            products = products.stream()
                    .filter(p -> p.getCategory().equalsIgnoreCase(category))
                    .collect(Collectors.toList());
        }

        model.addAttribute("products", products);
        model.addAttribute("categories", new String[]{"All", "Bread", "Cake", "Pastry", "Cookie", "Other"});
        model.addAttribute("selectedCategory", category != null ? category : "All");
        model.addAttribute("searchQuery", search != null ? search : "");

        return "customer";
    }

    @GetMapping("/view/{id}")
    public String viewProduct(@PathVariable("id") int id, Model model, RedirectAttributes redirectAttributes) {
        Product product = productService.getProductById(id);
        if (product == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Product not found.");
            return "redirect:/products/customer";
        }
        model.addAttribute("product", product);
        model.addAttribute("reviews", reviewDAO.getReviewsByProductId(id));
        return "single-product";
    }

    @GetMapping("/orders/place/{productId}")
    public String placeOrder(
            @PathVariable("productId") int productId,
            @RequestParam(value = "quantity", defaultValue = "1") int quantity,
            HttpSession session,
            Model model,
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
        if (product.getCurrentStock() <= 0) {
            redirectAttributes.addFlashAttribute("errorMessage", "Product is out of stock.");
            return "redirect:/products/view/" + productId;
        }
        if (quantity <= 0 || quantity > product.getCurrentStock()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Please select a quantity between 1 and " + product.getCurrentStock() + ".");
            return "redirect:/products/view/" + productId;
        }

        User user = userService.getUserByUsername(username);
        if (user == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "User not found.");
            return "redirect:/";
        }

        model.addAttribute("product", product);
        model.addAttribute("userId", user.getId());
        model.addAttribute("quantity", quantity);
        return "order-confirmation";
    }

    @PostMapping("/{id}/review")
    public String addReview(
            @PathVariable("id") int productId,
            @RequestParam("customerName") String customerName,
            @RequestParam("rating") int rating,
            @RequestParam("comment") String comment,
            RedirectAttributes redirectAttributes) {

        if (rating < 1 || rating > 5) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid rating value.");
            return "redirect:/products/view/" + productId;
        }

        Review review = new Review(0, productId, customerName, rating, comment, null);
        if (reviewDAO.addReview(review)) {
            redirectAttributes.addFlashAttribute("successMessage", "Review added successfully!");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to add review.");
        }
        return "redirect:/products/view/" + productId;
    }

    @PostMapping("/review/edit")
    public String editReview(
            @RequestParam int reviewId,
            @RequestParam int rating,
            @RequestParam String comment,
            @RequestParam int productId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        String customerName = (String) session.getAttribute("customerName");
        if (customerName == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Please login to edit reviews");
            return "redirect:/products/view/" + productId;
        }

        ReviewDAO reviewDAO = new ReviewDAO();
        Review existingReview = reviewDAO.getReviewById(reviewId);

        if (existingReview == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Review not found");
            return "redirect:/products/view/" + productId;
        }

        if (!existingReview.getCustomerName().equals(customerName)) {
            redirectAttributes.addFlashAttribute("errorMessage", "You can only edit your own reviews");
            return "redirect:/products/view/" + productId;
        }

        existingReview.setRating(rating);
        existingReview.setComment(comment);

        if (reviewDAO.updateReview(existingReview)) {
            redirectAttributes.addFlashAttribute("successMessage", "Review updated successfully!");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to update review");
        }
        return "redirect:/products/view/" + productId;
    }

    @PostMapping("/review/delete")
    public String deleteReview(
            @RequestParam int reviewId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        String customerName = (String) session.getAttribute("customerName");
        if (customerName == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Please login to delete reviews");
            return "redirect:/products/customer";
        }

        ReviewDAO reviewDAO = new ReviewDAO();
        Review existingReview = reviewDAO.getReviewById(reviewId);

        if (existingReview == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Review not found");
            return "redirect:/products/customer";
        }

        if (!existingReview.getCustomerName().equals(customerName)) {
            redirectAttributes.addFlashAttribute("errorMessage", "You can only delete your own reviews");
            return "redirect:/products/customer";
        }

        if (reviewDAO.deleteReview(reviewId)) {
            redirectAttributes.addFlashAttribute("successMessage", "Review deleted successfully!");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to delete review");
        }
        return "redirect:/products/customer";
    }

    @GetMapping("/review/delete-test")
    @ResponseBody
    public String testDelete() {
        return "Delete mapping works!";
    }
}
