package com.smartparking.smartparkingsystem.service;

import com.smartparking.smartparkingsystem.model.User;
import com.smartparking.smartparkingsystem.util.FileHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * UserService - Business logic for User Profile Management
 * Author: Nadin P.G.K | IT25101876
 */
@Service
public class UserService {

    @Autowired
    private FileHandler fileHandler;

    // ─── CREATE ─────────────────────────────────────────────────────────────────

    /**
     * Register a new driver.
     * @return "success" | "email_exists" | "error"
     */
    public String registerUser(String name, String email, String password, String phone) {
        if (fileHandler.findByEmail(email).isPresent()) {
            return "email_exists";
        }
        User user = new User(null, name, email, password, phone,
                             "DRIVER", LocalDate.now().toString());
        return fileHandler.addUser(user) ? "success" : "error";
    }

    // ─── READ / AUTH ─────────────────────────────────────────────────────────────

    /**
     * Authenticate a user by email + password.
     * @return the User if credentials match, otherwise empty.
     */
    public Optional<User> login(String email, String password) {
        return fileHandler.findByEmail(email)
                .filter(u -> u.getPassword().equals(password));
    }

    /** Get all users (for admin dashboard). */
    public List<User> getAllUsers() {
        return fileHandler.readAllUsers();
    }

    /** Find a user by ID. */
    public Optional<User> getUserById(String id) {
        return fileHandler.findById(id);
    }

    // ─── UPDATE ─────────────────────────────────────────────────────────────────

    /**
     * Change password after verifying the old password.
     * @return "success" | "wrong_password" | "not_found" | "error"
     */
    public String changePassword(String userId, String oldPassword, String newPassword) {
        Optional<User> opt = fileHandler.findById(userId);
        if (opt.isEmpty()) return "not_found";
        User user = opt.get();
        if (!user.getPassword().equals(oldPassword)) return "wrong_password";
        user.setPassword(newPassword);
        return fileHandler.updateUser(user) ? "success" : "error";
    }

    /**
     * Update contact number.
     * @return "success" | "not_found" | "error"
     */
    public String updatePhone(String userId, String newPhone) {
        Optional<User> opt = fileHandler.findById(userId);
        if (opt.isEmpty()) return "not_found";
        User user = opt.get();
        user.setPhone(newPhone);
        return fileHandler.updateUser(user) ? "success" : "error";
    }

    // ─── DELETE ─────────────────────────────────────────────────────────────────

    /**
     * Delete a user account.
     * @return "success" | "not_found" | "error"
     */
    public String deleteUser(String userId) {
        if (fileHandler.findById(userId).isEmpty()) return "not_found";
        return fileHandler.deleteUser(userId) ? "success" : "error";
    }
}
