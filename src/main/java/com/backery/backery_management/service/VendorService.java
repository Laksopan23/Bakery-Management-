package com.backery.backery_management.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.backery.backery_management.dao.VendorDAO;
import com.backery.backery_management.model.Vendor;

@Service
public class VendorService {
    private final VendorDAO vendorDAO = new VendorDAO();

    public List<Vendor> getAllVendors() {
        return vendorDAO.getAllVendors();
    }

    public boolean addVendor(Vendor vendor) {
        List<Vendor> vendors = vendorDAO.getAllVendors();
        int newId = vendors.isEmpty() ? 1 : vendors.get(vendors.size() - 1).getId() + 1;
        vendor.setId(newId);
        return vendorDAO.saveVendor(vendor);
    }

    public boolean updateVendor(Vendor vendor) {
        vendorDAO.updateVendor(vendor);
        return true;
    }

    public boolean deleteVendor(int id) {
        vendorDAO.deleteVendor(id);
        return true;
    }

    public Vendor getVendorById(int id) {
        return vendorDAO.getVendorById(id);
    }
} 