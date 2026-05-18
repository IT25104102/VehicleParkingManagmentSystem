package com.smartparking.smartparkingsystem.servlet;

import com.smartparking.smartparkingsystem.model.Payment;
import com.smartparking.smartparkingsystem.model.User;
import com.smartparking.smartparkingsystem.service.PaymentService;
import com.smartparking.smartparkingsystem.service.ParkingSlotService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/payment")
public class PaymentServlet {

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private ParkingSlotService slotService;

    // SHOW amount summary page
    @GetMapping("/create")
    public String showCreate() {
        return "payment/create";
    }

    // CREATE payment and go to payment method page
    @PostMapping("/create")
    public String create(
            @RequestParam String ticketId,
            @RequestParam double hours,
            @RequestParam String vehicleType,
            @RequestParam(required = false) String slotId,
            @RequestParam(required = false) String slot,
            @RequestParam(required = false) String vehicleNumber,
            @RequestParam(required = false) String date,
            Model model) {
        Payment p = paymentService.createPayment(ticketId, hours, vehicleType);
        // Pass slotId to receipt for later use
        model.addAttribute("payment", p);
        model.addAttribute("slotId", slotId);
        return "payment/receipt";
    }

    // SHOW payment history
    @GetMapping("/history")
    public String history(HttpSession session, Model model) {
        model.addAttribute("payments", paymentService.getAllPayments());
        User user = (User) session.getAttribute("loggedInUser");
        if (user != null) {
            model.addAttribute("userRole", user.getRole());
        }
        return "payment/history";
    }

    // SHOW cash confirm page
    @GetMapping("/cash")
    public String showCash(@RequestParam String id,
                           @RequestParam(required = false) String slotId,
                           Model model) {
        Payment p = paymentService.findById(id);
        model.addAttribute("payment", p);
        model.addAttribute("slotId", slotId);
        return "payment/cash";
    }

    // CONFIRM cash payment → mark slot OCCUPIED → go to ticket
    @PostMapping("/confirmCash")
    public String confirmCash(
            @RequestParam String id,
            @RequestParam(required = false) String slotId,
            Model model) {
        paymentService.updateStatus(id, "PENDING");

        // Mark slot as OCCUPIED
        if (slotId != null && !slotId.isEmpty()) {
            slotService.setOccupied(slotId);
        }

        Payment p = paymentService.findById(id);
        model.addAttribute("payment", p);
        return "payment/ticket";
    }

    // SHOW card payment page
    @GetMapping("/card")
    public String showCard(@RequestParam String id,
                           @RequestParam(required = false) String slotId,
                           Model model) {
        Payment p = paymentService.findById(id);
        model.addAttribute("payment", p);
        model.addAttribute("slotId", slotId);
        return "payment/card";
    }

    // CONFIRM card payment → mark slot OCCUPIED → go to ticket
    @PostMapping("/confirmCard")
    public String confirmCard(
            @RequestParam String id,
            @RequestParam String cardNumber,
            @RequestParam String cardName,
            @RequestParam(required = false) String slotId,
            Model model) {
        paymentService.updateStatus(id, "COMPLETED");

        // Mark slot as OCCUPIED
        if (slotId != null && !slotId.isEmpty()) {
            slotService.setOccupied(slotId);
        }

        Payment p = paymentService.findById(id);
        model.addAttribute("payment", p);
        return "payment/ticket";
    }

    // UPDATE payment status
    @PostMapping("/updateStatus")
    public String updateStatus(@RequestParam String id,
                               @RequestParam String status) {
        paymentService.updateStatus(id, status);
        return "redirect:/payment/history";
    }

    // DELETE payment
    @PostMapping("/delete")
    public String delete(@RequestParam String id) {
        paymentService.deletePayment(id);
        return "redirect:/payment/history";
    }
}
