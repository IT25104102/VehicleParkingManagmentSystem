package com.smartparking.smartparkingsystem.service;

import com.smartparking.smartparkingsystem.model.ParkingSlot;
import com.smartparking.smartparkingsystem.util.FileUtil;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class ParkingSlotService {

    private static final String FILE = "data/slots.txt";
    private static final int MAX_DAYS = 7;

    // CREATE — Add new slot for a specific date
    public boolean addSlot(String slotNumber, String slotType) {
        return addSlotForDate(slotNumber, slotType,
                LocalDate.now().toString());
    }

    public boolean addSlotForDate(String slotNumber,
            String slotType, String date) {
        if (slotNumber == null || slotNumber.isEmpty()) return false;
        try {
            ParkingSlot slot = new ParkingSlot();
            slot.setId(FileUtil.generateId("SLT"));
            slot.setSlotNumber(slotNumber.toUpperCase().trim());
            slot.setStatus(ParkingSlot.Status.AVAILABLE);
            slot.setSlotType(ParkingSlot.SlotType.valueOf(
                    slotType.toUpperCase()));
            slot.setCreatedAt(new Date().toString());
            slot.setDate(date);
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

    // READ — Get slots for a specific date
    public List<ParkingSlot> getSlotsByDate(String date) {
        return getAllSlots().stream()
                .filter(s -> date.equals(s.getDate()))
                .collect(Collectors.toList());
    }

    // READ — Get available dates (today + 7 days that have slots)
    public List<String> getAvailableDates() {
        LocalDate today = LocalDate.now();
        LocalDate maxDate = today.plusDays(MAX_DAYS - 1);
        return getAllSlots().stream()
                .map(ParkingSlot::getDate)
                .filter(d -> d != null && !d.isEmpty())
                .filter(d -> {
                    try {
                        LocalDate date = LocalDate.parse(d);
                        return !date.isBefore(today) && !date.isAfter(maxDate);
                    } catch (Exception e) { return false; }
                })
                .distinct()
                .sorted()
                .collect(Collectors.toList());
    }

    // READ — Check if date is valid (within 7 days)
    public boolean isValidDate(String date) {
        try {
            LocalDate d = LocalDate.parse(date);
            LocalDate today = LocalDate.now();
            LocalDate maxDate = today.plusDays(MAX_DAYS - 1);
            return !d.isBefore(today) && !d.isAfter(maxDate);
        } catch (Exception e) {
            return false;
        }
    }

    // READ — Find by ID
    public ParkingSlot findById(String id) {
        for (ParkingSlot slot : getAllSlots()) {
            if (slot.getId() != null && slot.getId().equals(id)) return slot;
        }
        return null;
    }

    // READ — Count by status for a date
    public int countByStatus(ParkingSlot.Status status) {
        int count = 0;
        for (ParkingSlot slot : getAllSlots()) {
            if (slot.getStatus() == status) count++;
        }
        return count;
    }

    public int countByStatusAndDate(ParkingSlot.Status status, String date) {
        int count = 0;
        for (ParkingSlot slot : getSlotsByDate(date)) {
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
