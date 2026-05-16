package com.smartparking.smartparkingsystem.servlet;

import com.smartparking.smartparkingsystem.model.Ticket;
import com.smartparking.smartparkingsystem.service.TicketService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.List;

@Controller
public class TicketServlet {

    @Autowired
    private TicketService ticketService;

    // HOME — Redirect to tickets
    @GetMapping("/")
    public String home() {
        return "redirect:/tickets";
    }

    // READ — List all active tickets
    @GetMapping("/tickets")
    public String listTickets(Model model) {
        List<Ticket> active = ticketService.getActiveTickets();
        List<Ticket> all = ticketService.getAllTickets();
        model.addAttribute("tickets", active);
        model.addAttribute("activeCount", active.size());
        model.addAttribute("totalCount", all.size());
        model.addAttribute("voidedCount", all.stream()
            .filter(t -> "VOIDED".equals(
                t.getStatus())).count());
        return "tickets/ticket-list";
    }

    // CREATE — Show generate ticket form
    @GetMapping("/tickets/new")
    public String showCreateForm(Model model) {
        model.addAttribute("pageTitle",
            "Generate Ticket");
        return "tickets/ticket-form";
    }

    // CREATE — Process generate ticket form
    @PostMapping("/tickets/create")
    public String createTicket(
            @RequestParam String vehicleId,
            @RequestParam String slotId,
            @RequestParam String vehicleNumber,
            RedirectAttributes ra) {
        Ticket ticket = ticketService.generateTicket(
            vehicleId, slotId, vehicleNumber);
        ra.addFlashAttribute("successMsg",
            "Ticket " + ticket.getId()
            + " generated for " + vehicleNumber);
        return "redirect:/tickets";
    }

    // READ — View single ticket details
    @GetMapping("/tickets/{id}")
    public String viewTicket(
            @PathVariable String id,
            Model model) {
        Ticket ticket = ticketService.findById(id);
        if (ticket == null) return "redirect:/tickets";
        model.addAttribute("ticket", ticket);
        model.addAttribute("pageTitle",
            "Ticket Details");
        return "tickets/ticket-detail";
    }

    // UPDATE — Show edit slot form
    @GetMapping("/tickets/{id}/edit")
    public String showEditForm(
            @PathVariable String id,
            Model model) {
        Ticket ticket = ticketService.findById(id);
        if (ticket == null) return "redirect:/tickets";
        model.addAttribute("ticket", ticket);
        model.addAttribute("pageTitle",
            "Reassign Slot");
        return "tickets/edit-ticket";
    }

    // UPDATE — Process slot reassignment
    @PostMapping("/tickets/{id}/update")
    public String updateTicket(
            @PathVariable String id,
            @RequestParam String newSlotId,
            RedirectAttributes ra) {
        boolean ok = ticketService.updateTicketSlot(
            id, newSlotId);
        if (ok) {
            ra.addFlashAttribute("successMsg",
                "Slot updated successfully!");
        } else {
            ra.addFlashAttribute("errorMsg",
                "Could not update ticket.");
        }
        return "redirect:/tickets";
    }

    // DELETE — Void a ticket
    @PostMapping("/tickets/{id}/void")
    public String voidTicket(
            @PathVariable String id,
            RedirectAttributes ra) {
        boolean ok = ticketService.voidTicket(id);
        if (ok) {
            ra.addFlashAttribute("successMsg",
                "Ticket voided successfully!");
        } else {
            ra.addFlashAttribute("errorMsg",
                "Could not void ticket.");
        }
        return "redirect:/tickets";
    }
}
