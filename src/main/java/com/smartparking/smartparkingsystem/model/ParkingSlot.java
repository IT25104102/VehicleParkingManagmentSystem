package com.smartparking.smartparkingsystem.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * ParkingSlot Model
 * Developer: Naveed M.I.M | IT25101466
 * Module: Parking Slot Management
 */
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

    // ── Constructors ──────────────────────────────────────────────────────────

    public ParkingSlot() {}

    public ParkingSlot(String id, String slotNumber, Status status,
                       SlotType slotType, String createdAt) {
        this.id         = id;
        this.slotNumber = slotNumber;
        this.status     = status;
        this.slotType   = slotType;
        this.createdAt  = createdAt;
    }

    /** Convenience constructor — stamps createdAt automatically. */
    public ParkingSlot(String id, String slotNumber, Status status, SlotType slotType) {
        this(id, slotNumber, status, slotType,
             LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
    }

    // ── Getters & Setters ─────────────────────────────────────────────────────

    public String getId()                   { return id; }
    public void   setId(String id)          { this.id = id; }

    public String getSlotNumber()                    { return slotNumber; }
    public void   setSlotNumber(String slotNumber)   { this.slotNumber = slotNumber; }

    public Status getStatus()               { return status; }
    public void   setStatus(Status status)  { this.status = status; }

    public SlotType getSlotType()                  { return slotType; }
    public void     setSlotType(SlotType slotType) { this.slotType = slotType; }

    public String getCreatedAt()                   { return createdAt; }
    public void   setCreatedAt(String createdAt)   { this.createdAt = createdAt; }

    // ── File serialisation helpers ────────────────────────────────────────────

    /** Pipe-delimited line written to slots.txt */
    public String toFileString() {
        return String.join("|", id, slotNumber, status.name(), slotType.name(), createdAt);
    }

    /** Parse one line from slots.txt back into a ParkingSlot. */
    public static ParkingSlot fromFileString(String line) {
        String[] p = line.split("\\|");
        if (p.length < 5) return null;
        ParkingSlot s = new ParkingSlot();
        s.setId(p[0]);
        s.setSlotNumber(p[1]);
        s.setStatus(Status.valueOf(p[2]));
        s.setSlotType(SlotType.valueOf(p[3]));
        s.setCreatedAt(p[4]);
        return s;
    }

    // ── Display helpers (used in JSP EL) ─────────────────────────────────────

    /** CSS colour class used in the slot map. */
    public String getStatusColor() {
        return switch (status) {
            case AVAILABLE    -> "#37ff8b";   // neon green
            case OCCUPIED     -> "#ff4c4c";   // red
            case PENDING      -> "#ffd700";   // yellow
            case PRE_RESERVED -> "#a0522d";   // brown
        };
    }

    public String getStatusLabel() {
        return switch (status) {
            case AVAILABLE    -> "Available";
            case OCCUPIED     -> "Occupied";
            case PENDING      -> "Pending";
            case PRE_RESERVED -> "Pre-Reserved";
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
               ", createdAt='" + createdAt + "'}";
    }
}
