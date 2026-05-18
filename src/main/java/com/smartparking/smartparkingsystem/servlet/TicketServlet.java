package com.smartparking.smartparkingsystem.servlet;

import com.smartparking.smartparkingsystem.model.Ticket;
import com.smartparking.smartparkingsystem.model.User;
import com.smartparking.smartparkingsystem.service.AdminService;
import com.smartparking.smartparkingsystem.service.TicketService;
import jakarta.servlet.http.HttpSession;
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

    private AdminService adminService = new AdminService();

    // READ — List all tickets — ADMIN ONLY
    @GetMapping("/tickets")
    public String listTickets(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/login";
        if (!"ADMIN".equals(user.getRole())) return "redirect:/home";

        List<Ticket> active = ticketService.getActiveTickets();
        List<Ticket> all    = ticketService.getAllTickets();
        model.addAttribute("tickets",      active);
        model.addAttribute("activeCount",  active.size());
        model.addAttribute("totalCount",   all.size());
        model.addAttribute("voidedCount",  all.stream()
                .filter(t -> "VOIDED".equals(t.getStatus())).count());
        return "tickets/ticket-list";
    }

    // CREATE — Show generate ticket form
    @GetMapping("/tickets/new")
    public String showCreateForm(
            @RequestParam(required = false) String vehicleId,
            @RequestParam(required = false) String slotId,
            @RequestParam(required = false) String slotNumber,
            @RequestParam(required = false) String vehicleNumber,
            @RequestParam(required = false) String ownerName,
            @RequestParam(required = false) String date,
            Model model) {

        model.addAttribute("vehicleId",     vehicleId);
        model.addAttribute("slotId",        slotId);
        model.addAttribute("slotNumber",    slotNumber);
        model.addAttribute("vehicleNumber", vehicleNumber);
        model.addAttribute("ownerName",     ownerName);
        model.addAttribute("date",          date);
        model.addAttribute("pageTitle",     "Generate Ticket");

        // Load rates from config
        model.addAttribute("bikeRate",         (int) adminService.getRateByType("BIKE"));
        model.addAttribute("threeWheelerRate", (int) adminService.getRateByType("THREE_WHEELER"));
        model.addAttribute("carRate",          (int) adminService.getRateByType("CAR"));
        model.addAttribute("vanRate",          (int) adminService.getRateByType("VAN"));
        model.addAttribute("vipRate",          (int) adminService.getRateByType("VIP"));

        return "tickets/ticket-form";
    }

    // CREATE — Process generate ticket form
    @PostMapping("/tickets/create")
    public String createTicket(
            @RequestParam String vehicleId,
            @RequestParam(required = false) String slotId,
            @RequestParam(required = false) String slotNumber,
            @RequestParam String vehicleNumber,
            @RequestParam(required = false) String vehicleType,
            @RequestParam(required = false) String ownerName,
            @RequestParam(required = false) String hours,
            @RequestParam(required = false) String totalAmount,
            @RequestParam(required = false) String date,
            RedirectAttributes ra) {

        Ticket ticket = ticketService.generateTicket(vehicleId, slotId, vehicleNumber);

        return "redirect:/payment/create"
                + "?ticketId="      + ticket.getId()
                + "&vehicleId="     + vehicleId
                + "&ownerName="     + (ownerName != null ? ownerName : "")
                + "&vehicleNumber=" + vehicleNumber
                + "&vehicleType="   + (vehicleType != null ? vehicleType : "")
                + "&slotNumber="    + (slotNumber != null ? slotNumber : "")
                + "&slotId="        + (slotId != null ? slotId : "")
                + "&hours="         + (hours != null ? hours : "")
                + "&totalAmount="   + (totalAmount != null ? totalAmount : "")
                + "&date="          + (date != null ? date : "");
    }

    // READ — View single ticket
    @GetMapping("/tickets/{id}")
    public String viewTicket(@PathVariable String id, Model model) {
        Ticket ticket = ticketService.findById(id);
        if (ticket == null) return "redirect:/tickets";
        model.addAttribute("ticket", ticket);
        model.addAttribute("pageTitle", "Ticket Details");
        return "tickets/ticket-detail";
    }

    // UPDATE — Show edit slot form
    @GetMapping("/tickets/{id}/edit")
    public String showEditForm(@PathVariable String id, Model model) {
        Ticket ticket = ticketService.findById(id);
        if (ticket == null) return "redirect:/tickets";
        model.addAttribute("ticket", ticket);
        model.addAttribute("pageTitle", "Reassign Slot");
        return "tickets/edit-ticket";
    }

    // UPDATE — Process slot reassignment
    @PostMapping("/tickets/{id}/update")
    public String updateTicket(@PathVariable String id,
                               @RequestParam String newSlotId,
                               RedirectAttributes ra) {
        boolean ok = ticketService.updateTicketSlot(id, newSlotId);
        if (ok) {
            ra.addFlashAttribute("successMsg", "Slot updated successfully!");
        } else {
            ra.addFlashAttribute("errorMsg", "Could not update ticket.");
        }
        return "redirect:/tickets";
    }

    // DELETE — Void a ticket
    @PostMapping("/tickets/{id}/void")
    public String voidTicket(@PathVariable String id, RedirectAttributes ra) {
        boolean ok = ticketService.voidTicket(id);
        if (ok) {
            ra.addFlashAttribute("successMsg", "Ticket voided successfully!");
        } else {
            ra.addFlashAttribute("errorMsg", "Could not void ticket.");
        }
        return "redirect:/tickets";
    }
}
