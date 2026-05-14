package com.parking.model;

/**
 * Log.java — Data model representing a single daily summary log entry.
 * Format: "YYYY-MM-DD | Total Vehicles: X | Income: Rs.Y | Available Slots: Z"
 */

public class Log {
    private String date;           // e.g. "2026-04-28"
    private int totalVehicles;     // total vehicles parked that day
    private double income;         // total income collected (Rs.)
    private int availableSlots;    // parking slots available at time of log

    // ─── Constructors ────────────────────────────────────────────────────────

    public Log() {}

    public Log(String date, int totalVehicles, double income, int availableSlots) {
        this.date           = date;
        this.totalVehicles  = totalVehicles;
        this.income         = income;
        this.availableSlots = availableSlots;
    }

    // ─── Parse from log line ─────────────────────────────────────────────────

    /**
     * Parses a log line from logs.txt into a Log object.
     * Expected format: "2026-04-28 | Total Vehicles: 25 | Income: Rs.3750.0 | Available Slots: 10"
     *
     * @param line a single line from logs.txt
     * @return a Log object, or null if the line is malformed
     */
    public static Log fromLine(String line) {
        if (line == null || line.trim().isEmpty()) return null;

        try {
            String[] parts = line.split("\\|");
            if (parts.length != 4) return null;

            String date         = parts[0].trim();
            int totalVehicles   = Integer.parseInt(parts[1].replace("Total Vehicles:", "").trim());
            double income       = Double.parseDouble(parts[2].replace("Income: Rs.", "").trim());
            int availableSlots  = Integer.parseInt(parts[3].replace("Available Slots:", "").trim());

            return new Log(date, totalVehicles, income, availableSlots);
        } catch (Exception e) {
            System.err.println("[Log] Failed to parse line: " + line);
            return null;
        }
    }

    // ─── Serialize to log line ───────────────────────────────────────────────

    /**
     * Converts this Log object to the standard log file format.
     */
    @Override
    public String toString() {
        return date
                + " | Total Vehicles: " + totalVehicles
                + " | Income: Rs." + String.format("%.1f", income)
                + " | Available Slots: " + availableSlots;
    }

    // ─── Getters & Setters ───────────────────────────────────────────────────

    public String getDate()                    { return date; }
    public void   setDate(String date)         { this.date = date; }

    public int    getTotalVehicles()           { return totalVehicles; }
    public void   setTotalVehicles(int v)      { this.totalVehicles = v; }

    public double getIncome()                  { return income; }
    public void   setIncome(double income)     { this.income = income; }

    public int    getAvailableSlots()          { return availableSlots; }
    public void   setAvailableSlots(int slots) { this.availableSlots = slots; }
}
