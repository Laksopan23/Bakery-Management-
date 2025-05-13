package com.backery.backery_management.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.backery.backery_management.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    @GetMapping("/")
    public String loginPage(HttpSession session) {
        String username = (String) session.getAttribute("username");
        if (username != null) {
            if ("admin".equals(username)) {
                return "redirect:/home";
            } else {
                return "redirect:/products/customer";
            }
        }
        return "login";
    }

    @GetMapping("/signup")
    public String signupPage(HttpSession session) {
        String username = (String) session.getAttribute("username");
        if (username != null) {
            if ("admin".equals(username)) {
                return "redirect:/home";
            } else {
                return "redirect:/products/customer";
            }
        }
        return "signup";
    }

    @PostMapping("/")
    public String processLogin(@RequestParam String username,
            @RequestParam String password,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        if (userService.authenticateUser(username, password)) {
            session.setAttribute("username", username);
            if ("admin".equals(username)) {
                return "redirect:/home";
            }
            return "redirect:/products/customer";
        } else {
            redirectAttributes.addFlashAttribute("error", "Invalid username or password");
            return "redirect:/";
        }
    }

    @PostMapping("/signup")
    public String processSignup(
            @RequestParam String username,
            @RequestParam String password,
            @RequestParam String email,
            @RequestParam(value = "role", defaultValue = "User") String role,
            RedirectAttributes redirectAttributes) {
        // Validate password for admin role
        if ("Admin".equals(role) && (password == null || password.trim().isEmpty())) {
            redirectAttributes.addFlashAttribute("error", "Password is required for Admin role.");
            return "redirect:/signup";
        }
        if (userService.registerUser(username, password, email, role)) {
            redirectAttributes.addFlashAttribute("success", "Registration successful! Please login.");
            return "redirect:/";
        } else {
            redirectAttributes.addFlashAttribute("error", "Registration failed. Username might already exist or invalid data provided.");
            return "redirect:/signup";
        }
    }
}
