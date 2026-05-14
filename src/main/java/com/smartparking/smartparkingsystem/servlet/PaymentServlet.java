package com.smartparking.smartparkingsystem.servlet;

import com.smartparking.smartparkingsystem.model.Payment;
import com.smartparking.smartparkingsystem.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/payment")
public class PaymentServlet {

    @Autowired
    private PaymentService paymentService;

    // SHOW amount summary page
    @GetMapping("/create")
    public String showCreate() {
        return "payment/create";
    }

    // CREATE payment and go to payment method page
    @PostMapping("/create")
    public String create(@RequestParam String ticketId,
                         @RequestParam double hours,
                         @RequestParam String vehicleType,
                         @RequestParam(required = false) String slot,
                         @RequestParam(required = false) String vehicleNumber,
                         @RequestParam(required = false) String date,
                         Model model) {
        Payment p = paymentService.createPayment(
                ticketId, hours, vehicleType);
        model.addAttribute("payment", p);
        return "payment/receipt";
    }

    // SHOW payment history
    @GetMapping("/history")
    public String history(Model model) {
        model.addAttribute("payments",
                paymentService.getAllPayments());
        return "payment/history";
    }

    // SHOW cash confirm page
    @GetMapping("/cash")
    public String showCash(@RequestParam String id,
                           Model model) {
        Payment p = paymentService.findById(id);
        model.addAttribute("payment", p);
        return "payment/cash";
    }

    // CONFIRM cash payment → go to ticket
    @PostMapping("/confirmCash")
    public String confirmCash(@RequestParam String id,
                              Model model) {
        paymentService.updateStatus(id, "PENDING");
        Payment p = paymentService.findById(id);
        model.addAttribute("payment", p);
        return "payment/ticket";
    }

    // SHOW card payment page
    @GetMapping("/card")
    public String showCard(@RequestParam String id,
                           Model model) {
        Payment p = paymentService.findById(id);
        model.addAttribute("payment", p);
        return "payment/card";
    }

    // CONFIRM card payment → go to ticket
    @PostMapping("/confirmCard")
    public String confirmCard(@RequestParam String id,
                              @RequestParam String cardNumber,
                              @RequestParam String cardName,
                              Model model) {
        paymentService.updateStatus(id, "COMPLETED");
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
