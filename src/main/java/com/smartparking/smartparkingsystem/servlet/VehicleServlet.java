package com.smartparking.smartparkingsystem.servlet;

import com.smartparking.smartparkingsystem.model.User;
import com.smartparking.smartparkingsystem.model.Vehicle;
import com.smartparking.smartparkingsystem.service.VehicleService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@Controller
@RequestMapping("/vehicle")
public class VehicleServlet {

    @Autowired
    private VehicleService vehicleService;

    // TEST
    @GetMapping("/test")
    @ResponseBody
    public String test() {
        return "VehicleServlet is working!";
    }

    // READ — Show all vehicles
    @GetMapping("/list")
    public String list(Model model) {
        model.addAttribute("vehicles",
            vehicleService.getAllVehicles());
        return "Vehicle/vehicle-list";
    }

    // NEW — Vehicle selection page (after clicking slot)
    @GetMapping("/select")
    public String selectVehicle(
            @RequestParam String slotId,
            @RequestParam String slotNumber,
            @RequestParam String slotType,
            HttpSession session,
            Model model) {
        List<Vehicle> vehicles = vehicleService.getAllVehicles();
        model.addAttribute("vehicles", vehicles);
        model.addAttribute("slotId", slotId);
        model.addAttribute("slotNumber", slotNumber);
        model.addAttribute("slotType", slotType);
        return "Vehicle/vehicle-select";
    }

    // CREATE — Show add form
    @GetMapping("/add")
    public String showAdd(
            @RequestParam(required = false) String slotId,
            @RequestParam(required = false) String slotNumber,
            @RequestParam(required = false) String slotType,
            Model model) {
        model.addAttribute("slotId", slotId);
        model.addAttribute("slotNumber", slotNumber);
        model.addAttribute("slotType", slotType);
        return "Vehicle/add-vehicle";
    }

    // CREATE — Handle add
    @PostMapping("/add")
    public String add(
            @RequestParam String licensePlate,
            @RequestParam String ownerName,
            @RequestParam String vehicleType,
            @RequestParam String contactNumber,
            @RequestParam(required = false) String slotId,
            @RequestParam(required = false) String slotNumber,
            @RequestParam(required = false) String slotType,
            @RequestParam String userId) {

        Vehicle v = new Vehicle();
        v.setLicensePlate(licensePlate);
        v.setOwnerName(ownerName);
        v.setVehicleType(vehicleType);
        v.setContactNumber(contactNumber);
        v.setStatus("Authorized");
        v.setUserId(userId);

        // Add vehicle first — this sets the ID
        vehicleService.addVehicle(v);

        // Get ID after it's been set
        String vehicleId = v.getVehicleId();

        // If came from slot selection → go to tickets
        if (slotId != null && !slotId.isEmpty()) {
            return "redirect:/tickets/new"
                + "?vehicleId=" + vehicleId
                + "&slotId=" + slotId
                + "&slotNumber=" + slotNumber
                + "&vehicleNumber=" + licensePlate;
        }

        return "redirect:/vehicle/list";
    }

    // UPDATE — Show update form
    @GetMapping("/update")
    public String showUpdate(@RequestParam String id,
                             Model model) {
        model.addAttribute("vehicle",
            vehicleService.findById(id));
        return "Vehicle/edit-vehicle";
    }

    // UPDATE — Handle update
    @PostMapping("/update")
    public String update(@RequestParam String id,
                         @RequestParam String licensePlate,
                         @RequestParam String ownerName,
                         @RequestParam String vehicleType) {
        vehicleService.updateVehicle(id,
            licensePlate, ownerName, vehicleType);
        return "redirect:/vehicle/list";
    }

    // DELETE — Handle delete
    @PostMapping("/delete")
    public String delete(@RequestParam String id) {
        vehicleService.deleteVehicle(id);
        return "redirect:/vehicle/list";
    }

    // READ — Search vehicle
    @GetMapping("/search")
    public String search(@RequestParam String query,
                         Model model) {
        model.addAttribute("vehicles",
            vehicleService.searchVehicle(query));
        return "Vehicle/vehicle-list";
    }
}
