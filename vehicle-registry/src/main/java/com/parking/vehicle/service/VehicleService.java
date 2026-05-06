package com.parking.vehicle.service;

import com.parking.vehicle.model.Vehicle;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

/**
 * VehicleService handles all CRUD operations for Vehicle Registry.
 * Data is persisted in a plain .txt file (pipe-separated format).
 *
 * OOP Concepts demonstrated:
 *  - Encapsulation: private fields + public methods
 *  - Single Responsibility: service handles only business logic & file I/O
 *
 * Author: De Silva M.A.G.G - IT25100132
 */
@Service
public class VehicleService {

    @Value("${vehicle.data.file}")
    private String dataFilePath;

    // ─── Helpers ─────────────────────────────────────────────────────────────

    /**
     * Returns the File object, creating it if it doesn't exist.
     */
    private File getDataFile() throws IOException {
        File file = new File(dataFilePath);
        // Create parent directories if needed
        if (file.getParentFile() != null) {
            file.getParentFile().mkdirs();
        }
        if (!file.exists()) {
            file.createNewFile();
        }
        return file;
    }

    /**
     * Reads all vehicles from the .txt file.
     */
    private List<Vehicle> readAllVehicles() throws IOException {
        List<Vehicle> vehicles = new ArrayList<>();
        File file = getDataFile();

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty()) {
                    Vehicle v = Vehicle.fromFileString(line);
                    if (v != null) vehicles.add(v);
                }
            }
        }
        return vehicles;
    }

    /**
     * Overwrites the .txt file with the given list of vehicles.
     */
    private void writeAllVehicles(List<Vehicle> vehicles) throws IOException {
        File file = getDataFile();
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, false))) {
            for (Vehicle v : vehicles) {
                writer.write(v.toFileString());
                writer.newLine();
            }
        }
    }

    // ─── CREATE ──────────────────────────────────────────────────────────────

    /**
     * Adds a new vehicle to the registry.
     * Returns false if the plate number already exists.
     */
    public boolean addVehicle(Vehicle vehicle) throws IOException {
        List<Vehicle> vehicles = readAllVehicles();

        // Check for duplicate plate number
        for (Vehicle v : vehicles) {
            if (v.getPlateNumber().equalsIgnoreCase(vehicle.getPlateNumber())) {
                return false; // Duplicate found
            }
        }

        vehicles.add(vehicle);
        writeAllVehicles(vehicles);
        return true;
    }

    // ─── READ ─────────────────────────────────────────────────────────────────

    /**
     * Returns all registered vehicles.
     */
    public List<Vehicle> getAllVehicles() throws IOException {
        return readAllVehicles();
    }

    /**
     * Searches for a vehicle by plate number (case-insensitive).
     */
    public Vehicle searchByPlate(String plateNumber) throws IOException {
        List<Vehicle> vehicles = readAllVehicles();
        for (Vehicle v : vehicles) {
            if (v.getPlateNumber().equalsIgnoreCase(plateNumber)) {
                return v;
            }
        }
        return null; // Not found
    }

    /**
     * Searches for all vehicles belonging to a given owner ID.
     */
    public List<Vehicle> searchByOwnerId(String ownerId) throws IOException {
        List<Vehicle> result = new ArrayList<>();
        for (Vehicle v : readAllVehicles()) {
            if (v.getOwnerId().equalsIgnoreCase(ownerId)) {
                result.add(v);
            }
        }
        return result;
    }

    // ─── UPDATE ──────────────────────────────────────────────────────────────

    /**
     * Updates details of a vehicle identified by plate number.
     * Returns false if vehicle not found.
     */
    public boolean updateVehicle(String plateNumber, Vehicle updatedVehicle) throws IOException {
        List<Vehicle> vehicles = readAllVehicles();
        boolean found = false;

        for (int i = 0; i < vehicles.size(); i++) {
            if (vehicles.get(i).getPlateNumber().equalsIgnoreCase(plateNumber)) {
                // Keep plate number, update other fields
                updatedVehicle.setPlateNumber(plateNumber);
                vehicles.set(i, updatedVehicle);
                found = true;
                break;
            }
        }

        if (found) {
            writeAllVehicles(vehicles);
        }
        return found;
    }

    // ─── DELETE ──────────────────────────────────────────────────────────────

    /**
     * Removes a vehicle from the registry by plate number.
     * Returns false if vehicle not found.
     */
    public boolean deleteVehicle(String plateNumber) throws IOException {
        List<Vehicle> vehicles = readAllVehicles();
        boolean removed = vehicles.removeIf(v -> v.getPlateNumber().equalsIgnoreCase(plateNumber));

        if (removed) {
            writeAllVehicles(vehicles);
        }
        return removed;
    }
}
