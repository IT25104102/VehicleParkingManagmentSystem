package com.smartparking.smartparkingsystem.model;

public class Vehicle {

    private String vehicleId;
    private String ownerName;
    private String licensePlate;
    private String vehicleType;
    private String contactNumber;
    private String status;

    // Empty constructor
    public Vehicle() {}

    // Full constructor
    public Vehicle(String vehicleId, String ownerName, String licensePlate,
                   String vehicleType, String contactNumber, String status) {
        this.vehicleId     = vehicleId;
        this.ownerName     = ownerName;
        this.licensePlate  = licensePlate;
        this.vehicleType   = vehicleType;
        this.contactNumber = contactNumber;
        this.status        = status;
    }

    // Getters
    public String getVehicleId()      { return vehicleId; }
    public String getOwnerName()      { return ownerName; }
    public String getLicensePlate()   { return licensePlate; }
    public String getVehicleType()    { return vehicleType; }
    public String getContactNumber()  { return contactNumber; }
    public String getStatus()         { return status; }

    // Setters
    public void setVehicleId(String vehicleId)           { this.vehicleId = vehicleId; }
    public void setOwnerName(String ownerName)           { this.ownerName = ownerName; }
    public void setLicensePlate(String licensePlate)     { this.licensePlate = licensePlate; }
    public void setVehicleType(String vehicleType)       { this.vehicleType = vehicleType; }
    public void setContactNumber(String contactNumber)   { this.contactNumber = contactNumber; }
    public void setStatus(String status)                 { this.status = status; }

    // Convert Vehicle object → one line of text for saving in vehicles.txt
    // Example:  V001|John Silva|CAB-1234|Car|0771234567|Authorized
    public String toFileString() {
        return vehicleId + "|" + ownerName + "|" + licensePlate + "|"
                + vehicleType + "|" + contactNumber + "|" + status;
    }

    // Convert one line of text from vehicles.txt → Vehicle object
    public static Vehicle fromFileString(String line) {
        String[] parts = line.split("\\|");
        return new Vehicle(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5]);
    }
}