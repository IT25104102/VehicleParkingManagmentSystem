package com.smartparking.smartparkingsystem.model;

public class Vehicle {

    private String vehicleId;
    private String ownerName;
    private String licensePlate;
    private String vehicleType;
    private String contactNumber;
    private String status;
    private String userId;

    // Empty constructor
    public Vehicle() {}

    // Full constructor
    public Vehicle(String vehicleId, String ownerName, String licensePlate,
                   String vehicleType, String contactNumber, String status,
                   String userId) {
        this.vehicleId     = vehicleId;
        this.ownerName     = ownerName;
        this.licensePlate  = licensePlate;
        this.vehicleType   = vehicleType;
        this.contactNumber = contactNumber;
        this.status        = status;
        this.userId        = userId;
    }

    // Getters
    public String getVehicleId()     { return vehicleId; }
    public String getOwnerName()     { return ownerName; }
    public String getLicensePlate()  { return licensePlate; }
    public String getVehicleType()   { return vehicleType; }
    public String getContactNumber() { return contactNumber; }
    public String getStatus()        { return status; }
    public String getUserId()        { return userId; }

    // Setters
    public void setVehicleId(String vehicleId)         { this.vehicleId = vehicleId; }
    public void setOwnerName(String ownerName)         { this.ownerName = ownerName; }
    public void setLicensePlate(String licensePlate)   { this.licensePlate = licensePlate; }
    public void setVehicleType(String vehicleType)     { this.vehicleType = vehicleType; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }
    public void setStatus(String status)               { this.status = status; }
    public void setUserId(String userId)               { this.userId = userId; }

    // Convert Vehicle object → one line of text for saving in vehicles.txt
    public String toFileString() {
        return vehicleId     + "|" +
               ownerName     + "|" +
               licensePlate  + "|" +
               vehicleType   + "|" +
               contactNumber + "|" +
               status        + "|" +
               (userId != null ? userId : "");
    }

    // Convert one line of text from vehicles.txt → Vehicle object
    public static Vehicle fromFileString(String line) {
        String[] parts = line.split("\\|", -1);
        Vehicle v = new Vehicle();
        v.setVehicleId    (parts.length > 0 ? parts[0] : "");
        v.setOwnerName    (parts.length > 1 ? parts[1] : "");
        v.setLicensePlate (parts.length > 2 ? parts[2] : "");
        v.setVehicleType  (parts.length > 3 ? parts[3] : "");
        v.setContactNumber(parts.length > 4 ? parts[4] : "");
        v.setStatus       (parts.length > 5 ? parts[5] : "");
        v.setUserId       (parts.length > 6 ? parts[6] : "");
        return v;
    }
}
