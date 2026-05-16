package com.smartparking.smartparkingsystem.service;

import com.smartparking.smartparkingsystem.model.ParkingSlot;
import com.smartparking.smartparkingsystem.model.ParkingSlot.Status;
import com.smartparking.smartparkingsystem.model.ParkingSlot.SlotType;
import com.smartparking.smartparkingsystem.util.FileHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * ParkingSlotService — CRUD business logic
 * Developer: Naveed M.I.M | IT25101466
 * Module: Parking Slot Management
 */
@Service
public class ParkingSlotService {

    @Autowired
    private FileHandler fileHandler;

    // ── CREATE ────────────────────────────────────────────────────────────────

    /**
     * Adds a new parking slot.
     * @return "SUCCESS", "DUPLICATE", or "ERROR"
     */
    public String addSlot(String slotNumber, String slotType) {
        if (slotNumber == null || slotNumber.isBlank()) return "ERROR";

        SlotType type;
        try {
            type = SlotType.valueOf(slotType.toUpperCase());
        } catch (IllegalArgumentException e) {
            return "ERROR";
        }

        ParkingSlot slot = new ParkingSlot(
                fileHandler.generateId(),
                slotNumber.toUpperCase().trim(),
                Status.AVAILABLE,
                type
        );

        return fileHandler.save(slot) ? "SUCCESS" : "DUPLICATE";
    }

    // ── READ ──────────────────────────────────────────────────────────────────

    public List<ParkingSlot> getAllSlots() {
        return fileHandler.readAll();
    }

    public Optional<ParkingSlot> getSlotById(String id) {
        return fileHandler.findById(id);
    }

    public Optional<ParkingSlot> getSlotByNumber(String slotNumber) {
        return fileHandler.findBySlotNumber(slotNumber);
    }

    public int countAvailable() {
        return fileHandler.countByStatus(Status.AVAILABLE);
    }

    public int countOccupied() {
        return fileHandler.countByStatus(Status.OCCUPIED);
    }

    public int countPending() {
        return fileHandler.countByStatus(Status.PENDING);
    }

    public int countPreReserved() {
        return fileHandler.countByStatus(Status.PRE_RESERVED);
    }

    // ── UPDATE ────────────────────────────────────────────────────────────────

    /**
     * Toggles AVAILABLE ↔ OCCUPIED.
     * Returns the new status string, or "ERROR" / "NOT_FOUND".
     */
    public String toggleStatus(String id) {
        Optional<ParkingSlot> opt = fileHandler.findById(id);
        if (opt.isEmpty()) return "NOT_FOUND";

        ParkingSlot slot = opt.get();
        Status current = slot.getStatus();

        Status next = (current == Status.AVAILABLE) ? Status.OCCUPIED : Status.AVAILABLE;
        slot.setStatus(next);

        return fileHandler.update(slot) ? next.name() : "ERROR";
    }

    /**
     * Sets an explicit status on a slot (used by other modules, e.g. check-in).
     */
    public boolean setStatus(String id, Status status) {
        Optional<ParkingSlot> opt = fileHandler.findById(id);
        if (opt.isEmpty()) return false;
        ParkingSlot slot = opt.get();
        slot.setStatus(status);
        return fileHandler.update(slot);
    }

    // ── DELETE ────────────────────────────────────────────────────────────────

    /**
     * Removes a slot only if it is AVAILABLE (safety guard).
     * @return "SUCCESS", "NOT_FOUND", "IN_USE", or "ERROR"
     */
    public String deleteSlot(String id) {
        Optional<ParkingSlot> opt = fileHandler.findById(id);
        if (opt.isEmpty()) return "NOT_FOUND";

        ParkingSlot slot = opt.get();
        if (slot.getStatus() != Status.AVAILABLE) return "IN_USE";

        return fileHandler.delete(id) ? "SUCCESS" : "ERROR";
    }

    /**
     * Force-delete regardless of status (admin action).
     */
    public boolean forceDelete(String id) {
        return fileHandler.delete(id);
    }
}
