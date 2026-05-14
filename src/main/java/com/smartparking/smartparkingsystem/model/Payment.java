package com.smartparking.smartparkingsystem.model;

public class Payment extends BaseEntity {
    private String ticketId;
    private double amount;
    private String status;
    private String method;

    @Override
    public String toFileString() {
        return id + "|" + ticketId + "|" + amount
                + "|" + status + "|" + method + "|" + createdAt;
    }

    @Override
    public void fromFileString(String line) {
        String[] parts = line.split("\\|");
        this.id        = parts[0];
        this.ticketId  = parts[1];
        this.amount    = Double.parseDouble(parts[2]);
        this.status    = parts[3];
        this.method    = parts[4];
        this.createdAt = parts[5];
    }

    public String getTicketId() { return ticketId; }
    public void setTicketId(String ticketId) { this.ticketId = ticketId; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getMethod() { return method; }
    public void setMethod(String method) { this.method = method; }
}
