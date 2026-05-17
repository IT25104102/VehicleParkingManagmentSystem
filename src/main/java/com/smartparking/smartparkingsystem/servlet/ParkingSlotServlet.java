package com.smartparking.smartparkingsystem.servlet;

import com.smartparking.smartparkingsystem.model.ParkingSlot;
import com.smartparking.smartparkingsystem.service.ParkingSlotService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/slots")
public class ParkingSlotServlet {

    @Autowired
    private ParkingSlotService slotService;

    // READ — Slot Map Dashboard with date filter
    @GetMapping
    public String slotMap(
            @RequestParam(required = false) String date,
            Model model) {

        // Default to today if no date selected
        String selectedDate = (date != null && !date.isEmpty())
                ? date : LocalDate.now().toString();

        // Validate date
        if (!slotService.isValidDate(selectedDate)) {
            model.addAttribute("dateError",
                "No slots available for this date. Please select a date between today and " +
                LocalDate.now().plusDays(6).toString());
            selectedDate = LocalDate.now().toString();
        }

        List<ParkingSlot> slots = slotService.getSlotsByDate(selectedDate);
        List<String> availableDates = slotService.getAvailableDates();

        model.addAttribute("slots", slots);
        model.addAttribute("selectedDate", selectedDate);
        model.addAttribute("availableDates", availableDates);
        model.addAttribute("totalSlots", slots.size());
        model.addAttribute("available",
            slotService.countByStatusAndDate(ParkingSlot.Status.AVAILABLE, selectedDate));
        model.addAttribute("occupied",
            slotService.countByStatusAndDate(ParkingSlot.Status.OCCUPIED, selectedDate));
        model.addAttribute("pending",
            slotService.countByStatusAndDate(ParkingSlot.Status.PENDING, selectedDate));
        model.addAttribute("preReserved",
            slotService.countByStatusAndDate(ParkingSlot.Status.PRE_RESERVED, selectedDate));

        return "slots/slotMap";
    }

    // READ — Management Table
    @GetMapping("/manage")
    public String manage(Model model) {
        model.addAttribute("slots", slotService.getAllSlots());
        model.addAttribute("slotTypes", ParkingSlot.SlotType.values());
        return "slots/manage";
    }

    // CREATE — Add new slot
    @PostMapping("/add")
    public String addSlot(
            @RequestParam String slotNumber,
            @RequestParam String slotType,
            @RequestParam(required = false) String date,
            RedirectAttributes ra) {
        String slotDate = (date != null && !date.isEmpty())
                ? date : LocalDate.now().toString();
        boolean result = slotService.addSlotForDate(slotNumber, slotType, slotDate);
        if (result) {
            ra.addFlashAttribute("successMsg",
                "Slot " + slotNumber.toUpperCase() + " added for " + slotDate);
        } else {
            ra.addFlashAttribute("errorMsg", "Invalid data or slot already exists.");
        }
        return "redirect:/slots/manage";
    }

    // UPDATE — Toggle slot status
    @PostMapping("/toggle/{id}")
    public String toggleStatus(
            @PathVariable String id,
            @RequestParam(defaultValue = "map") String from,
            RedirectAttributes ra) {
        String result = slotService.toggleStatus(id);
        if ("ERROR".equals(result)) {
            ra.addFlashAttribute("errorMsg", "Could not update slot status.");
        } else {
            ra.addFlashAttribute("successMsg", "Slot status updated to: " + result);
        }
        return "manage".equals(from)
            ? "redirect:/slots/manage"
            : "redirect:/slots";
    }

    // DELETE — Remove slot
    @PostMapping("/delete/{id}")
    public String deleteSlot(@PathVariable String id, RedirectAttributes ra) {
        boolean result = slotService.deleteSlot(id);
        if (result) {
            ra.addFlashAttribute("successMsg", "Slot removed successfully.");
        } else {
            ra.addFlashAttribute("errorMsg", "Slot not found or deletion failed.");
        }
        return "redirect:/slots/manage";
    }

    // READ — Check-in redirect
    @GetMapping("/checkin/{id}")
    public String checkIn(@PathVariable String id, Model model) {
        ParkingSlot slot = slotService.findById(id);
        if (slot == null) return "redirect:/slots";
        if (slot.getStatus() != ParkingSlot.Status.AVAILABLE) return "redirect:/slots";
        return "redirect:/vehicle/select?slotId=" + id
            + "&slotNumber=" + slot.getSlotNumber()
            + "&slotType=" + slot.getSlotType();
    }
}
