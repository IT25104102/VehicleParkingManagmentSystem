package com.smartparking.smartparkingsystem.util;

import com.smartparking.smartparkingsystem.model.ParkingSlot;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.stream.Collectors;

/**
 * FileHandler — all I/O for data/slots.txt
 * Developer: Naveed M.I.M | IT25101466
 * Module: Parking Slot Management
 */
@Component
public class FileHandler {

    @Value("${parking.data.file:data/slots.txt}")
    private String dataFilePath;

    // ── Ensure the file & parent directories exist ────────────────────────────

    private void ensureFileExists() throws IOException {
        Path path = Paths.get(dataFilePath);
        if (path.getParent() != null) {
            Files.createDirectories(path.getParent());
        }
        if (!Files.exists(path)) {
            Files.createFile(path);
        }
    }

    // ── READ ──────────────────────────────────────────────────────────────────

    public List<ParkingSlot> readAll() {
        List<ParkingSlot> slots = new ArrayList<>();
        try {
            ensureFileExists();
            List<String> lines = Files.readAllLines(Paths.get(dataFilePath));
            for (String line : lines) {
                line = line.trim();
                if (!line.isEmpty() && !line.startsWith("#")) {
                    ParkingSlot slot = ParkingSlot.fromFileString(line);
                    if (slot != null) slots.add(slot);
                }
            }
        } catch (IOException e) {
            System.err.println("[FileHandler] Error reading slots: " + e.getMessage());
        }
        return slots;
    }

    public Optional<ParkingSlot> findById(String id) {
        return readAll().stream()
                        .filter(s -> s.getId().equals(id))
                        .findFirst();
    }

    public Optional<ParkingSlot> findBySlotNumber(String slotNumber) {
        return readAll().stream()
                        .filter(s -> s.getSlotNumber().equalsIgnoreCase(slotNumber))
                        .findFirst();
    }

    // ── WRITE (overwrites full file) ──────────────────────────────────────────

    private void writeAll(List<ParkingSlot> slots) throws IOException {
        ensureFileExists();
        List<String> lines = slots.stream()
                                  .map(ParkingSlot::toFileString)
                                  .collect(Collectors.toList());
        Files.write(Paths.get(dataFilePath), lines,
                    StandardOpenOption.WRITE,
                    StandardOpenOption.TRUNCATE_EXISTING);
    }

    // ── CREATE ────────────────────────────────────────────────────────────────

    public boolean save(ParkingSlot slot) {
        try {
            List<ParkingSlot> slots = readAll();
            // Prevent duplicate slotNumber
            boolean exists = slots.stream()
                                  .anyMatch(s -> s.getSlotNumber()
                                                  .equalsIgnoreCase(slot.getSlotNumber()));
            if (exists) return false;
            slots.add(slot);
            writeAll(slots);
            return true;
        } catch (IOException e) {
            System.err.println("[FileHandler] Error saving slot: " + e.getMessage());
            return false;
        }
    }

    // ── UPDATE ────────────────────────────────────────────────────────────────

    public boolean update(ParkingSlot updated) {
        try {
            List<ParkingSlot> slots = readAll();
            boolean found = false;
            for (int i = 0; i < slots.size(); i++) {
                if (slots.get(i).getId().equals(updated.getId())) {
                    slots.set(i, updated);
                    found = true;
                    break;
                }
            }
            if (!found) return false;
            writeAll(slots);
            return true;
        } catch (IOException e) {
            System.err.println("[FileHandler] Error updating slot: " + e.getMessage());
            return false;
        }
    }

    // ── DELETE ────────────────────────────────────────────────────────────────

    public boolean delete(String id) {
        try {
            List<ParkingSlot> slots = readAll();
            boolean removed = slots.removeIf(s -> s.getId().equals(id));
            if (!removed) return false;
            writeAll(slots);
            return true;
        } catch (IOException e) {
            System.err.println("[FileHandler] Error deleting slot: " + e.getMessage());
            return false;
        }
    }

    // ── Utility ───────────────────────────────────────────────────────────────

    public String generateId() {
        return "SLT-" + System.currentTimeMillis();
    }

    public int countByStatus(ParkingSlot.Status status) {
        return (int) readAll().stream()
                              .filter(s -> s.getStatus() == status)
                              .count();
    }
}
