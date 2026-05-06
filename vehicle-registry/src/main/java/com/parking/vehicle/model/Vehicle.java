package com.parking.vehicle.model;

/**
 * Vehicle model class demonstrating OOP Encapsulation.
 * Each vehicle record stored in vehicles.txt as a pipe-separated line:
 * plateNumber|ownerId|ownerName|type|model|contact
 *
 * Author: De Silva M.A.G.G - IT25100132
 */
public class Vehicle {

    private String plateNumber;  // Unique identifier (e.g., CAR-1234)
    private String ownerId;      // Owner's ID (links to User module)
    private String ownerName;    // Owner's full name
    private String type;         // Car, Bike, Van, Truck, etc.
    private String model;        // e.g., Toyota Corolla
    private String contact;      // Owner's contact number

    // ─── Constructors ────────────────────────────────────────────────────────

    public Vehicle() {}

    public Vehicle(String plateNumber, String ownerId, String ownerName,
                   String type, String model, String contact) {
        this.plateNumber = plateNumber;
        this.ownerId = ownerId;
        this.ownerName = ownerName;
        this.type = type;
        this.model = model;
        this.contact = contact;
    }

    // ─── Getters & Setters (Encapsulation) ───────────────────────────────────

    public String getPlateNumber() { return plateNumber; }
    public void setPlateNumber(String plateNumber) { this.plateNumber = plateNumber; }

    public String getOwnerId() { return ownerId; }
    public void setOwnerId(String ownerId) { this.ownerId = ownerId; }

    public String getOwnerName() { return ownerName; }
    public void setOwnerName(String ownerName) { this.ownerName = ownerName; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }

    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }

    // ─── File Serialization ───────────────────────────────────────────────────

    /**
     * Converts this Vehicle object into a pipe-separated string for .txt storage.
     * Format: plateNumber|ownerId|ownerName|type|model|contact
     */
    public String toFileString() {
        return plateNumber + "|" + ownerId + "|" + ownerName + "|" +
               type + "|" + model + "|" + contact;
    }

    /**
     * Parses a pipe-separated line from vehicles.txt and returns a Vehicle object.
     */
    public static Vehicle fromFileString(String line) {
        String[] parts = line.split("\\|");
        if (parts.length != 6) return null;
        return new Vehicle(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5]);
    }

    @Override
    public String toString() {
        return "Vehicle{plateNumber='" + plateNumber + "', ownerId='" + ownerId +
               "', ownerName='" + ownerName + "', type='" + type +
               "', model='" + model + "', contact='" + contact + "'}";
    }
}
