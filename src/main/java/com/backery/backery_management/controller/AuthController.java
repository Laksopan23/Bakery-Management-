package com.backery.backery_management.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.backery.backery_management.service.UserService;

@Controller
public class AuthController {
    
    @Autowired
    private UserService userService;
    
    @GetMapping("/")
    public String loginPage() {
        return "login";
    }
    
    @GetMapping("/signup")
    public String signupPage() {
        return "signup";
    }
    
    @PostMapping("/")
    public String processLogin(@RequestParam String username, 
                             @RequestParam String password,
                             RedirectAttributes redirectAttributes) {
        if (userService.authenticateUser(username, password)) {
            if ("admin".equals(username)) {
                return "redirect:/home";
            }
            return "redirect:/customer";
        } else {
            redirectAttributes.addFlashAttribute("error", "Invalid username or password");
            return "redirect:/";
        }
    }
    
    @PostMapping("/signup")
    public String processSignup(@RequestParam String username, 
                              @RequestParam String password,
                              @RequestParam String email,
                              RedirectAttributes redirectAttributes) {
        if (userService.registerUser(username, password, email)) {
            redirectAttributes.addFlashAttribute("success", "Registration successful! Please login.");
            return "redirect:/";
        } else {
            redirectAttributes.addFlashAttribute("error", "Registration failed. Username might already exist or invalid data provided.");
            return "redirect:/signup";
        }
    }
} 