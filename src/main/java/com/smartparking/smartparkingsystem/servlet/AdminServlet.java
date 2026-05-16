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
                + ", Inc
