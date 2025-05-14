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

import com.backery.backery_management.model.Vendor;
import com.backery.backery_management.service.VendorService;

@Controller
@RequestMapping("/vendors")
public class VendorController {

    @Autowired
    private VendorService vendorService;

    @GetMapping
    public String showVendors(Model model) {
        model.addAttribute("vendors", vendorService.getAllVendors());
        return "vendors";
    }

    @GetMapping("/add")
    public String showAddVendorForm(Model model) {
        model.addAttribute("vendor", new Vendor(0, "", "", "", ""));
        return "add-vendor";
    }

    @PostMapping("/add")
    public String addVendor(
            @RequestParam("name") String name,
            @RequestParam("email") String email,
            @RequestParam("phone") String phone,
            @RequestParam("company") String company,
            RedirectAttributes redirectAttributes) {
        Vendor vendor = new Vendor(0, name, email, phone, company);
        if (!vendorService.addVendor(vendor)) {
            redirectAttributes.addFlashAttribute("message", "Failed to add vendor. Invalid data.");
            return "redirect:/vendors/add";
        }
        redirectAttributes.addFlashAttribute("message", "Vendor added successfully!");
        return "redirect:/vendors";
    }

    @GetMapping("/edit/{id}")
    public String showEditVendorForm(@PathVariable("id") int id, Model model, RedirectAttributes redirectAttributes) {
        Vendor vendor = vendorService.getVendorById(id);
        if (vendor == null) {
            redirectAttributes.addFlashAttribute("message", "Vendor not found.");
            return "redirect:/vendors";
        }
        model.addAttribute("vendor", vendor);
        return "edit-vendor";
    }

    @PostMapping("/edit/{id}")
    public String editVendor(
            @PathVariable("id") int id,
            @RequestParam("name") String name,
            @RequestParam("email") String email,
            @RequestParam("phone") String phone,
            @RequestParam("company") String company,
            RedirectAttributes redirectAttributes) {
        Vendor updatedVendor = new Vendor(id, name, email, phone, company);
        if (!vendorService.updateVendor(updatedVendor)) {
            redirectAttributes.addFlashAttribute("message", "Failed to update vendor. Invalid data.");
            return "redirect:/vendors/edit/" + id;
        }
        redirectAttributes.addFlashAttribute("message", "Vendor updated successfully!");
        return "redirect:/vendors";
    }

    @GetMapping("/delete/{id}")
    public String deleteVendor(@PathVariable("id") int id, RedirectAttributes redirectAttributes) {
        if (!vendorService.deleteVendor(id)) {
            redirectAttributes.addFlashAttribute("message", "Vendor not found.");
        } else {
            redirectAttributes.addFlashAttribute("message", "Vendor deleted successfully!");
        }
        return "redirect:/vendors";
    }
} 