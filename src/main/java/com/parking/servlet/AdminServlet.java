package com.parking.servlet;

import com.parking.model.Log;
import com.parking.service.AdminService;
import com.parking.service.AdminService.SystemReport;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
    private AdminService adminService;

    @Override
    public void init() throws ServletException {
        adminService = new AdminService();
    }

    // ─── GET Requests ────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String path = getPath(req);

        switch (path) {
            case "/dashboard":
            case "/":
            case "":
                SystemReport report = adminService.getSystemReport();
                req.setAttribute("report", report);
                req.getRequestDispatcher("/views/admin/dashboard.jsp")
                        .forward(req, res);
                break;

            case "/reports":
                SystemReport fullReport = adminService.getSystemReport();
                req.setAttribute("report", fullReport);
                req.getRequestDispatcher("/views/admin/reports.jsp")
                        .forward(req, res);
                break;

            case "/price":
                double currentPrice = adminService.getCurrentPrice();
                req.setAttribute("currentPrice", currentPrice);
                req.getRequestDispatcher("/views/admin/price.jsp")
                        .forward(req, res);
                break;

            default:
                res.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    // ─── POST Requests ───────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String path = getPath(req);

        switch (path) {

            // CREATE: Generate Daily Summary
            case "/generate":
                Log generatedLog = adminService.generateDailySummary();
                if (generatedLog != null) {
                    req.getSession().setAttribute("successMessage",
                            "Daily summary generated for " + generatedLog.getDate()
                                    + " — Vehicles: " + generatedLog.getTotalVehicles()
                                    + ", Income: Rs." +
                                    String.format("%.2f", generatedLog.getIncome()));
                } else {
                    req.getSession().setAttribute("errorMessage",
                            "Failed to generate daily summary.");
                }
                res.sendRedirect(req.getContextPath() + "/admin/dashboard");
                break;

            // UPDATE: Modify Price Per Hour
            case "/price":
                String priceParam = req.getParameter("price");
                try {
                    double newPrice = Double.parseDouble(priceParam);
                    boolean updated = adminService.updatePricePerHour(newPrice);
                    if (updated) {
                        req.getSession().setAttribute("successMessage",
                                "Price updated to Rs." +
                                        String.format("%.2f", newPrice) + "/hour.");
                    } else {
                        req.getSession().setAttribute("errorMessage",
                                "Failed to update price. Must be greater than 0.");
                    }
                } catch (NumberFormatException e) {
                    req.getSession().setAttribute("errorMessage",
                            "Invalid price entered.");
                }
                res.sendRedirect(req.getContextPath() + "/admin/price");
                break;

            // DELETE: Clean Old Logs
            case "/clean":
                int deleted = adminService.deleteOldLogs();
                if (deleted >= 0) {
                    req.getSession().setAttribute("successMessage",
                            "Cleanup complete. Removed " + deleted +
                                    " old log entries.");
                } else {
                    req.getSession().setAttribute("errorMessage",
                            "Log cleanup failed.");
                }
                res.sendRedirect(req.getContextPath() + "/admin/dashboard");
                break;

            default:
                res.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    // ─── Helper ──────────────────────────────────────
    private String getPath(HttpServletRequest req) {
        String pathInfo = req.getPathInfo();
        return (pathInfo == null) ? "" : pathInfo;
    }
}
