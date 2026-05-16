package com.smartparking.smartparkingsystem.service;

import com.smartparking.smartparkingsystem.model.Vehicle;
import com.smartparking.smartparkingsystem.util.FileUtil;

import java.util.ArrayList;
import java.util.List;

public class VehicleService {

    private static final String FILE_PATH = "D:/Y1 S2/OOP/Vehicle project/SmartParkingSystem/data/vehicles.txt";

    // ── CREATE ──────────────────────────────────────
    public void addVehicle(Vehicle vehicle) {
        vehicle.setVehicleId(generateId());
        FileUtil.appendLine(FILE_PATH, vehicle.toFileString());
    }

    // ── READ ALL ─────────────────────────────────────
    public List<Vehicle> getAllVehicles() {
        List<String> lines = FileUtil.readLines(FILE_PATH);
        List<Vehicle> vehicles = new ArrayList<>();
        for (String line : lines) {
            vehicles.add(Vehicle.fromFileString(line));
        }
        return vehicles;
    }

    // ── READ ONE ─────────────────────────────────────
    public Vehicle getVehicleById(String vehicleId) {
        for (Vehicle v : getAllVehicles()) {
            if (v.getVehicleId().equals(vehicleId)) {
                return v;
            }
        }
        return null;
    }

    // ── SEARCH ───────────────────────────────────────
    public List<Vehicle> searchVehicles(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllVehicles();
        }
        String lower = keyword.toLowerCase().trim();
        List<Vehicle> results = new ArrayList<>();
        for (Vehicle v : getAllVehicles()) {
            if (v.getLicensePlate().toLowerCase().contains(lower)
                    || v.getOwnerName().toLowerCase().contains(lower)) {
                results.add(v);
            }
        }
        return results;
    }

    // ── UPDATE ───────────────────────────────────────
    public void updateVehicle(Vehicle updated) {
        List<String> lines = FileUtil.readLines(FILE_PATH);
        List<String> newLines = new ArrayList<>();
        for (String line : lines) {
            Vehicle v = Vehicle.fromFileString(line);
            if (v.getVehicleId().equals(updated.getVehicleId())) {
                newLines.add(updated.toFileString());
            } else {
                newLines.add(line);
            }
        }
        FileUtil.writeLines(FILE_PATH, newLines);
    }

    // ── DELETE ───────────────────────────────────────
    public void deleteVehicle(String vehicleId) {
        List<String> lines = FileUtil.readLines(FILE_PATH);
        List<String> newLines = new ArrayList<>();
        for (String line : lines) {
            Vehicle v = Vehicle.fromFileString(line);
            if (!v.getVehicleId().equals(vehicleId)) {
                newLines.add(line);
            }
        }
        FileUtil.writeLines(FILE_PATH, newLines);
    }

    // ── GENERATE ID ──────────────────────────────────
    private String generateId() {
        int next = getAllVehicles().size() + 1;
        return String.format("V%03d", next);
    }
}