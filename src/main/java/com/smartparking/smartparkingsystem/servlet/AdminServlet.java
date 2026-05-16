package com.smartparking.smartparkingsystem.servlet;

import com.smartparking.smartparkingsystem.model.Log;
import com.smartparking.smartparkingsystem.service.AdminService;
import com.smartparking.smartparkingsystem.service.AdminService.SystemReport;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminServlet {

    private AdminService adminService = new AdminService();

    // READ — Dashboard
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        SystemReport report = adminService.getSystemReport();
        model.addAttribute("report", report);
        return "admin/dashboard";
    }

    // READ — Reports
    @GetMapping("/reports")
    public String reports(Model model) {
        SystemReport report = adminService.getSystemReport();
        model.addAttribute("report", report);
        return "admin/reports";
    }

    // READ/UPDATE — Price page
    @GetMapping("/price")
    public String pricePage(Model model) {
        double currentPrice = adminService.getCurrentPrice();
        model.addAttribute("currentPrice", currentPrice);
        return "admin/price";
    }

    // CREATE — Generate daily summary
    @PostMapping("/generate")
    public String generate(HttpSession session) {
        Log generatedLog = adminService.generateDailySummary();
        if (generatedLog != null) {
            session.setAttribute("successMessage",
                "Daily summary generated for "
                + generatedLog.getDate()
                + " — Vehicles: "
                + generatedLog.getTotalVehicles()
                + ", Income: Rs."
                + String.format("%.2f",
                    generatedLog.getIncome()));
        } else {
            session.setAttribute("errorMessage",
                "Failed to generate daily summary.");
        }
        return "redirect:/admin/dashboard";
    }

    // UPDATE — Price per hour
    @PostMapping("/price")
    public String updatePrice(
            @RequestParam String price,
            HttpSession session) {
        try {
            double newPrice = Double.parseDouble(price);
            boolean updated =
                adminService.updatePricePerHour(newPrice);
            if (updated) {
                session.setAttribute("successMessage",
                    "Price updated to Rs."
                    + String.format("%.2f", newPrice)
                    + "/hour.");
            } else {
                session.setAttribute("errorMessage",
                    "Failed to update price. Must be greater than 0.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage",
                "Invalid price entered.");
        }
        return "redirect:/admin/price";
    }

    // DELETE — Clean old logs
    @PostMapping("/clean")
    public String cleanLogs(HttpSession session) {
        int deleted = adminService.deleteOldLogs();
        if (deleted >= 0) {
            session.setAttribute("successMessage",
                "Cleanup complete. Removed "
                + deleted + " old log entries.");
        } else {
            session.setAttribute("errorMessage",
                "Log cleanup failed.");
        }
        return "redirect:/admin/dashboard";
    }
}
