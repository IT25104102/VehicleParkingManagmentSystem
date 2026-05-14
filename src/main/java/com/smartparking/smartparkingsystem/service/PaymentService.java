package com.smartparking.smartparkingsystem.service;

import com.smartparking.smartparkingsystem.model.Payment;
import com.smartparking.smartparkingsystem.util.FileUtil;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
public class PaymentService {

    private static final String FILE = "data/payments.txt";

    // Rate per hour based on vehicle type
    private double getRate(String vehicleType) {
        switch (vehicleType.toUpperCase()) {
            case "BIKE":         return 200.0;
            case "THREE WHEELER":return 250.0;
            case "CAR":          return 350.0;
            case "VAN":          return 550.0;
            case "VIP":          return 800.0;
            default:             return 350.0;
        }
    }

    // CREATE — Finalise a parking bill
    public Payment createPayment(String ticketId,
                                 double hours,
                                 String vehicleType) {
        double rate = getRate(vehicleType);
        Payment p = new Payment();
        p.setId(FileUtil.generateId("PAY"));
        p.setTicketId(ticketId);
        p.setAmount(hours * rate);
        p.setStatus("PENDING");
        p.setMethod("CASH");
        p.setCreatedAt(new Date().toString());
        FileUtil.appendLine(FILE, p.toFileString());
        return p;
    }

    // READ — Get all payments
    public List<Payment> getAllPayments() {
        List<Payment> list = new ArrayList<>();
        for (String line : FileUtil.readAll(FILE)) {
            Payment p = new Payment();
            p.fromFileString(line);
            list.add(p);
        }
        return list;
    }

    // READ — Find by ID
    public Payment findById(String id) {
        for (Payment p : getAllPayments()) {
            if (p.getId().equals(id)) return p;
        }
        return null;
    }

    // READ — Find by ticket ID
    public Payment findByTicketId(String ticketId) {
        for (Payment p : getAllPayments()) {
            if (p.getTicketId().equals(ticketId))
                return p;
        }
        return null;
    }

    // UPDATE — Change payment status
    public boolean updateStatus(String id, String status) {
        List<String> lines = FileUtil.readAll(FILE);
        List<String> updated = new ArrayList<>();
        boolean found = false;
        for (String line : lines) {
            Payment p = new Payment();
            p.fromFileString(line);
            if (p.getId().equals(id)) {
                p.setStatus(status);
                updated.add(p.toFileString());
                found = true;
            } else {
                updated.add(line);
            }
        }
        if (found) FileUtil.writeAll(FILE, updated);
        return found;
    }

    // DELETE — Remove payment
    public boolean deletePayment(String id) {
        List<String> lines = FileUtil.readAll(FILE);
        List<String> updated = new ArrayList<>();
        boolean found = false;
        for (String line : lines) {
            Payment p = new Payment();
            p.fromFileString(line);
            if (!p.getId().equals(id)) {
                updated.add(line);
            } else {
                found = true;
            }
        }
        if (found) FileUtil.writeAll(FILE, updated);
        return found;
    }
}
