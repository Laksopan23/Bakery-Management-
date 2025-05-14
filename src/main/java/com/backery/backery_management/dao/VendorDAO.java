package com.backery.backery_management.dao;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.backery.backery_management.model.Vendor;

public class VendorDAO {
    private final String filePath = "data/vendors.txt";

    public List<Vendor> getAllVendors() {
        List<Vendor> vendors = new ArrayList<>();
        File file = new File(filePath);
        try {
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    if (line.trim().isEmpty()) continue;
                    String[] parts = line.split(",");
                    if (parts.length == 5) {
                        try {
                            int id = Integer.parseInt(parts[0].trim());
                            String name = parts[1].trim();
                            String email = parts[2].trim();
                            String phone = parts[3].trim();
                            String company = parts[4].trim();
                            vendors.add(new Vendor(id, name, email, phone, company));
                        } catch (NumberFormatException e) {
                            System.err.println("Invalid ID format in vendors.txt: " + line);
                        }
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading vendors.txt: " + e.getMessage());
        }
        return vendors;
    }

    public boolean saveVendor(Vendor vendor) {
        try {
            File file = new File(filePath);
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath, true))) {
                writer.write(vendor.toString());
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            System.err.println("Error saving vendor: " + e.getMessage());
            return false;
        }
    }

    public void updateVendor(Vendor updatedVendor) {
        List<Vendor> vendors = getAllVendors();
        File file = new File(filePath);
        try {
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
                boolean updated = false;
                for (Vendor v : vendors) {
                    if (v.getId() == updatedVendor.getId()) {
                        writer.write(updatedVendor.toString());
                        updated = true;
                    } else {
                        writer.write(v.toString());
                    }
                    writer.newLine();
                }
                if (!updated && updatedVendor.getId() > 0) {
                    writer.write(updatedVendor.toString());
                    writer.newLine();
                }
            }
        } catch (IOException e) {
            System.err.println("Error updating vendors.txt: " + e.getMessage());
        }
    }

    public void deleteVendor(int id) {
        List<Vendor> vendors = getAllVendors();
        File file = new File(filePath);
        try {
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
                boolean deleted = false;
                for (Vendor v : vendors) {
                    if (v.getId() != id) {
                        writer.write(v.toString());
                        writer.newLine();
                    } else {
                        deleted = true;
                    }
                }
                if (!deleted) {
                    System.err.println("Vendor with ID " + id + " not found for deletion.");
                }
            }
        } catch (IOException e) {
            System.err.println("Error deleting from vendors.txt: " + e.getMessage());
        }
    }

    public Vendor getVendorById(int id) {
        return getAllVendors().stream()
                .filter(v -> v.getId() == id)
                .findFirst()
                .orElse(null);
    }
} 