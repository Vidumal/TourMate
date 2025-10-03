package com.example.demo.controller;

import com.example.demo.model.*;
import com.example.demo.service.*;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;

import java.io.ByteArrayOutputStream;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import com.example.demo.model.TravelPackage;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.time.LocalDateTime;
import java.util.stream.Collectors;

import jakarta.validation.Valid;
import org.springframework.validation.BindingResult;

/**
 * Controller that handles all admin-related pages and operations.
 * Only users with ADMIN role can access these endpoints.
 */
@Controller
@RequestMapping("/admin") // All URLs start with /admin
public class AdminController {

    // Automatically inject service classes to interact with database
    @Autowired
    private PackageService packageService; // Handles travel package operations

    @Autowired
    private UserService userService; // Handles user operations

    @Autowired
    private TicketService ticketService; // Handles support ticket operations

    @Autowired
    private AgencyService agencyService; // Handles travel agency operations

    @Autowired
    private BookingService bookingService; // Handles booking operations

    @Autowired
    private TravelPackageService travelPackageService; // Handles travel package CRUD

    // ================ DASHBOARD ================

    /**
     * Shows the admin dashboard page with statistics and new ticket notifications.
     * URL: /admin/dashboard
     */
    @GetMapping("/dashboard")
    public String adminDashboard(HttpSession session, Model model) {
        // Get the logged-in user from session
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        // Check if user is admin, otherwise redirect to login
        if (loggedInUser == null || !"ADMIN".equalsIgnoreCase(loggedInUser.getRole())) {
            return "redirect:/users/login?error=unauthorized";
        }

        // Get all users and add statistics to the page
        List<User> allUsers = userService.getAllUsers();
        model.addAttribute("totalUsers", allUsers.size());
        model.addAttribute("adminUser", loggedInUser);

        // ✅ Check for new tickets in last 5 minutes
        try {
            long newTicketCount = ticketService.getNewTicketsCount(5); // Last 5 minutes
            List<Ticket> newTickets = ticketService.getRecentTickets(5);

            model.addAttribute("newTicketCount", newTicketCount);
            model.addAttribute("newTickets", newTickets);
            model.addAttribute("showNotification", newTicketCount > 0);

            System.out.println("New tickets found: " + newTicketCount);
        } catch (Exception e) {
            System.err.println("Error checking new tickets: " + e.getMessage());
            model.addAttribute("showNotification", false);
            model.addAttribute("newTicketCount", 0);
        }

        return "admin-dashboard";
    }

    // ================ USER MANAGEMENT ================

    /**
     * Shows the user management page with list of all users.
     * URL: /admin/users
     */
    @GetMapping("/users")
    public String manageUsers(HttpSession session, Model model) {
        // Check if user is admin
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null || !"ADMIN".equalsIgnoreCase(loggedInUser.getRole())) {
            return "redirect:/users/login?error=unauthorized";
        }

        // Get all users and add to page
        List<User> allUsers = userService.getAllUsers();
        model.addAttribute("users", allUsers);
        return "admin-users"; // Show admin-users.jsp page
    }

    /**
     * Shows the create new user form.
     * URL: /admin/users/create
     */
    @GetMapping("/users/create")
    public String showCreateUserForm(HttpSession session, Model model) {
        // Check if user is admin
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null || !"ADMIN".equalsIgnoreCase(loggedInUser.getRole())) {
            return "redirect:/users/login?error=unauthorized";
        }
        return "admin-user-create"; // Show admin-user-create.jsp page
    }

    /**
     * Creates a new user.
     * URL: POST /admin/users/create
     */
    @PostMapping("/users/create")
    public String createUser(HttpSession session,
                             @RequestParam String username,
                             @RequestParam String firstName,
                             @RequestParam String lastName,
                             @RequestParam String email,
                             @RequestParam String password,
                             @RequestParam(required = false) Integer age,
                             @RequestParam(required = false) String country,
                             @RequestParam(required = false) String gender,
                             @RequestParam(required = false) String address,
                             RedirectAttributes redirectAttributes) {
        // Check if user is admin
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null || !"ADMIN".equalsIgnoreCase(loggedInUser.getRole())) {
            return "redirect:/users/login?error=unauthorized";
        }

        try {
            // Check if required fields are filled
            if (username == null || username.isBlank() ||
                    firstName == null || firstName.isBlank() ||
                    lastName == null || lastName.isBlank() ||
                    email == null || email.isBlank() ||
                    password == null || password.isBlank()) {
                redirectAttributes.addFlashAttribute("error", "Required fields must be filled.");
                return "redirect:/admin/users/create";
            }

            // Check if username already exists
            if (userService.existsByUsername(username)) {
                redirectAttributes.addFlashAttribute("error", "Username already exists.");
                return "redirect:/admin/users/create";
            }

            // Check if email already exists
            if (userService.existsByEmail(email)) {
                redirectAttributes.addFlashAttribute("error", "Email already exists.");
                return "redirect:/admin/users/create";
            }

            // Create new user object with form data
            User newUser = new User();
            newUser.setUsername(username);
            newUser.setFirstName(firstName);
            newUser.setLastName(lastName);
            newUser.setEmail(email);
            newUser.setPassword(password); // Password will be hashed in service
            newUser.setAge(age);
            newUser.setCountry(country);
            newUser.setGender(gender);
            newUser.setAddress(address);
            newUser.setRole("USER"); // Default role
            newUser.setCreatedAt(LocalDateTime.now());
            newUser.setActive(true);

            // Save user to database
            userService.saveUser(newUser);

            // Redirect with success message
            redirectAttributes.addFlashAttribute("success", "User created successfully!");
            return "redirect:/admin/users";

        } catch (Exception e) {
            // If error, show error message
            redirectAttributes.addFlashAttribute("error", "Failed to create user: " + e.getMessage());
            return "redirect:/admin/users/create";
        }
    }

    /**
     * Shows the edit form for a specific user.
     * URL: /admin/users/{id}/edit
     */
    @GetMapping("/users/{id}/edit")
    public String editUserForm(@PathVariable Long id, Model model) {
        try {
            // Get user by ID and show edit form
            User user = userService.getUserById(id);
            model.addAttribute("user", user);
            return "admin-user-edit"; // Show admin-user-edit.jsp page
        } catch (Exception e) {
            // If user not found, redirect with error
            return "redirect:/admin/users?error=User not found";
        }
    }

    /**
     * Saves the updated user information.
     * URL: POST /admin/users/{id}/edit
     */
    @PostMapping("/users/{id}/edit")
    public String updateUser(@PathVariable Long id,
                             @RequestParam Map<String, Object> updates,
                             RedirectAttributes redirectAttributes) {
        try {
            // Update user and redirect with success message
            userService.updateUser(id, updates);
            redirectAttributes.addAttribute("success", "User updated successfully");
            return "redirect:/admin/users";
        } catch (Exception e) {
            // If error, redirect back to edit form with error message
            redirectAttributes.addAttribute("error", e.getMessage());
            return "redirect:/admin/users/" + id + "/edit";
        }
    }

    /**
     * Deletes a user by ID.
     * URL: POST /admin/users/{id}/delete
     */
    @PostMapping("/users/{id}/delete")
    public String deleteUser(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            // Delete user and show success message
            userService.deleteUser(id);
            redirectAttributes.addAttribute("success", "User deleted successfully");
            return "redirect:/admin/users";
        } catch (Exception e) {
            // If error, show error message
            redirectAttributes.addAttribute("error", "Failed to delete user: " + e.getMessage());
            return "redirect:/admin/users";
        }
    }

    /**
     * Gets user details as JSON (for AJAX requests).
     * URL: /admin/users/{id}
     */
    @GetMapping("/users/{id}")
    @ResponseBody
    public ResponseEntity<User> getUserDetails(@PathVariable Long id) {
        try {
            // Return user data as JSON
            User user = userService.getUserById(id);
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            // Return 404 if user not found
            return ResponseEntity.notFound().build();
        }
    }

    // ================ PACKAGE MANAGEMENT ================

    /**
     * Shows the package management page with statistics.
     * URL: /admin/packages
     */
    @GetMapping("/packages")
    public String managePackages(HttpSession session, Model model) {
        // Check if user is admin
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null || !"ADMIN".equalsIgnoreCase(loggedInUser.getRole())) {
            return "redirect:/users/login?error=unauthorized";
        }

        // Get all packages and statistics
        List<TravelPackage> packages = packageService.getAllPackages();
        model.addAttribute("packages", packages);
        model.addAttribute("totalPackagesCount", packageService.getTotalPackagesCount());
        model.addAttribute("activePackagesCount", packageService.getActivePackagesCount());
        model.addAttribute("inactivePackagesCount", packageService.getInactivePackagesCount());
        model.addAttribute("featuredPackagesCount", packageService.getFeaturedPackagesCount());

        return "shared-packages"; // Show shared-packages.jsp page
    }

    /**
     * Shows details about a specific package.
     * URL: /admin/packages/{id}
     */
    @GetMapping("/packages/{id}")
    public String viewPackage(@PathVariable Long id, Model model) {
        // Get package by ID and show details page
        TravelPackage pkg = packageService.getPackageById(id);
        model.addAttribute("pkg", pkg);
        return "package-details"; // Show package-details.jsp page
    }

    /**
     * Shows the form to create a new travel package.
     * URL: /admin/packages/create
     */
    @GetMapping("/packages/create")
    public String showAdminCreatePackageForm(Model model) {
        // Add empty package object and list of agencies to form
        model.addAttribute("package", new TravelPackage());
        model.addAttribute("agencies", agencyService.getAllAgencies());
        model.addAttribute("viewType", "admin");
        return "shared-package-create"; // Show shared-package-create.jsp page
    }

    /**
     * Saves a new or updated travel package.
     * URL: POST /admin/packages/save
     */
    @PostMapping("/packages/save")
    public String saveAdminPackage(@Valid @ModelAttribute TravelPackage pkg,
                                   BindingResult result,
                                   RedirectAttributes redirectAttrs,
                                   Model model) {
        // Check if form has errors
        if (result.hasErrors()) {
            // If errors, show form again with error messages
            model.addAttribute("agencies", agencyService.getAllAgencies());
            model.addAttribute("viewType", "admin");
            return "createOrEditPackage";
        }

        // Save package to database
        travelPackageService.savePackage(pkg);
        redirectAttrs.addFlashAttribute("success", "Package saved successfully!");
        return "redirect:/admin/packages";
    }

    // ================ BOOKING MANAGEMENT ================

    /**
     * Shows the booking management page.
     * URL: /admin/bookings
     */
    @GetMapping("/bookings")
    public String manageBookings(HttpSession session, Model model) {
        // Check if user is admin
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null || !"ADMIN".equalsIgnoreCase(loggedInUser.getRole())) {
            return "redirect:/users/login?error=unauthorized";
        }
        // Show bookings page (can add booking list here later)
        return "admin-bookings"; // Show admin-bookings.jsp page
    }

    /**
     * Exports all bookings to a CSV file for download.
     * URL: /admin/bookings/export
     */
    @GetMapping("/bookings/export")
    public ResponseEntity<byte[]> exportBookingsCsv() {
        try {
            // Get all bookings from database
            List<Booking> bookings = bookingService.getAllBookings();

            // Create a memory stream to write CSV data
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            PrintWriter writer = new PrintWriter(baos, true, StandardCharsets.UTF_8);

            // Write CSV header row
            writer.println("Booking ID,User Name,User Email,Package Title,Booking Date,Status,Amount");

            // Write each booking as a CSV row
            for (Booking booking : bookings) {
                String row = String.format("%d,%s,%s,%s,%s,%s,%.2f",
                        booking.getId(),
                        booking.getUser().getFullName(),
                        booking.getUser().getEmail(),
                        booking.getTravelPackage().getTitle(),
                        booking.getBookingDate().toString(),
                        booking.getBookingStatus(),
                        booking.getTotalAmount());
                writer.println(row);
            }

            // Finalize CSV content
            writer.flush();
            byte[] csvBytes = baos.toByteArray();

            // Set headers to tell browser to download as CSV file
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.parseMediaType("text/csv"));
            headers.set(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=bookings.csv");

            // Return CSV file as response
            return ResponseEntity.ok()
                    .headers(headers)
                    .body(csvBytes);

        } catch (Exception e) {
            // If error, print error and return error response
            e.printStackTrace();
            return ResponseEntity.status(500).body(null);
        }
    }

    // ================ REPORTS ================

    /**
     * Shows reports and analytics page.
     * URL: /admin/reports
     */
    @GetMapping("/reports")
    public String viewReports(HttpSession session, Model model) {
        // Check if user is admin
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null || !"ADMIN".equalsIgnoreCase(loggedInUser.getRole())) {
            return "redirect:/users/login?error=unauthorized";
        }
        return "admin-reports"; // Show admin-reports.jsp page
    }

    // ================ TICKET MANAGEMENT ================

    /**
     * Shows all support tickets with filters and statistics.
     * URL: /admin/tickets
     */
    @GetMapping("/tickets")
    public String showAllTickets(HttpSession session, Model model,
                                 @RequestParam(defaultValue = "") String search,
                                 @RequestParam(defaultValue = "all") String status,
                                 @RequestParam(defaultValue = "all") String priority) {
        try {
            // Check if user is admin
            User loggedUser = (User) session.getAttribute("loggedInUser");
            if (loggedUser == null || !"ADMIN".equalsIgnoreCase(loggedUser.getRole())) {
                return "redirect:/users/login?error=Admin access required";
            }

            // Get all tickets with filters applied
            List<Ticket> tickets = ticketService.getAllTicketsWithFilters(search, status, priority);

            // Count tickets by status
            Map<String, Long> statusCounts = tickets.stream()
                    .filter(ticket -> ticket.getStatus() != null)
                    .collect(Collectors.groupingBy(Ticket::getStatus, Collectors.counting()));

            // Count tickets by priority
            Map<String, Long> priorityCounts = tickets.stream()
                    .filter(ticket -> ticket.getPriority() != null)
                    .collect(Collectors.groupingBy(Ticket::getPriority, Collectors.counting()));

            // Add all data to page
            model.addAttribute("tickets", tickets);
            model.addAttribute("totalTickets", tickets.size());
            model.addAttribute("openCount", statusCounts.getOrDefault("OPEN", 0L));
            model.addAttribute("inProgressCount", statusCounts.getOrDefault("IN_PROGRESS", 0L));
            model.addAttribute("solvedCount", statusCounts.getOrDefault("SOLVED", 0L));
            model.addAttribute("closedCount", statusCounts.getOrDefault("CLOSED", 0L));
            model.addAttribute("urgentCount", priorityCounts.getOrDefault("URGENT", 0L));
            model.addAttribute("highCount", priorityCounts.getOrDefault("HIGH", 0L));
            model.addAttribute("mediumCount", priorityCounts.getOrDefault("MEDIUM", 0L));
            model.addAttribute("lowCount", priorityCounts.getOrDefault("LOW", 0L));
            model.addAttribute("searchQuery", search);
            model.addAttribute("statusFilter", status);
            model.addAttribute("priorityFilter", priority);
            model.addAttribute("user", loggedUser);
            model.addAttribute("userType", "ADMIN"); // ✅ ADD THIS LINE!

            return "admin-tickets";

        } catch (Exception e) {
            System.err.println("Error loading admin tickets: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/admin/dashboard?error=tickets_load_failed";
        }
    }


    /**
     * Shows the ticket details page.
     * URL: /admin/tickets/{id}
     */
    @GetMapping("/tickets/{id}")
    public String viewTicketDetails(@PathVariable Long id, HttpSession session, Model model) {
        User loggedUser = (User) session.getAttribute("loggedInUser");

        if (loggedUser == null || !"ADMIN".equalsIgnoreCase(loggedUser.getRole())) {
            return "redirect:/users/login?error=unauthorized";
        }

        try {
            Optional<Ticket> ticketOpt = ticketService.getTicketById(id);
            if (ticketOpt.isEmpty()) {
                return "redirect:/admin/tickets?error=Ticket not found";
            }

            model.addAttribute("ticket", ticketOpt.get());
            model.addAttribute("user", loggedUser);
            model.addAttribute("userType", "ADMIN");

            return "ticket-details"; // Show ticket-details.jsp page

        } catch (Exception e) {
            System.err.println("Error viewing ticket: " + e.getMessage());
            return "redirect:/admin/tickets?error=Unable to load ticket";
        }
    }

    /**
     * Shows the reply form for a ticket.
     * URL: /admin/tickets/{id}/reply
     */
    @GetMapping("/tickets/{id}/reply")
    public String showReplyForm(@PathVariable Long id, HttpSession session, Model model) {
        User loggedUser = (User) session.getAttribute("loggedInUser");

        if (loggedUser == null || !"ADMIN".equalsIgnoreCase(loggedUser.getRole())) {
            return "redirect:/users/login?error=unauthorized";
        }

        try {
            Optional<Ticket> ticketOpt = ticketService.getTicketById(id);
            if (ticketOpt.isEmpty()) {
                return "redirect:/admin/tickets?error=Ticket not found";
            }

            Ticket ticket = ticketOpt.get();
            model.addAttribute("ticket", ticket);
            model.addAttribute("user", loggedUser);

            return "ticket-reply"; // ✅ Shared JSP for both admin and agency

        } catch (Exception e) {
            System.err.println("Error loading reply form: " + e.getMessage());
            return "redirect:/admin/tickets?error=Unable to load form";
        }
    }

    /**
     * Processes the reply submission.
     * Saves reply to admin_reply column in tickets table.
     * URL: POST /admin/tickets/reply/{id}
     */
    @PostMapping("/tickets/reply/{id}")
    public String submitReply(@PathVariable Long id,
                              @RequestParam(required = false) String reply,
                              @RequestParam(required = false) String status,  //  ADD THIS!
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {

        // ✅ ADD DEBUG LOGGING
        System.out.println("========================================");
        System.out.println("=== ADMIN SUBMIT REPLY DEBUG INFO ===");
        System.out.println("========================================");
        System.out.println("Ticket ID: " + id);
        System.out.println("Reply Length: " + (reply != null ? reply.length() : "NULL"));
        System.out.println("Status: " + status);
        System.out.println("Session ID: " + session.getId());

        User loggedUser = (User) session.getAttribute("loggedInUser");

        System.out.println("Logged User: " + (loggedUser != null ? loggedUser.getUsername() : " NULL"));
        System.out.println("User Role: " + (loggedUser != null ? loggedUser.getRole() : " NULL"));
        System.out.println("========================================");

        if (loggedUser == null) {
            System.err.println(" ERROR: Session lost! User is NULL");
            redirectAttributes.addFlashAttribute("error", "Session expired. Please login again.");
            return "redirect:/users/login?error=session_expired";
        }

        if (!"ADMIN".equalsIgnoreCase(loggedUser.getRole())) {
            System.err.println(" ERROR: User is not ADMIN");
            return "redirect:/users/login?error=unauthorized";
        }

        System.out.println(" Authorization check passed!");

        try {
            // Validation
            if (reply == null || reply.trim().length() < 10) {
                System.err.println(" Validation failed: Reply too short");
                redirectAttributes.addFlashAttribute("error", "Reply must be at least 10 characters long.");
                return "redirect:/admin/tickets/" + id + "/reply";
            }

            if (reply.trim().length() > 2000) {
                System.err.println(" Validation failed: Reply too long");
                redirectAttributes.addFlashAttribute("error", "Reply must not exceed 2000 characters.");
                return "redirect:/admin/tickets/" + id + "/reply";
            }

            System.out.println(" Validation passed!");

            // Get ticket
            Optional<Ticket> ticketOpt = ticketService.getTicketById(id);
            if (ticketOpt.isEmpty()) {
                System.err.println(" Ticket not found with ID: " + id);
                redirectAttributes.addFlashAttribute("error", "Ticket not found.");
                return "redirect:/admin/tickets";
            }

            Ticket ticket = ticketOpt.get();
            System.out.println(" Ticket found: " + ticket.getSubject());

            // ✅ Save admin reply
            ticket.setAdminReply(reply.trim());

            // ✅ Update status
            ticket.setStatus(status != null ? status.toUpperCase() : "IN_PROGRESS");

            ticket.setUpdatedAt(LocalDateTime.now());

            System.out.println("Saving ticket with admin reply and status: " + status);
            ticketService.saveTicket(ticket);
            System.out.println(" Ticket saved successfully!");

            redirectAttributes.addFlashAttribute("success",
                    "Reply sent and ticket status updated to " + status + " successfully!");

            System.out.println(" Redirecting to /admin/tickets");
            System.out.println("========================================");
            return "redirect:/admin/tickets";

        } catch (Exception e) {
            System.err.println(" EXCEPTION occurred:");
            System.err.println("Error submitting reply: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Failed to send reply. Please try again.");
            return "redirect:/admin/tickets/" + id + "/reply";
        }
    }

    /**
     * Updates ticket status.
     * URL: POST /admin/tickets/{id}/status
     */
    @PostMapping("/tickets/{id}/status")
    public String updateTicketStatus(@PathVariable Long id,
                                     @RequestParam String status,
                                     HttpSession session,
                                     RedirectAttributes redirectAttributes) {
        User loggedUser = (User) session.getAttribute("loggedInUser");

        if (loggedUser == null || !"ADMIN".equalsIgnoreCase(loggedUser.getRole())) {
            return "redirect:/users/login?error=unauthorized";
        }

        try {
            Optional<Ticket> ticketOpt = ticketService.getTicketById(id);
            if (ticketOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Ticket not found.");
                return "redirect:/admin/tickets";
            }

            Ticket ticket = ticketOpt.get();
            ticket.setStatus(status);
            ticket.setUpdatedAt(LocalDateTime.now());
            ticketService.saveTicket(ticket);

            redirectAttributes.addFlashAttribute("success", "Ticket status updated to " + status + " successfully!");
            return "redirect:/admin/tickets/" + id + "/reply";

        } catch (Exception e) {
            System.err.println("Error updating ticket status: " + e.getMessage());
            redirectAttributes.addFlashAttribute("error", "Failed to update ticket status.");
            return "redirect:/admin/tickets";
        }
    }

    /**
     * Marks ticket as resolved.
     * URL: POST /admin/tickets/{id}/resolve
     */
    @PostMapping("/tickets/{id}/resolve")
    public String resolveTicket(@PathVariable Long id,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User loggedUser = (User) session.getAttribute("loggedInUser");

        if (loggedUser == null || !"ADMIN".equalsIgnoreCase(loggedUser.getRole())) {
            return "redirect:/users/login?error=unauthorized";
        }

        try {
            Optional<Ticket> ticketOpt = ticketService.getTicketById(id);
            if (ticketOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Ticket not found.");
                return "redirect:/admin/tickets";
            }

            Ticket ticket = ticketOpt.get();
            ticket.setStatus("SOLVED");
            ticket.setUpdatedAt(LocalDateTime.now());
            ticketService.saveTicket(ticket);

            redirectAttributes.addFlashAttribute("success", "Ticket marked as resolved successfully!");
            return "redirect:/admin/tickets";

        } catch (Exception e) {
            System.err.println("Error resolving ticket: " + e.getMessage());
            redirectAttributes.addFlashAttribute("error", "Failed to resolve ticket.");
            return "redirect:/admin/tickets";
        }
    }

    /**
     * Closes a ticket.
     * URL: POST /admin/tickets/{id}/close
     */
    @PostMapping("/tickets/{id}/close")
    public String closeTicket(@PathVariable Long id,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User loggedUser = (User) session.getAttribute("loggedInUser");

        if (loggedUser == null || !"ADMIN".equalsIgnoreCase(loggedUser.getRole())) {
            return "redirect:/users/login?error=unauthorized";
        }

        try {
            Optional<Ticket> ticketOpt = ticketService.getTicketById(id);
            if (ticketOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Ticket not found.");
                return "redirect:/admin/tickets";
            }

            Ticket ticket = ticketOpt.get();
            ticket.setStatus("CLOSED");
            ticket.setUpdatedAt(LocalDateTime.now());
            ticketService.saveTicket(ticket);

            redirectAttributes.addFlashAttribute("success", "Ticket closed successfully!");
            return "redirect:/admin/tickets";

        } catch (Exception e) {
            System.err.println("Error closing ticket: " + e.getMessage());
            redirectAttributes.addFlashAttribute("error", "Failed to close ticket.");
            return "redirect:/admin/tickets";
        }
    }
}
