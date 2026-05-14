package com.smartparking.smartparkingsystem.util;

import com.smartparking.smartparkingsystem.model.Ticket;
import org.springframework.stereotype.Component;

import java.io.*;
import java.nio.file.*;
import java.util.*;

@Component
public class FileHandler {

    private static final String DATA_DIR    = "data/";
    private static final String TICKET_FILE = DATA_DIR + "tickets.txt";

    // ── Ensure file exists on startup ─────────────────────────
    public FileHandler() {
        try {
            Files.createDirectories(Paths.get(DATA_DIR));
            File f = new File(TICKET_FILE);
            if (!f.exists()) f.createNewFile();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // ── READ all tickets from file ────────────────────────────
    public List<Ticket> readAllTickets() {
        List<Ticket> list = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(TICKET_FILE))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    Ticket t = Ticket.fromFileString(line);
                    if (t != null) list.add(t);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── WRITE all tickets (overwrites file) ───────────────────
    public void writeAllTickets(List<Ticket> tickets) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(TICKET_FILE, false))) {
            for (Ticket t : tickets) {
                bw.write(t.toFileString());
                bw.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // ── APPEND single ticket to file ──────────────────────────
    public void appendTicket(Ticket ticket) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(TICKET_FILE, true))) {
            bw.write(ticket.toFileString());
            bw.newLine();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}