package com.smartparking.smartparkingsystem.util;

import com.smartparking.smartparkingsystem.model.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.*;
import java.nio.file.*;
import java.util.*;

/**
 * FileHandler - Handles all file I/O for users.txt
 * Author: Nadin P.G.K | IT25101876
 *
 * File format: USR001|John|john@email.com|pass123|0771234567|DRIVER|2026-05-04
 */
@Component
public class FileHandler {

    @Value("${app.data.path:data/}")
    private String dataPath;

    private static final String USERS_FILE = "users.txt";

    // ─── Internal helpers ───────────────────────────────────────────────────────

    private Path getUsersFilePath() {
        Path path = Paths.get(dataPath + USERS_FILE);
        try {
            Files.createDirectories(path.getParent());
            if (!Files.exists(path)) {
                Files.createFile(path);
                // Seed one admin account so the system is usable immediately
                saveUsers(List.of(
                    new User("USR001", "Admin", "admin@smartparking.com",
                             "admin123", "0700000000", "ADMIN",
                             java.time.LocalDate.now().toString())
                ));
            }
        } catch (IOException e) {
            throw new RuntimeException("Cannot initialise users file: " + path, e);
        }
        return path;
    }

    // ─── READ ───────────────────────────────────────────────────────────────────

    /** Read all users from users.txt. */
    public List<User> readAllUsers() {
        List<User> users = new ArrayList<>();
        try {
            for (String line : Files.readAllLines(getUsersFilePath())) {
                line = line.trim();
                if (!line.isEmpty()) {
                    User u = User.fromFileString(line);
                    if (u != null) users.add(u);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return users;
    }

    /** Find a user by email (case-insensitive). */
    public Optional<User> findByEmail(String email) {
        return readAllUsers().stream()
                .filter(u -> u.getEmail().equalsIgnoreCase(email))
                .findFirst();
    }

    /** Find a user by ID. */
    public Optional<User> findById(String id) {
        return readAllUsers().stream()
                .filter(u -> u.getId().equals(id))
                .findFirst();
    }

    // ─── WRITE ──────────────────────────────────────────────────────────────────

    /** Overwrite the file with the given list. */
    private void saveUsers(List<User> users) throws IOException {
        List<String> lines = new ArrayList<>();
        for (User u : users) lines.add(u.toFileString());
        Files.write(getUsersFilePath(), lines,
                    StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);
    }

    // ─── CREATE ─────────────────────────────────────────────────────────────────

    /**
     * Append a new user.
     * @return true on success, false if email already exists.
     */
    public boolean addUser(User newUser) {
        List<User> users = readAllUsers();
        boolean exists = users.stream()
                .anyMatch(u -> u.getEmail().equalsIgnoreCase(newUser.getEmail()));
        if (exists) return false;
        newUser.setId(generateId(users));
        users.add(newUser);
        try {
            saveUsers(users);
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── UPDATE ─────────────────────────────────────────────────────────────────

    /**
     * Update an existing user by ID.
     * @return true on success.
     */
    public boolean updateUser(User updated) {
        List<User> users = readAllUsers();
        boolean found = false;
        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getId().equals(updated.getId())) {
                users.set(i, updated);
                found = true;
                break;
            }
        }
        if (!found) return false;
        try {
            saveUsers(users);
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── DELETE ─────────────────────────────────────────────────────────────────

    /**
     * Remove a user by ID.
     * @return true on success.
     */
    public boolean deleteUser(String id) {
        List<User> users = readAllUsers();
        boolean removed = users.removeIf(u -> u.getId().equals(id));
        if (!removed) return false;
        try {
            saveUsers(users);
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── ID Generator ───────────────────────────────────────────────────────────

    /** Generate next sequential USRxxx ID. */
    private String generateId(List<User> users) {
        int max = 0;
        for (User u : users) {
            try {
                int num = Integer.parseInt(u.getId().replace("USR", ""));
                if (num > max) max = num;
            } catch (NumberFormatException ignored) {}
        }
        return String.format("USR%03d", max + 1);
    }
}
