package com.smartparking.smartparkingsystem.servlet;

import com.smartparking.smartparkingsystem.model.ParkingSlot;
import com.smartparking.smartparkingsystem.service.ParkingSlotService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.List;

@Controller
@RequestMapping("/slots")
public class ParkingSlotServlet {

    @Autowired
    private ParkingSlotService slotService;

    // READ — Slot Map Dashboard
    @GetMapping
    public String slotMap(Model model) {
        List<ParkingSlot> slots = slotService.getAllSlots();
        model.addAttribute("slots", slots);
        model.addAttribute("totalSlots", slots.size());
        model.addAttribute("available",
            slotService.countByStatus(
                Parkin
