package com.smartparking.smartparkingsystem.model;

public abstract class BaseEntity {
    protected String id;
    protected String createdAt;

    public abstract String toFileString();
    public abstract void fromFileString(String line);

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}