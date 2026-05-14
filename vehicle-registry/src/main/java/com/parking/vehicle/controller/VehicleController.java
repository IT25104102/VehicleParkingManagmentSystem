package com.parking.vehicle.controller;

import com.parking.vehicle.model.Vehicle;
import com.parking.vehicle.service.VehicleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.util.List;

/**
 *  handles HTTP requests for Vehicle Registry.
 * Maps URLs to Thymeleaf HTML templates.
 *
 *
 */
@Controller
@RequestMapping("/vehicles")
public class VehicleController {

    @Autowired
    private VehicleService vehicleService;

    // ─── HOME / LIST ALL ─────────────────────────────────────────────────────

    /**
     * GET /vehicles → Show all vehicles (home dashboard)
     */
    @GetMapping
    public String listVehicles(Model model) throws IOException {
        List<Vehicle> vehicles = vehicleService.getAllVehicles();
        model.addAttribute("vehicles", vehicles);
        model.addAttribute("totalCount", vehicles.size());
        return "vehicle-list"; // → templates/vehicle-list.html
    }

    // ─── CREATE ──────────────────────────────────────────────────────────────

    /**
     * GET /vehicles/add → Show the Add Vehicle form
     */
    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("vehicle", new Vehicle());
        return "vehicle-add"; // → templates/vehicle-add.html
    }

    /**
     * POST /vehicles/add → Process Add Vehicle form submission
     */
    @PostMapping("/add")
    public String addVehicle(@ModelAttribute Vehicle vehicle,
                             RedirectAttributes redirectAttributes) throws IOException {
        boolean success = vehicleService.addVehicle(vehicle);
        if (success) {
            redirectAttributes.addFlashAttribute("successMessage",
                "Vehicle '" + vehicle.getPlateNumber() + "' registered successfully!");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage",
                "A vehicle with plate number '" + vehicle.getPlateNumber() + "' already exists!");
        }
        return "redirect:/vehicles";
    }

    // ─── READ / SEARCH ───────────────────────────────────────────────────────

    /**
     * GET /vehicles/search → Show search page
     */
    @GetMapping("/search")
    public String showSearchPage() {
        return "vehicle-search"; // → templates/vehicle-search.html
    }

    /**
     * GET /vehicles/search?plate=CAR-1234 → Search by plate number
     */
    @GetMapping("/search/plate")
    public String searchByPlate(@RequestParam String plate, Model model) throws IOException {
        Vehicle vehicle = vehicleService.searchByPlate(plate);
        if (vehicle != null) {
            model.addAttribute("vehicle", vehicle);
            model.addAttribute("found", true);
        } else {
            model.addAttribute("found", false);
            model.addAttribute("searchedPlate", plate);
        }
        return "vehicle-search";
    }

    /**
     * GET /vehicles/search/owner?ownerId=IT001 → Search by owner ID
     */
    @GetMapping("/search/owner")
    public String searchByOwner(@RequestParam String ownerId, Model model) throws IOException {
        List<Vehicle> vehicles = vehicleService.searchByOwnerId(ownerId);
        model.addAttribute("vehicles", vehicles);
        model.addAttribute("searchedOwner", ownerId);
        model.addAttribute("ownerSearch", true);
        return "vehicle-search";
    }

    // ─── UPDATE ──────────────────────────────────────────────────────────────

    /**
     * GET /vehicles/edit/{plateNumber} → Show Edit form pre-filled with vehicle data
     */
    @GetMapping("/edit/{plateNumber}")
    public String showEditForm(@PathVariable String plateNumber, Model model) throws IOException {
        Vehicle vehicle = vehicleService.searchByPlate(plateNumber);
        if (vehicle == null) {
            return "redirect:/vehicles";
        }
        model.addAttribute("vehicle", vehicle);
        return "vehicle-edit"; // → templates/vehicle-edit.html
    }

    /**
     * POST /vehicles/edit/{plateNumber} → Process edit form submission
     */
    @PostMapping("/edit/{plateNumber}")
    public String updateVehicle(@PathVariable String plateNumber,
                                @ModelAttribute Vehicle updatedVehicle,
                                RedirectAttributes redirectAttributes) throws IOException {
        boolean success = vehicleService.updateVehicle(plateNumber, updatedVehicle);
        if (success) {
            redirectAttributes.addFlashAttribute("successMessage",
                "Vehicle '" + plateNumber + "' updated successfully!");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage",
                "Vehicle not found!");
        }
        return "redirect:/vehicles";
    }

    // ─── DELETE ──────────────────────────────────────────────────────────────

    /**
     * GET /vehicles/delete/{plateNumber} → Show delete confirmation page
     */
    @GetMapping("/delete/{plateNumber}")
    public String showDeleteConfirm(@PathVariable String plateNumber, Model model) throws IOException {
        Vehicle vehicle = vehicleService.searchByPlate(plateNumber);
        if (vehicle == null) {
            return "redirect:/vehicles";
        }
        model.addAttribute("vehicle", vehicle);
        return "vehicle-delete"; // → templates/vehicle-delete.html
    }

    /**
     * POST /vehicles/delete/{plateNumber} → Confirm and delete
     */
    @PostMapping("/delete/{plateNumber}")
    public String deleteVehicle(@PathVariable String plateNumber,
                                RedirectAttributes redirectAttributes) throws IOException {
        boolean success = vehicleService.deleteVehicle(plateNumber);
        if (success) {
            redirectAttributes.addFlashAttribute("successMessage",
                "Vehicle '" + plateNumber + "' removed from registry.");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage",
                "Vehicle not found!");
        }
        return "redirect:/vehicles";
    }
}
