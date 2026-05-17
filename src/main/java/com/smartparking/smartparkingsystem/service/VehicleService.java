package com.smartparking.smartparkingsystem.service;

import com.smartparking.smartparkingsystem.model.Vehicle;
import com.smartparking.smartparkingsystem.util.FileUtil;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
public class VehicleService {

    private static final String FILE = "data/vehicles.txt";

    // CREATE — Add vehicle
    public void addVehicle(Vehicle vehicle) {
        vehicle.setVehicleId(FileUtil.generateId("VEH"));
        FileUtil.appendLine(FILE, vehicle.toFileString());
    }

    // READ — Get all vehicles
    public List<Vehicle> getAllVehicles() {
        List<Vehicle> list = new ArrayList<>();
        for (String line : FileUtil.readAll(FILE)) {
            if (line.trim().isEmpty()) continue;
            Vehicle v = Vehicle.fromFileString(line);
            if (v == null) continue;
            list.add(v);
        }
        return list;
    }

    // READ — Find by ID
    public Vehicle findById(String id) {
        for (Vehicle v : getAllVehicles()) {
            if (v.getVehicleId() != null && v.getVehicleId().equals(id)) return v;
        }
        return null;
    }

    // READ — Search
    public List<Vehicle> searchVehicle(String keyword) {
        if (keyword == null || keyword.trim().isEmpty())
            return getAllVehicles();
        String lower = keyword.toLowerCase().trim();
        List<Vehicle> results = new ArrayList<>();
        for (Vehicle v : getAllVehicles()) {
            if (v.getLicensePlate() != null && v.getLicensePlate().toLowerCase().contains(lower)
                || v.getOwnerName() != null && v.getOwnerName().toLowerCase().contains(lower)) {
                results.add(v);
            }
        }
        return results;
    }

    // UPDATE — Update vehicle
    public void updateVehicle(String id,
            String licensePlate, String ownerName,
            String vehicleType) {
        List<String> lines = FileUtil.readAll(FILE);
        List<String> updated = new ArrayList<>();
        for (String line : lines) {
            if (line.trim().isEmpty()) continue;
            Vehicle v = Vehicle.fromFileString(line);
            if (v == null) continue;
            if (v.getVehicleId().equals(id)) {
                v.setLicensePlate(licensePlate);
                v.setOwnerName(ownerName);
                v.setVehicleType(vehicleType);
                updated.add(v.toFileString());
            } else {
                updated.add(line);
            }
        }
        FileUtil.writeAll(FILE, updated);
    }

    // DELETE — Remove vehicle
    public void deleteVehicle(String vehicleId) {
        List<String> lines = FileUtil.readAll(FILE);
        List<String> updated = new ArrayList<>();
        for (String line : lines) {
            if (line.trim().isEmpty()) continue;
            Vehicle v = Vehicle.fromFileString(line);
            if (v == null) continue;
            if (!v.getVehicleId().equals(vehicleId))
                updated.add(line);
        }
        FileUtil.writeAll(FILE, updated);
    }
}
