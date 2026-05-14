package com.parking.util;

import java.io.*;
import java.nio.file.*;
import java.util.*;

public class FileUtil {
    // Read all lines from a file. Returns empty list if file doesn't exist.
    public static List<String> readAll(String filePath) {
        List<String> lines = new ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) return lines;
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                lines.add(line);
            }
        } catch (IOException e) {
            System.err.println("[FileUtil] Error reading: " + filePath);
        }
        return lines;
    }

    // Append a single line to the end of a file
    public static void appendLine(String filePath, String line) {
        File file = new File(filePath);
        file.getParentFile().mkdirs(); // create parent dirs if needed
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
            writer.write(line);
            writer.newLine();
        } catch (IOException e) {
            System.err.println("[FileUtil] Error appending to: " + filePath);
        }
    }

    // Overwrite entire file with new content
    public static void writeAll(String filePath, String content) {
        File file = new File(filePath);
        file.getParentFile().mkdirs();
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, false))) {
            writer.write(content);
        } catch (IOException e) {
            System.err.println("[FileUtil] Error writing to: " + filePath);
        }
    }
}
