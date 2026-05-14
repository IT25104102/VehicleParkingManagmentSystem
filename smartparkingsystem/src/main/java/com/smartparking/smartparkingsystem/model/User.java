package com.smartparking.smartparkingsystem.model;

/**
 * User Model - User Profile Management Module
 * Author: Nadin P.G.K | IT25101876
 */
public class User {

    private String id;
    private String name;
    private String email;
    private String password;
    private String phone;
    private String role;      // ADMIN or DRIVER
    private String createdAt;

    // ─── Constructors ───────────────────────────────────────────────────────────

    public User() {}

    public User(String id, String name, String email, String password,
                String phone, String role, String createdAt) {
        this.id        = id;
        this.name      = name;
        this.email     = email;
        this.password  = password;
        this.phone     = phone;
        this.role      = role;
        this.createdAt = createdAt;
    }

    // ─── File Format Helpers ────────────────────────────────────────────────────

    /**
     * Serialize to the pipe-delimited line format used in users.txt:
     * USR001|John|john@email.com|pass123|0771234567|DRIVER|2026-05-04
     */
    public String toFileString() {
        return id + "|" + name + "|" + email + "|" + password + "|"
                + phone + "|" + role + "|" + createdAt;
    }

    /**
     * Deserialize from a pipe-delimited line.
     */
    public static User fromFileString(String line) {
        String[] parts = line.split("\\|");
        if (parts.length < 7) return null;
        return new User(parts[0], parts[1], parts[2], parts[3],
                        parts[4], parts[5], parts[6]);
    }

    // ─── Getters & Setters ──────────────────────────────────────────────────────

    public String getId()                    { return id; }
    public void   setId(String id)           { this.id = id; }

    public String getName()                  { return name; }
    public void   setName(String name)       { this.name = name; }

    public String getEmail()                 { return email; }
    public void   setEmail(String email)     { this.email = email; }

    public String getPassword()              { return password; }
    public void   setPassword(String password) { this.password = password; }

    public String getPhone()                 { return phone; }
    public void   setPhone(String phone)     { this.phone = phone; }

    public String getRole()                  { return role; }
    public void   setRole(String role)       { this.role = role; }

    public String getCreatedAt()             { return createdAt; }
    public void   setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "User{id='" + id + "', name='" + name + "', email='" + email
                + "', role='" + role + "'}";
    }
}
