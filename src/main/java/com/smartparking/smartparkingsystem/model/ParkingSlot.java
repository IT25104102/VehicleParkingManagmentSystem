package com.smartparking.smartparkingsystem.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class ParkingSlot {

    public enum Status {
        AVAILABLE, OCCUPIED, PENDING, PRE_RESERVED
    }

    public enum SlotType {
        BIKE, THREE_WHEELER, CAR, VAN, VIP
    }

    private String id;
    private String slotNumber;
    private Status status;
    private SlotType slotType;
    private String createdAt;
    private String date; // NEW — date field e.g. 2026-05-17

    public ParkingSlot() {}

    public ParkingSlot(String id, String slotNumber, Status status,
                       SlotType slotType, String createdAt, String date) {
        this.id         = id;
        this.slotNumber = slotNumber;
        this.status     = status;
        this.slotType   = slotType;
        this.createdAt  = createdAt;
        this.date       = date;
    }

    public ParkingSlot(String id, String slotNumber, Status status, SlotType slotType) {
        this(id, slotNumber, status, slotType,
             LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")),
             LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
    }

    // Getters & Setters
    public String getId()                   { return id; }
    public void   setId(String id)          { this.id = id; }
    public String getSlotNumber()           { return slotNumber; }
    public void   setSlotNumber(String s)   { this.slotNumber = s; }
    public Status getStatus()               { return status; }
    public void   setStatus(Status s)       { this.status = s; }
    public SlotType getSlotType()           { return slotType; }
    public void   setSlotType(SlotType t)   { this.slotType = t; }
    public String getCreatedAt()            { return createdAt; }
    public void   setCreatedAt(String c)    { this.createdAt = c; }
    public String getDate()                 { return date; }
    public void   setDate(String date)      { this.date = date; }

    // File format: id|slotNumber|status|slotType|createdAt|date
    public String toFileString() {
        return String.join("|", id, slotNumber, status.name(),
                slotType.name(), createdAt, date != null ? date : "");
    }

    public static ParkingSlot fromFileString(String line) {
        String[] p = line.split("\\|");
        if (p.length < 5) return null;
        ParkingSlot s = new ParkingSlot();
        s.setId(p[0]);
        s.setSlotNumber(p[1]);
        s.setStatus(Status.valueOf(p[2]));
        s.setSlotType(SlotType.valueOf(p[3]));
        s.setCreatedAt(p[4]);
        s.setDate(p.length > 5 ? p[5] : "");
        return s;
    }

    public String getStatusColor() {
        return switch (status) {
            case AVAILABLE    -> "#37ff8b";
            case OCCUPIED     -> "#ff4c4c";
            case PENDING      -> "#ffd700";
            case PRE_RESERVED -> "#a0522d";
        };
    }

    public String getTypeIcon() {
        return switch (slotType) {
            case BIKE          -> "🏍";
            case THREE_WHEELER -> "🛺";
            case CAR           -> "🚗";
            case VAN           -> "🚐";
            case VIP           -> "⭐";
        };
    }

    @Override
    public String toString() {
        return "ParkingSlot{id='" + id + "', slotNumber='" + slotNumber +
               "', status=" + status + ", slotType=" + slotType +
               ", date='" + date + "'}";
    }
}
