package com.smartparking.smartparkingsystem.servlet;

import com.smartparking.smartparkingsystem.model.User;
import com.smartparking.smartparkingsystem.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

/**
 * UserController - MVC Controller for User Profile Management
 * Author: Nadin P.G.K | IT25101876
 */
@Controller
public class UserServlet {

    @Autowired
    private UserService userService;

    // ─── Root ─────────────────────────────────────────────────
    @GetMapping("/")
    public String root() {
        return "redirect:/login";
    }

    // ─── LOGIN ────────────────────────────────────────────────
    @GetMapping("/login")
    public String loginPage(HttpSession session) {
        if (session.getAttribute("loggedInUser") != null)
            return "redirect:/home";
        return "user/login";
    }

    @PostMapping("/login")
    public String loginSubmit(@RequestParam String email,
                              @RequestParam String password,
                              HttpSession session,
                              RedirectAttributes ra) {
        Optional<User> opt = userService.login(email, password);
        if (opt.isPresent()) {
            User user = opt.get();
            session.setAttribute("loggedInUser", user);

            // Redirect based on role
            if ("ADMIN".equals(user.getRole())) {
                return "redirect:/admin/dashboard";
            } else {
                return "redirect:/home";
            }
        }
        ra.addFlashAttribute("error",
                "Invalid email or password. Please try again.");
        return "redirect:/login";
    }

    // ─── REGISTER ─────────────────────────────────────────────
    @GetMapping("/register")
    public String registerPage(HttpSession session) {
        if (session.getAttribute("loggedInUser") != null)
            return "redirect:/home";
        return "user/register";
    }

    @PostMapping("/register")
    public String registerSubmit(@RequestParam String name,
                                 @RequestParam String email,
                                 @RequestParam String password,
                                 @RequestParam String phone,
                                 RedirectAttributes ra) {
        String result = userService.registerUser(
                name, email, password, phone);
        switch (result) {
            case "success":
                ra.addFlashAttribute("success",
                        "Account created successfully! Please log in.");
                return "redirect:/login";
            case "email_exists":
                ra.addFlashAttribute("error",
                        "An account with that email already exists.");
                return "redirect:/register";
            default:
                ra.addFlashAttribute("error",
                        "Registration failed. Please try again.");
                return "redirect:/register";
        }
    }

    // ─── HOME ─────────────────────────────────────────────────
    @GetMapping("/home")
    public String homePage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/login";
        // Admin should not access customer home
        if ("ADMIN".equals(user.getRole()))
            return "redirect:/admin/dashboard";
        model.addAttribute("user", user);
        return "user/home";
    }

    // ─── PROFILE ──────────────────────────────────────────────
    @GetMapping("/profile")
    public String profilePage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/login";
        userService.getUserById(user.getId()).ifPresent(u -> {
            session.setAttribute("loggedInUser", u);
            model.addAttribute("user", u);
        });
        if (model.getAttribute("user") == null)
            model.addAttribute("user", user);
        return "user/profile";
    }

    @PostMapping("/profile/update-password")
    public String updatePassword(@RequestParam String oldPassword,
                                 @RequestParam String newPassword,
                                 @RequestParam String confirmPassword,
                                 HttpSession session,
                                 RedirectAttributes ra) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/login";

        if (!newPassword.equals(confirmPassword)) {
            ra.addFlashAttribute("pwError", "New passwords do not match.");
            return "redirect:/profile";
        }
        if (newPassword.length() < 6) {
            ra.addFlashAttribute("pwError", "Password must be at least 6 characters.");
            return "redirect:/profile";
        }

        String result = userService.changePassword(
                user.getId(), oldPassword, newPassword);
        switch (result) {
            case "success":
                user.setPassword(newPassword);
                session.setAttribute("loggedInUser", user);
                ra.addFlashAttribute("pwSuccess", "Password updated successfully.");
                break;
            case "wrong_password":
                ra.addFlashAttribute("pwError", "Current password is incorrect.");
                break;
            default:
                ra.addFlashAttribute("pwError", "Update failed. Please try again.");
        }
        return "redirect:/profile";
    }

    @PostMapping("/profile/update-phone")
    public String updatePhone(@RequestParam String phone,
                              HttpSession session,
                              RedirectAttributes ra) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/login";

        String result = userService.updatePhone(user.getId(), phone);
        if ("success".equals(result)) {
            user.setPhone(phone);
            session.setAttribute("loggedInUser", user);
            ra.addFlashAttribute("phoneSuccess", "Contact number updated.");
        } else {
            ra.addFlashAttribute("phoneError", "Update failed. Please try again.");
        }
        return "redirect:/profile";
    }

    @PostMapping("/profile/delete")
    public String deleteOwnAccount(HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/login";

        String result = userService.deleteUser(user.getId());
        if ("success".equals(result)) {
            session.invalidate();
            ra.addFlashAttribute("success", "Your account has been deleted.");
            return "redirect:/login";
        }
        ra.addFlashAttribute("deleteError", "Could not delete account. Try again.");
        return "redirect:/profile";
    }

    // ─── ADMIN ────────────────────────────────────────────────
    @GetMapping("/admin/users")
    public String adminUsers(HttpSession session, Model model) {
        User admin = (User) session.getAttribute("loggedInUser");
        if (admin == null) return "redirect:/login";
        if (!"ADMIN".equals(admin.getRole())) return "redirect:/home";
        List<User> users = userService.getAllUsers();
        model.addAttribute("users", users);
        model.addAttribute("user", admin);
        return "user/admin-users";
    }

    @PostMapping("/admin/delete")
    public String adminDeleteUser(@RequestParam String userId,
                                  HttpSession session,
                                  RedirectAttributes ra) {
        User admin = (User) session.getAttribute("loggedInUser");
        if (admin == null) return "redirect:/login";
        if (!"ADMIN".equals(admin.getRole())) return "redirect:/home";

        if (userId.equals(admin.getId())) {
            ra.addFlashAttribute("error", "You cannot delete your own admin account.");
            return "redirect:/admin/users";
        }

        String result = userService.deleteUser(userId);
        if ("success".equals(result)) {
            ra.addFlashAttribute("success", "User deleted successfully.");
        } else {
            ra.addFlashAttribute("error", "Could not delete user.");
        }
        return "redirect:/admin/users";
    }

    // ─── LOGOUT ───────────────────────────────────────────────
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
