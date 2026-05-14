package com.smartparking.smartparkingsystem.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Ticket {

    public static final String STATUS_ACTIVE = "ACTIVE";
    public static final String STATUS_VOIDED = "VOIDED";
    public static final DateTimeFormatter FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    // ── Fields ────────────────────────────────────────────────
    private String id;
    private String vehicleId;
    private String slotId;
    private String vehicleNumber;
    private LocalDateTime checkInTime;
    private LocalDateTime checkOutTime;
    private String status;
    private LocalDateTime createdAt;

    // ── Constructors ──────────────────────────────────────────
    public Ticket() {}

    public Ticket(String id, String vehicleId, String slotId,
                  String vehicleNumber, LocalDateTime checkInTime,
                  LocalDateTime checkOutTime, String status,
                  LocalDateTime createdAt) {
        this.id            = id;
        this.vehicleId     = vehicleId;
        this.slotId        = slotId;
        this.vehicleNumber = vehicleNumber;
        this.checkInTime   = checkInTime;
        this.checkOutTime  = checkOutTime;
        this.status        = status;
        this.createdAt     = createdAt;
    }

    // ── Getters & Setters ─────────────────────────────────────
    public String getId()                        { return id; }
    public void   setId(String id)               { this.id = id; }

    public String getVehicleId()                 { return vehicleId; }
    public void   setVehicleId(String vehicleId) { this.vehicleId = vehicleId; }

    public String getSlotId()                    { return slotId; }
    public void   setSlotId(String slotId)       { this.slotId = slotId; }

    public String getVehicleNumber()                     { return vehicleNumber; }
    public void   setVehicleNumber(String vehicleNumber) { this.vehicleNumber = vehicleNumber; }

    public LocalDateTime getCheckInTime()                         { return checkInTime; }
    public void          setCheckInTime(LocalDateTime checkInTime){ this.checkInTime = checkInTime; }

    public LocalDateTime getCheckOutTime()                          { return checkOutTime; }
    public void          setCheckOutTime(LocalDateTime checkOutTime){ this.checkOutTime = checkOutTime; }

    public String getStatus()              { return status; }
    public void   setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt()                       { return createdAt; }
    public void          setCreatedAt(LocalDateTime createdAt){ this.createdAt = createdAt; }

    // ── File serialization ────────────────────────────────────
    public String toFileString() {
        return String.join("|",
                id,
                vehicleId,
                slotId,
                vehicleNumber,
                checkInTime  != null ? checkInTime.format(FORMATTER)  : "",
                checkOutTime != null ? checkOutTime.format(FORMATTER) : "",
                status,
                createdAt    != null ? createdAt.format(FORMATTER)    : ""
        );
    }

    public static Ticket fromFileString(String line) {
        String[] p = line.split("\\|", -1);
        if (p.length < 8) return null;

        Ticket t = new Ticket();
        t.setId(p[0]);
        t.setVehicleId(p[1]);
        t.setSlotId(p[2]);
        t.setVehicleNumber(p[3]);
        t.setCheckInTime (p[4].isEmpty() ? null : LocalDateTime.parse(p[4], FORMATTER));
        t.setCheckOutTime(p[5].isEmpty() ? null : LocalDateTime.parse(p[5], FORMATTER));
        t.setStatus(p[6]);
        t.setCreatedAt   (p[7].isEmpty() ? null : LocalDateTime.parse(p[7], FORMATTER));
        return t;
    }
}