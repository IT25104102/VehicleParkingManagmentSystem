package com.smartparking.smartparkingsystem.service;

import com.smartparking.smartparkingsystem.model.Ticket;
import com.smartparking.smartparkingsystem.util.FileUtil;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class TicketService {

    private static final String FILE = "data/tickets.txt";

    // CREATE — Generate new ticket
    public Ticket generateTicket(String vehicleId,
            String slotId, String vehicleNumber) {
        Ticket ticket = new Ticket();
        ticket.setId(FileUtil.generateId("TKT"));
        ticket.setVehicleId(vehicleId);
        ticket.setSlotId(slotId);
        ticket.setVehicleNumber(vehicleNumber.toUpperCase());
        ticket.setCheckInTime(LocalDateTime.now());
        ticket.setStatus("ACTIVE");
        ticket.setCreatedAt(LocalDateTime.now());
        FileUtil.appendLine(FILE, ticket.toFileString());
        return ticket;
    }

    // READ — Get all tickets
    public List<Ticket> getAllTickets() {
        List<Ticket> list = new ArrayList<>();
        for (String line : FileUtil.readAll(FILE)) {
            if (line.trim().isEmpty()) continue;
            try {
                // ✅ Use static method correctly
                Ticket t = Ticket.fromFileString(line);
                if (t != null) list.add(t);
            } catch (Exception e) {
                System.err.println("Error reading ticket: " + e.getMessage());
            }
        }
        return list;
    }

    // READ — Get active tickets
    public List<Ticket> getActiveTickets() {
        return getAllTickets().stream()
            .filter(t -> "ACTIVE".equals(t.getStatus()))
            .collect(Collectors.toList());
    }

    // READ — Find by ID
    public Ticket findById(String id) {
        for (Ticket t : getAllTickets()) {
            if (t.getId() != null && t.getId().equals(id)) return t;
        }
        return null;
    }

    // UPDATE — Reassign slot
    public boolean updateTicketSlot(String ticketId, String newSlotId) {
        List<String> lines = FileUtil.readAll(FILE);
        List<String> updated = new ArrayList<>();
        boolean found = false;
        for (String line : lines) {
            if (line.trim().isEmpty()) continue;
            try {
                Ticket t = Ticket.fromFileString(line);
                if (t != null && t.getId().equals(ticketId)
                        && "ACTIVE".equals(t.getStatus())) {
                    t.setSlotId(newSlotId);
                    updated.add(t.toFileString());
                    found = true;
                } else {
                    updated.add(line);
                }
            } catch (Exception e) {
                updated.add(line);
            }
        }
        if (found) FileUtil.writeAll(FILE, updated);
        return found;
    }

    // DELETE — Void ticket
    public boolean voidTicket(String ticketId) {
        List<String> lines = FileUtil.readAll(FILE);
        List<String> updated = new ArrayList<>();
        boolean found = false;
        for (String line : lines) {
            if (line.trim().isEmpty()) continue;
            try {
                Ticket t = Ticket.fromFileString(line);
                if (t != null && t.getId().equals(ticketId)
                        && "ACTIVE".equals(t.getStatus())) {
                    t.setStatus("VOIDED");
                    t.setCheckOutTime(LocalDateTime.now());
                    updated.add(t.toFileString());
                    found = true;
                } else {
                    updated.add(line);
                }
            } catch (Exception e) {
                updated.add(line);
            }
        }
        if (found) FileUtil.writeAll(FILE, updated);
        return found;
    }
}
