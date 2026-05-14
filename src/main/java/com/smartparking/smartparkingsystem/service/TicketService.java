package com.smartparking.smartparkingsystem.service;

import com.smartparking.smartparkingsystem.model.Ticket;
import com.smartparking.smartparkingsystem.util.FileHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class TicketService {

    @Autowired
    private FileHandler fileHandler;

    // ── CREATE — Generate new ticket ──────────────────────────
    public Ticket generateTicket(String vehicleId, String slotId, String vehicleNumber) {
        Ticket ticket = new Ticket();
        ticket.setId("TKT-" + System.currentTimeMillis());
        ticket.setVehicleId(vehicleId);
        ticket.setSlotId(slotId);
        ticket.setVehicleNumber(vehicleNumber.toUpperCase());
        ticket.setCheckInTime(LocalDateTime.now());
        ticket.setStatus(Ticket.STATUS_ACTIVE);
        ticket.setCreatedAt(LocalDateTime.now());

        fileHandler.appendTicket(ticket);
        return ticket;
    }

    // ── READ — Get all tickets ────────────────────────────────
    public List<Ticket> getAllTickets() {
        return fileHandler.readAllTickets();
    }

    // ── READ — Get only ACTIVE tickets ────────────────────────
    public List<Ticket> getActiveTickets() {
        return fileHandler.readAllTickets().stream()
                .filter(t -> Ticket.STATUS_ACTIVE.equals(t.getStatus()))
                .collect(Collectors.toList());
    }

    // ── READ — Get ticket by ID ───────────────────────────────
    public Optional<Ticket> getTicketById(String id) {
        return fileHandler.readAllTickets().stream()
                .filter(t -> t.getId().equals(id))
                .findFirst();
    }

    // ── UPDATE — Reassign parking slot ────────────────────────
    public boolean updateTicketSlot(String ticketId, String newSlotId) {
        List<Ticket> tickets = fileHandler.readAllTickets();
        boolean found = false;

        for (Ticket t : tickets) {
            if (t.getId().equals(ticketId)
                    && Ticket.STATUS_ACTIVE.equals(t.getStatus())) {
                t.setSlotId(newSlotId);
                found = true;
                break;
            }
        }

        if (found) fileHandler.writeAllTickets(tickets);
        return found;
    }

    // ── DELETE — Void a ticket ────────────────────────────────
    public boolean voidTicket(String ticketId) {
        List<Ticket> tickets = fileHandler.readAllTickets();
        boolean found = false;

        for (Ticket t : tickets) {
            if (t.getId().equals(ticketId)
                    && Ticket.STATUS_ACTIVE.equals(t.getStatus())) {
                t.setStatus(Ticket.STATUS_VOIDED);
                t.setCheckOutTime(LocalDateTime.now());
                found = true;
                break;
            }
        }

        if (found) fileHandler.writeAllTickets(tickets);
        return found;
    }
}
