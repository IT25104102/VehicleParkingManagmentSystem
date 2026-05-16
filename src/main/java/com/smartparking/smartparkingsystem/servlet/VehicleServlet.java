 package com.smartparking.smartparkingsystem.servlet;

import com.smartparking.smartparkingsystem.model.Vehicle;
import com.smartparking.smartparkingsystem.service.VehicleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/vehicle")
public class VehicleServlet {

    @Autowired
    private VehicleService vehicleService;

    // READ — Show all vehicles
    @GetMapping("/list")
    public String list(Model model) {
        model.addAttribute("vehicles",
            vehicleService.getAllVehicles());
        return "vehicle/list";
    }

    // CREATE — Show add form
    @GetMapping("/add")
    public String showAdd() {
        return "vehicle/add";
    }

    // CREATE — Handle add
    @PostMapping("/add")
    public String add(@RequestParam String licensePlate,
                      @RequestParam String ownerName,
                      @RequestParam String vehicleType,
                      @RequestParam String userId,
                      Model model) {
        Vehicle v = new Vehicle();
        v.setLicensePlate(licensePlate);
        v.setOwnerName(ownerName);
        v.setVehicleType(vehicleType);
        v.setUserId(userId);
        vehicleService.addVehicle(v);
        return "redirect:/vehicle/list";
    }

    // UPDATE — Show update form
    @GetMapping("/update")
    public String showUpdate(@RequestParam String id,
                             Model model) {
        model.addAttribute("vehicle",
            vehicleService.findById(id));
        return "vehicle/update";
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
        return "vehicle/list";
    }
}
