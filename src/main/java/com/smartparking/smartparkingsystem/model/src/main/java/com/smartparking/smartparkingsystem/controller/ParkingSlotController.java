package com.smartparking.smartparkingsystem.controller;

import com.smartparking.smartparkingsystem.model.ParkingSlot;
import com.smartparking.smartparkingsystem.service.ParkingSlotService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

/**
 * ParkingSlotController — request handling for Parking Slot Management
 * Developer: Naveed M.I.M | IT25101466
 * Module: Parking Slot Management
 *
 * URL Map
 * ─────────────────────────────────────────────────────
 * GET  /slots              → slot map dashboard
 * GET  /slots/manage       → management table (add / delete)
 * POST /slots/add          → create new slot
 * POST /slots/toggle/{id}  → toggle AVAILABLE ↔ OCCUPIED
 * POST /slots/delete/{id}  → delete a slot
 * GET  /slots/checkin/{id} → check-in page (redirect to checkin module)
 */
@Controller
@RequestMapping("/slots")
public class ParkingSlotController {

    @Autowired
    private ParkingSlotService slotService;

    // ── Dashboard / Slot Map ──────────────────────────────────────────────────

    @GetMapping
    public String slotMap(Model model) {
        List<ParkingSlot> slots = slotService.getAllSlots();
        model.addAttribute("slots",        slots);
        model.addAttribute("totalSlots",   slots.size());
        model.addAttribute("available",    slotService.countAvailable());
        model.addAttribute("occupied",     slotService.countOccupied());
        model.addAttribute("pending",      slotService.countPending());
        model.addAttribute("preReserved",  slotService.countPreReserved());
        return "slots/slotMap";
    }

    // ── Management Table ──────────────────────────────────────────────────────

    @GetMapping("/manage")
    public String manage(Model model) {
        model.addAttribute("slots",     slotService.getAllSlots());
        model.addAttribute("slotTypes", ParkingSlot.SlotType.values());
        return "slots/manage";
    }

    // ── CREATE ────────────────────────────────────────────────────────────────

    @PostMapping("/add")
    public String addSlot(@RequestParam String slotNumber,
                          @RequestParam String slotType,
                          RedirectAttributes ra) {

        String result = slotService.addSlot(slotNumber, slotType);
        switch (result) {
            case "SUCCESS"   -> ra.addFlashAttribute("successMsg",
                                    "Slot " + slotNumber.toUpperCase() + " added successfully!");
            case "DUPLICATE" -> ra.addFlashAttribute("errorMsg",
                                    "Slot number already exists: " + slotNumber);
            default          -> ra.addFlashAttribute("errorMsg",
                                    "Invalid data. Please check your input.");
        }
        return "redirect:/slots/manage";
    }

    // ── UPDATE (toggle) ───────────────────────────────────────────────────────

    @PostMapping("/toggle/{id}")
    public String toggleStatus(@PathVariable String id,
                               @RequestParam(defaultValue = "map") String from,
                               RedirectAttributes ra) {

        String result = slotService.toggleStatus(id);
        if ("NOT_FOUND".equals(result) || "ERROR".equals(result)) {
            ra.addFlashAttribute("errorMsg", "Could not update slot status.");
        } else {
            ra.addFlashAttribute("successMsg", "Slot status updated to: " + result);
        }
        return "manage".equals(from) ? "redirect:/slots/manage" : "redirect:/slots";
    }

    // ── DELETE ────────────────────────────────────────────────────────────────

    @PostMapping("/delete/{id}")
    public String deleteSlot(@PathVariable String id,
                             RedirectAttributes ra) {

        String result = slotService.deleteSlot(id);
        switch (result) {
            case "SUCCESS"   -> ra.addFlashAttribute("successMsg", "Slot removed successfully.");
            case "IN_USE"    -> ra.addFlashAttribute("errorMsg",
                                    "Cannot delete an occupied / pending slot.");
            case "NOT_FOUND" -> ra.addFlashAttribute("errorMsg", "Slot not found.");
            default          -> ra.addFlashAttribute("errorMsg", "Deletion failed.");
        }
        return "redirect:/slots/manage";
    }

    // ── Check-In redirect ─────────────────────────────────────────────────────

    @GetMapping("/checkin/{id}")
    public String checkIn(@PathVariable String id, Model model) {
        Optional<ParkingSlot> opt = slotService.getSlotById(id);
        if (opt.isEmpty()) return "redirect:/slots";

        ParkingSlot slot = opt.get();
        if (slot.getStatus() != ParkingSlot.Status.AVAILABLE) {
            // Slot not available — bounce back to map
            return "redirect:/slots";
        }
        // Hand off to checkin module (adjust mapping to match your team's URL)
        return "redirect:/checkin?slotId=" + id
               + "&slotNumber=" + slot.getSlotNumber()
               + "&slotType="   + slot.getSlotType();
    }
}
