package com.smartparking.smartparkingsystem.service;

import com.smartparking.smartparkingsystem.model.Log;
import com.smartparking.smartparkingsystem.util.FileUtil;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public class AdminService {

    private static final String BASE          = "data/";
    private static final String LOGS_FILE     = BASE + "logs.txt";
    private static final String CONFIG_FILE   = BASE + "config.txt";
    private static final String USERS_FILE    = BASE + "users.txt";
    private static final String VEHICLES_FILE = BASE + "vehicles.txt";
    private static final String SLOTS_FILE    = BASE + "slots.txt";
    private static final String TICKETS_FILE  = BASE + "tickets.txt";
    private static final String PAYMENTS_FILE = BASE + "payments.txt";

    private static final DateTimeFormatter DATE_FMT =
            DateTimeFormatter.ofPattern("yyyy-MM-dd");

    // Default rates
    private static final double DEFAULT_BIKE          = 200.0;
    private static final double DEFAULT_THREE_WHEELER = 250.0;
    private static final double DEFAULT_CAR           = 350.0;
    private static final double DEFAULT_VAN           = 550.0;
    private static final double DEFAULT_VIP           = 800.0;

    // ═══════════════════════════════════════════════════
    // 1. CREATE — Generate Daily Summary
    // ═══════════════════════════════════════════════════
    public Log generateDailySummary() {
        try {
            String today = LocalDate.now().format(DATE_FMT);
            List<String> ticketLines  = FileUtil.readAll(TICKETS_FILE);
            int totalVehicles         = countNonEmpty(ticketLines);
            List<String> paymentLines = FileUtil.readAll(PAYMENTS_FILE);
            double totalIncome        = sumIncome(paymentLines);
            List<String> slotLines    = FileUtil.readAll(SLOTS_FILE);
            int availableSlots        = countAvailableSlots(slotLines);
            Log log = new Log(today, totalVehicles, totalIncome, availableSlots);
            FileUtil.appendLine(LOGS_FILE, log.toString());
            return log;
        } catch (Exception e) {
            System.err.println("[AdminService] Error: " + e.getMessage());
            return null;
        }
    }

    // ═══════════════════════════════════════════════════
    // 2. READ — Get System-Wide Report
    // ═══════════════════════════════════════════════════
    public SystemReport getSystemReport() {
        SystemReport report = new SystemReport();
        List<String> users    = FileUtil.readAll(USERS_FILE);
        List<String> vehicles = FileUtil.readAll(VEHICLES_FILE);
        List<String> slots    = FileUtil.readAll(SLOTS_FILE);
        List<String> tickets  = FileUtil.readAll(TICKETS_FILE);
        List<String> payments = FileUtil.readAll(PAYMENTS_FILE);
        List<String> logs     = FileUtil.readAll(LOGS_FILE);

        report.setTotalUsers(countNonEmpty(users));
        report.setTotalVehicles(countNonEmpty(vehicles));
        report.setTotalSlots(countNonEmpty(slots));
        report.setAvailableSlots(countAvailableSlots(slots));
        report.setOccupiedSlots(countOccupiedSlots(slots));
        report.setActiveTickets(countNonEmpty(tickets));
        report.setTotalPayments(countNonEmpty(payments));
        report.setTotalIncome(sumIncome(payments));
        report.setTotalLogs(countNonEmpty(logs));

        report.setUserLines(users);
        report.setVehicleLines(vehicles);
        report.setSlotLines(slots);
        report.setTicketLines(tickets);
        report.setPaymentLines(payments);
        report.setLogLines(logs);
        report.setCurrentPrice(getCurrentPrice());

        return report;
    }

    // ═══════════════════════════════════════════════════
    // 3. UPDATE — Get rate by vehicle type
    // ═══════════════════════════════════════════════════
    public double getRateByType(String type) {
        try {
            List<String> lines = FileUtil.readAll(CONFIG_FILE);
            String key = type.toLowerCase() + "_rate=";
            for (String line : lines) {
                if (line.toLowerCase().startsWith(key)) {
                    return Double.parseDouble(
                        line.substring(key.length()).trim());
                }
            }
        } catch (Exception e) {
            System.err.println("[AdminService] getRateByType error: " + e.getMessage());
        }
        // Return defaults if not found
        switch (type.toUpperCase()) {
            case "BIKE":          return DEFAULT_BIKE;
            case "THREE_WHEELER": return DEFAULT_THREE_WHEELER;
            case "CAR":           return DEFAULT_CAR;
            case "VAN":           return DEFAULT_VAN;
            case "VIP":           return DEFAULT_VIP;
            default:              return DEFAULT_CAR;
        }
    }

    // ═══════════════════════════════════════════════════
    // 4. UPDATE — Save rate by vehicle type
    // ═══════════════════════════════════════════════════
    public boolean updateRateByType(String type, double newRate) {
        if (newRate <= 0) return false;
        try {
            List<String> lines = FileUtil.readAll(CONFIG_FILE);
            List<String> updated = new ArrayList<>();
            String key = type.toLowerCase() + "_rate=";
            boolean found = false;
            for (String line : lines) {
                if (line.toLowerCase().startsWith(key)) {
                    updated.add(key + newRate);
                    found = true;
                } else {
                    updated.add(line);
                }
            }
            if (!found) {
                updated.add(key + newRate);
            }
            FileUtil.writeAll(CONFIG_FILE, updated);
            return true;
        } catch (Exception e) {
            System.err.println("[AdminService] updateRateByType error: " + e.getMessage());
            return false;
        }
    }

    // ═══════════════════════════════════════════════════
    // 5. UPDATE — Modify single Price Per Hour (legacy)
    // ═══════════════════════════════════════════════════
    public boolean updatePricePerHour(double newPrice) {
        if (newPrice <= 0) return false;
        try {
            List<String> lines = FileUtil.readAll(CONFIG_FILE);
            List<String> updated = new ArrayList<>();
            boolean found = false;
            for (String line : lines) {
                if (line.startsWith("price=")) {
                    updated.add("price=" + newPrice);
                    found = true;
                } else {
                    updated.add(line);
                }
            }
            if (!found) updated.add("price=" + newPrice);
            FileUtil.writeAll(CONFIG_FILE, updated);
            return true;
        } catch (Exception e) {
            System.err.println("[AdminService] Error: " + e.getMessage());
            return false;
        }
    }

    public double getCurrentPrice() {
        try {
            List<String> lines = FileUtil.readAll(CONFIG_FILE);
            for (String line : lines) {
                if (line.startsWith("price=")) {
                    return Double.parseDouble(
                            line.replace("price=", "").trim());
                }
            }
        } catch (Exception e) {
            System.err.println("[AdminService] Using default price.");
        }
        return 150.0;
    }

    // ═══════════════════════════════════════════════════
    // 6. DELETE — Remove Logs Older Than 30 Days
    // ═══════════════════════════════════════════════════
    public int deleteOldLogs() {
        try {
            List<String> allLines  = FileUtil.readAll(LOGS_FILE);
            List<String> keepLines = new ArrayList<>();
            LocalDate cutoff = LocalDate.now().minus(30, ChronoUnit.DAYS);
            int deleted = 0;
            for (String line : allLines) {
                if (line.trim().isEmpty()) continue;
                Log log = Log.fromLine(line);
                if (log == null) { keepLines.add(line); continue; }
                try {
                    LocalDate logDate = LocalDate.parse(log.getDate(), DATE_FMT);
                    if (!logDate.isBefore(cutoff)) {
                        keepLines.add(line);
                    } else {
                        deleted++;
                    }
                } catch (DateTimeParseException e) {
                    keepLines.add(line);
                }
            }
            FileUtil.writeAll(LOGS_FILE, keepLines);
            return deleted;
        } catch (Exception e) {
            System.err.println("[AdminService] Error: " + e.getMessage());
            return -1;
        }
    }

    // ═══════════════════════════════════════════════════
    // Helper Methods
    // ═══════════════════════════════════════════════════
    private int countNonEmpty(List<String> lines) {
        int count = 0;
        for (String line : lines)
            if (line != null && !line.trim().isEmpty()) count++;
        return count;
    }

    private double sumIncome(List<String> paymentLines) {
        double total = 0;
        for (String line : paymentLines) {
            if (line == null || line.trim().isEmpty()) continue;
            try {
                String[] parts = line.split("\\|");
                if (parts.length >= 3) {
                    total += Double.parseDouble(
                            parts[2].trim().replace("Rs.", "").trim());
                }
            } catch (Exception ignored) {}
        }
        return total;
    }

    private int countAvailableSlots(List<String> slotLines) {
        int count = 0;
        for (String line : slotLines)
            if (line != null && line.toLowerCase().contains("available")) count++;
        return count;
    }

    private int countOccupiedSlots(List<String> slotLines) {
        int count = 0;
        for (String line : slotLines)
            if (line != null && line.toLowerCase().contains("occupied")) count++;
        return count;
    }

    // ═══════════════════════════════════════════════════
    // SystemReport DTO
    // ═══════════════════════════════════════════════════
    public static class SystemReport {
        private int totalUsers, totalVehicles, totalSlots;
        private int availableSlots, occupiedSlots;
        private int activeTickets, totalPayments, totalLogs;
        private double totalIncome, currentPrice;
        private List<String> userLines    = new ArrayList<>();
        private List<String> vehicleLines = new ArrayList<>();
        private List<String> slotLines    = new ArrayList<>();
        private List<String> ticketLines  = new ArrayList<>();
        private List<String> paymentLines = new ArrayList<>();
        private List<String> logLines     = new ArrayList<>();

        public int    getTotalUsers()                       { return totalUsers; }
        public void   setTotalUsers(int v)                  { this.totalUsers = v; }
        public int    getTotalVehicles()                    { return totalVehicles; }
        public void   setTotalVehicles(int v)               { this.totalVehicles = v; }
        public int    getTotalSlots()                       { return totalSlots; }
        public void   setTotalSlots(int v)                  { this.totalSlots = v; }
        public int    getAvailableSlots()                   { return availableSlots; }
        public void   setAvailableSlots(int v)              { this.availableSlots = v; }
        public int    getOccupiedSlots()                    { return occupiedSlots; }
        public void   setOccupiedSlots(int v)               { this.occupiedSlots = v; }
        public int    getActiveTickets()                    { return activeTickets; }
        public void   setActiveTickets(int v)               { this.activeTickets = v; }
        public int    getTotalPayments()                    { return totalPayments; }
        public void   setTotalPayments(int v)               { this.totalPayments = v; }
        public double getTotalIncome()                      { return totalIncome; }
        public void   setTotalIncome(double v)              { this.totalIncome = v; }
        public int    getTotalLogs()                        { return totalLogs; }
        public void   setTotalLogs(int v)                   { this.totalLogs = v; }
        public double getCurrentPrice()                     { return currentPrice; }
        public void   setCurrentPrice(double v)             { this.currentPrice = v; }
        public List<String> getUserLines()                  { return userLines; }
        public void         setUserLines(List<String> l)    { this.userLines = l; }
        public List<String> getVehicleLines()               { return vehicleLines; }
        public void         setVehicleLines(List<String> l) { this.vehicleLines = l; }
        public List<String> getSlotLines()                  { return slotLines; }
        public void         setSlotLines(List<String> l)    { this.slotLines = l; }
        public List<String> getTicketLines()                { return ticketLines; }
        public void         setTicketLines(List<String> l)  { this.ticketLines = l; }
        public List<String> getPaymentLines()               { return paymentLines; }
        public void         setPaymentLines(List<String> l) { this.paymentLines = l; }
        public List<String> getLogLines()                   { return logLines; }
        public void         setLogLines(List<String> l)     { this.logLines = l; }
    }
}
