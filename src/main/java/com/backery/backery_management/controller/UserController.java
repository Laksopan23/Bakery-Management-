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

import com.backery.backery_management.model.User;
import com.backery.backery_management.service.UserService;

@Controller
@RequestMapping("/users")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping
    public String showUsers(Model model) {
        model.addAttribute("users", userService.getAllUsers());
        return "users";
    }

    @GetMapping("/add")
    public String showAddUserForm(Model model) {
        model.addAttribute("user", new User(0, "", "", "", "User"));
        return "add-user";
    }

    @PostMapping("/add")
    public String addUser(
            @RequestParam("username") String username,
            @RequestParam("email") String email,
            @RequestParam("role") String role,
            @RequestParam(value = "password", required = false) String password,
            RedirectAttributes redirectAttributes) {
        // Password is required for Admin role
        if ("Admin".equals(role) && (password == null || password.trim().isEmpty())) {
            redirectAttributes.addFlashAttribute("message", "Password is required for Admin role.");
            return "redirect:/users/add";
        }
        // Password can be empty for User role
        password = password != null ? password : "";
        if (!userService.registerUser(username, password, email, role)) {
            redirectAttributes.addFlashAttribute("message", "Failed to add user. Username might already exist or invalid data.");
            return "redirect:/users/add";
        }
        redirectAttributes.addFlashAttribute("message", "User added successfully!");
        return "redirect:/users";
    }

    @GetMapping("/edit/{id}")
    public String showEditUserForm(@PathVariable("id") int id, Model model, RedirectAttributes redirectAttributes) {
        User user = userService.getUserById(id);
        if (user == null) {
            redirectAttributes.addFlashAttribute("message", "User not found.");
            return "redirect:/users";
        }
        model.addAttribute("user", user);
        return "edit-user";
    }

    @PostMapping("/edit/{id}")
    public String editUser(
            @PathVariable("id") int id,
            @RequestParam("username") String username,
            @RequestParam("email") String email,
            @RequestParam("role") String role,
            @RequestParam(value = "password", required = false) String password,
            RedirectAttributes redirectAttributes) {
        // Password is required for Admin role
        if ("Admin".equals(role) && (password == null || password.trim().isEmpty())) {
            redirectAttributes.addFlashAttribute("message", "Password is required for Admin role.");
            return "redirect:/users/edit/" + id;
        }
        User existingUser = userService.getUserById(id);
        if (existingUser == null) {
            redirectAttributes.addFlashAttribute("message", "User not found.");
            return "redirect:/users";
        }
        password = (password != null && !password.trim().isEmpty()) ? password : existingUser.getPassword();
        User updatedUser = new User(id, username, password, email, role);
        if (!userService.updateUser(updatedUser)) {
            redirectAttributes.addFlashAttribute("message", "Failed to update user. Invalid data.");
            return "redirect:/users/edit/" + id;
        }
        redirectAttributes.addFlashAttribute("message", "User updated successfully!");
        return "redirect:/users";
    }

    @GetMapping("/delete/{id}")
    public String deleteUser(@PathVariable("id") int id, RedirectAttributes redirectAttributes) {
        if (!userService.deleteUser(id)) {
            redirectAttributes.addFlashAttribute("message", "User not found.");
        } else {
            redirectAttributes.addFlashAttribute("message", "User deleted successfully!");
        }
        return "redirect:/users";
    }
}
