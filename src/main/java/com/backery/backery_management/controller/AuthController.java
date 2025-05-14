package com.backery.backery_management.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.backery.backery_management.model.User;
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
            User user = userService.getUserByUsername(username);
            if (user != null && "Admin".equals(user.getRole())) {
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
            User user = userService.getUserByUsername(username);
            if (user != null && "Admin".equals(user.getRole())) {
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
            session.setAttribute("customerName", username);
            User user = userService.getUserByUsername(username);
            if (user != null) {
                session.setAttribute("role", user.getRole());
                if ("Admin".equals(user.getRole())) {
                    return "redirect:/home";
                }
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
            @RequestParam String confirmPassword,
            @RequestParam String email,
            RedirectAttributes redirectAttributes) {
        if (!password.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("error", "Passwords do not match.");
            return "redirect:/signup";
        }
        String role = "User";
        if (userService.registerUser(username, password, email, role)) {
            redirectAttributes.addFlashAttribute("success", "Registration successful! Please login.");
            return "redirect:/";
        } else {
            redirectAttributes.addFlashAttribute("error", "Registration failed. Username might already exist or invalid data provided.");
            return "redirect:/signup";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        session.invalidate();
        redirectAttributes.addFlashAttribute("message", "You have been logged out successfully.");
        return "redirect:/";
    }
}
