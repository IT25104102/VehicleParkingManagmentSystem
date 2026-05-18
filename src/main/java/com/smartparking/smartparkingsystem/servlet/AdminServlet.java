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

    // READ — Price page
    @GetMapping("/price")
    public String pricePage(Model model) {
        model.addAttribute("bikeRate",         adminService.getRateByType("BIKE"));
        model.addAttribute("threeWheelerRate", adminService.getRateByType("THREE_WHEELER"));
        model.addAttribute("carRate",          adminService.getRateByType("CAR"));
        model.addAttribute("vanRate",          adminService.getRateByType("VAN"));
        model.addAttribute("vipRate",          adminService.getRateByType("VIP"));
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
                + String.format("%.2f", generatedLog.getIncome()));
        } else {
            session.setAttribute("errorMessage", "Failed to generate daily summary.");
        }
        return "redirect:/admin/dashboard";
    }

    // UPDATE — Save all rates
    @PostMapping("/price")
    public String updatePrice(
            @RequestParam(required = false) String bikerate,
            @RequestParam(required = false) String threewheelerrate,
            @RequestParam(required = false) String carrate,
            @RequestParam(required = false) String vanrate,
            @RequestParam(required = false) String viprate,
            HttpSession session) {
        try {
            boolean updated = true;
            if (bikerate != null)          updated &= adminService.updateRateByType("BIKE",          Double.parseDouble(bikerate));
            if (threewheelerrate != null)  updated &= adminService.updateRateByType("THREE_WHEELER",  Double.parseDouble(threewheelerrate));
            if (carrate != null)           updated &= adminService.updateRateByType("CAR",            Double.parseDouble(carrate));
            if (vanrate != null)           updated &= adminService.updateRateByType("VAN",            Double.parseDouble(vanrate));
            if (viprate != null)           updated &= adminService.updateRateByType("VIP",            Double.parseDouble(viprate));

            if (updated) {
                session.setAttribute("successMessage", "All rates updated successfully!");
            } else {
                session.setAttribute("errorMessage", "Some rates failed to update.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid price entered.");
        }
        return "redirect:/admin/price";
    }

    // DELETE — Clean old logs
    @PostMapping("/clean")
    public String cleanLogs(HttpSession session) {
        int deleted = adminService.deleteOldLogs();
        if (deleted >= 0) {
            session.setAttribute("successMessage",
                "Cleanup complete. Removed " + deleted + " old log entries.");
        } else {
            session.setAttribute("errorMessage", "Log cleanup failed.");
        }
        return "redirect:/admin/dashboard";
    }
}
