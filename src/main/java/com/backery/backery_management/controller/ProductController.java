package com.backery.backery_management.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.backery.backery_management.model.Product;
import com.backery.backery_management.service.ProductService;

@Controller
@RequestMapping("/products")
public class ProductController {

    @Autowired
    private ProductService productService;

    private static final String UPLOAD_DIR = "src/main/webapp/resources/images/products/";

    @GetMapping
    public String showProducts(Model model) {
        model.addAttribute("products", productService.getAllProducts());
        return "products";
    }

    @GetMapping("/add")
    public String showAddProductForm(Model model) {
        model.addAttribute("product", new Product(0, "", 0.0, ""));
        return "add-product";
    }

    @PostMapping("/add")
    public String addProduct(@RequestParam("name") String name,
            @RequestParam("price") String priceStr,
            @RequestParam("image") MultipartFile image,
            RedirectAttributes redirectAttributes) {
        // Handle empty price input
        double price;
        try {
            price = priceStr.isEmpty() ? 0.0 : Double.parseDouble(priceStr);
        } catch (NumberFormatException e) {
            redirectAttributes.addFlashAttribute("message", "Invalid price format.");
            return "redirect:/products/add";
        }

        // Validate image format (PNG only)
        String imageName = "";
        if (!image.isEmpty()) {
            String contentType = image.getContentType();
            String originalFilename = image.getOriginalFilename();
            boolean isPng = (contentType != null && contentType.equals("image/png"))
                    || (originalFilename != null && originalFilename.toLowerCase().endsWith(".png"));

            if (!isPng) {
                redirectAttributes.addFlashAttribute("message", "Invalid file format. Only PNG files are allowed.");
                return "redirect:/products/add";
            }

            try {
                File uploadDir = new File(UPLOAD_DIR);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                imageName = System.currentTimeMillis() + "_" + image.getOriginalFilename();
                Path filePath = Paths.get(UPLOAD_DIR, imageName);
                Files.write(filePath, image.getBytes());
            } catch (IOException e) {
                e.printStackTrace();
                redirectAttributes.addFlashAttribute("message", "Error uploading image.");
                return "redirect:/products/add";
            }
        }

        Product product = new Product(0, name, price, imageName);
        if (productService.addProduct(product)) {
            redirectAttributes.addFlashAttribute("message", "Product added successfully!");
        } else {
            redirectAttributes.addFlashAttribute("message", "Price cannot be less than 0.");
            return "redirect:/products/add";
        }
        return "redirect:/products";
    }

    @GetMapping("/edit/{id}")
    public String showEditProductForm(@PathVariable("id") int id, Model model, RedirectAttributes redirectAttributes) {
        Product product = productService.getProductById(id);
        if (product == null) {
            redirectAttributes.addFlashAttribute("message", "Product not found.");
            return "redirect:/products";
        }
        model.addAttribute("product", product);
        return "edit-product";
    }

    @PostMapping("/edit/{id}")
    public String editProduct(@PathVariable("id") int id,
            @RequestParam("name") String name,
            @RequestParam("price") String priceStr,
            @RequestParam("image") MultipartFile image,
            @RequestParam(value = "existingImage", required = false) String existingImage,
            RedirectAttributes redirectAttributes) {
        // Handle empty price input
        double price;
        try {
            price = priceStr.isEmpty() ? 0.0 : Double.parseDouble(priceStr);
        } catch (NumberFormatException e) {
            redirectAttributes.addFlashAttribute("message", "Invalid price format.");
            return "redirect:/products/edit/" + id;
        }

        // Validate image format (PNG only)
        String imageName = existingImage != null ? existingImage : "";
        if (!image.isEmpty()) {
            String contentType = image.getContentType();
            String originalFilename = image.getOriginalFilename();
            boolean isPng = (contentType != null && contentType.equals("image/png"))
                    || (originalFilename != null && originalFilename.toLowerCase().endsWith(".png"));

            if (!isPng) {
                redirectAttributes.addFlashAttribute("message", "Invalid file format. Only PNG files are allowed.");
                return "redirect:/products/edit/" + id;
            }

            try {
                File uploadDir = new File(UPLOAD_DIR);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                imageName = System.currentTimeMillis() + "_" + image.getOriginalFilename();
                Path filePath = Paths.get(UPLOAD_DIR, imageName);
                Files.write(filePath, image.getBytes());
                if (existingImage != null && !existingImage.isEmpty()) {
                    Path oldFilePath = Paths.get(UPLOAD_DIR, existingImage);
                    Files.deleteIfExists(oldFilePath);
                }
            } catch (IOException e) {
                e.printStackTrace();
                redirectAttributes.addFlashAttribute("message", "Error uploading new image.");
                return "redirect:/products/edit/" + id;
            }
        }

        Product updatedProduct = new Product(id, name, price, imageName);
        if (productService.updateProduct(updatedProduct)) {
            redirectAttributes.addFlashAttribute("message", "Product updated successfully!");
        } else {
            redirectAttributes.addFlashAttribute("message", "Price cannot be less than 0.");
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
        redirectAttributes.addFlashAttribute("message", "Product deleted successfully!");
        return "redirect:/products";
    }
}
