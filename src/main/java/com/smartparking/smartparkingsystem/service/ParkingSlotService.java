package com.smartparking.smartparkingsystem.service;

import com.smartparking.smartparkingsystem.model.ParkingSlot;
import com.smartparking.smartparkingsystem.util.FileUtil;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
public class ParkingSlotService {

    private static final String FILE = "data/slots.txt";

    // CREATE — Add new slot
    public boolean addSlot(String slotNumber, String slotType) {
        if (slotNumber == null || slotNumber.isEmpty()) return false;
        try {
            ParkingSlot slot = new ParkingSlot();
            slot.setId(FileUtil.generateId("SLT"));
            slot.setSlotNumber(slotNumber.toUpperCase().trim());
            slot.setStatus(ParkingSlot.Status.AVAILABLE);
            slot.setSlotType(ParkingSlot.SlotType.valueOf(slotType.toUpperCase()));
            slot.setCreatedAt(new Date().toString());
            FileUtil.appendLine(FILE, slot.toFileString());
            return true;
        } catch (Exception e) {
            System.err.println("Error adding slot: " + e.getMessage());
            return false;
        }
    }

    // READ — Get all slots
    public List<ParkingSlot> getAllSlots() {
        List<ParkingSlot> list = new ArrayList<>();
        for (String line : FileUtil.readAll(FILE)) {
            if (line.trim().isEmpty()) continue;
            try {
                ParkingSlot slot = ParkingSlot.fromFileString(line);
                if (slot == null) continue;
                list.add(slot);
            } catch (Exception e) {
                System.err.println("Error reading slot: " + e.getMessage());
            }
        }
        return list;
    }

    // READ — Find by ID
    public ParkingSlot findById(String id) {
        for (ParkingSlot slot : getAllSlots()) {
            if (slot.getId() != null && slot.getId().equals(id)) return slot;
        }
        return null;
    }

    // READ — Count by status
    public int countByStatus(ParkingSlot.Status status) {
        int count = 0;
        for (ParkingSlot slot : getAllSlots()) {
            if (slot.getStatus() == status) count++;
        }
        return count;
    }

    // UPDATE — Toggle status
    public String toggleStatus(String id) {
        List<String> lines = FileUtil.readAll(FILE);
        List<String> updated = new ArrayList<>();
        String newStatus = "ERROR";
        for (String line : lines) {
            if (line.trim().isEmpty()) continue;
            try {
                ParkingSlot slot = ParkingSlot.fromFileString(line);
                if (slot == null) continue;
                if (slot.getId().equals(id)) {
                    ParkingSlot.Status next =
                        slot.getStatus() == ParkingSlot.Status.AVAILABLE
                        ? ParkingSlot.Status.OCCUPIED
                        : ParkingSlot.Status.AVAILABLE;
                    slot.setStatus(next);
                    newStatus = next.name();
                    updated.add(slot.toFileString());
                } else {
                    updated.add(line);
                }
            } catch (Exception e) {
                updated.add(line);
            }
        }
        FileUtil.writeAll(FILE, updated);
        return newStatus;
    }

    // DELETE — Remove slot
    public boolean deleteSlot(String id) {
        List<String> lines = FileUtil.readAll(FILE);
        List<String> updated = new ArrayList<>();
        boolean found = false;
        for (String line : lines) {
            if (line.trim().isEmpty()) continue;
            try {
                ParkingSlot slot = ParkingSlot.fromFileString(line);
                if (slot == null) continue;
                if (!slot.getId().equals(id)) {
                    updated.add(line);
                } else {
                    found = true;
                }
            } catch (Exception e) {
                updated.add(line);
            }
        }
        if (found) FileUtil.writeAll(FILE, updated);
        return found;
    }
}
