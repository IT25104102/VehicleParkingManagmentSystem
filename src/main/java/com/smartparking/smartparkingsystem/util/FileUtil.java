package com.smartparking.smartparkingsystem.util;

import java.io.*;
import java.util.*;

public class FileUtil {

    // READ all lines from a file
    public static List<String> readAll(String filePath) {
        List<String> lines = new ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) return lines;

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) lines.add(line.trim());
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return lines;
    }

    // WRITE (overwrite entire file)
    public static void writeAll(String filePath, List<String> lines) {
        try {
            File file = new File(filePath);
            file.getParentFile().mkdirs();
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, false))) {
                for (String line : lines) {
                    writer.write(line);
                    writer.newLine();
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // APPEND a single line
    public static void appendLine(String filePath, String line) {
        try {
            File file = new File(filePath);
            file.getParentFile().mkdirs();
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
                writer.write(line);
                writer.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Generate unique ID
    public static String generateId(String prefix) {
        return prefix + System.currentTimeMillis();
    }
}
