package com.smartparking.smartparkingsystem.service;

import com.smartparking.smartparkingsystem.model.User;
import com.smartparking.smartparkingsystem.util.FileUtil;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.util.*;

@Service
public class UserService {

    private static final String FILE = "data/users.txt";

    // CREATE — Register new user
    public String registerUser(String name, String email,
            String password, String phone) {
        if (findByEmail(email) != null) return "email_exists";
        User user = new User();
        user.setId(FileUtil.generateId("USR"));
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);
        user.setPhone(phone);
        user.setRole("DRIVER");
        user.setCreatedAt(LocalDate.now().toString());
        FileUtil.appendLine(FILE, user.toFileString());
        return "success";
    }

    // READ — Login — returns Optional
    public Optional<User> login(String email, String password) {
        User user = findByEmail(email);
        if (user != null && user.getPassword()
                .equals(password)) return Optional.of(user);
        return Optional.empty();
    }

    // READ — Get all users
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        for (String line : FileUtil.readAll(FILE)) {
            if (line.trim().isEmpty()) continue;
            User u = new User();
            u.fromFileString(line);
            list.add(u);
        }
        return list;
    }

    // READ — Find by email
    public User findByEmail(String email) {
        for (User u : getAllUsers()) {
            if (u.getEmail().equalsIgnoreCase(email))
                return u;
        }
        return null;
    }

    // READ — Find by ID
    public User findById(String id) {
        for (User u : getAllUsers()) {
            if (u.getId().equals(id)) return u;
        }
        return null;
    }

    // READ — Get user by ID — returns Optional
    public Optional<User> getUserById(String id) {
        return getAllUsers().stream()
                .filter(u -> u.getId().equals(id))
                .findFirst();
    }

    // UPDATE — Change password
    public String changePassword(String userId,
            String oldPassword, String newPassword) {
        List<String> lines = FileUtil.readAll(FILE);
        List<String> updated = new ArrayList<>();
        boolean found = false;
        for (String line : lines) {
            if (line.trim().isEmpty()) continue;
            User u = new User();
            u.fromFileString(line);
            if (u.getId().equals(userId)) {
                if (!u.getPassword().equals(oldPassword))
                    return "wrong_password";
                u.setPassword(newPassword);
                updated.add(u.toFileString());
                found = true;
            } else {
                updated.add(line);
            }
        }
        if (found) FileUtil.writeAll(FILE, updated);
        return found ? "success" : "not_found";
    }

    // UPDATE — Change phone
    public String updatePhone(String userId,
            String newPhone) {
        List<String> lines = FileUtil.readAll(FILE);
        List<String> updated = new ArrayList<>();
        boolean found = false;
        for (String line : lines) {
            if (line.trim().isEmpty()) continue;
            User u = new User();
            u.fromFileString(line);
            if (u.getId().equals(userId)) {
                u.setPhone(newPhone);
                updated.add(u.toFileString());
                found = true;
            } else {
                updated.add(line);
            }
        }
        if (found) FileUtil.writeAll(FILE, updated);
        return found ? "success" : "not_found";
    }

    // DELETE — Remove user
    public String deleteUser(String userId) {
        List<String> lines = FileUtil.readAll(FILE);
        List<String> updated = new ArrayList<>();
        boolean found = false;
        for (String line : lines) {
            if (line.trim().isEmpty()) continue;
            User u = new User();
            u.fromFileString(line);
            if (!u.getId().equals(userId)) {
                updated.add(line);
            } else {
                found = true;
            }
        }
        if (found) FileUtil.writeAll(FILE, updated);
        return found ? "success" : "not_found";
    }
}
