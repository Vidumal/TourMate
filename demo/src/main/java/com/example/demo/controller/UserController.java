package com.example.demo.controller;

import com.example.demo.model.Payment;
import com.example.demo.model.Ticket;
import com.example.demo.service.PaymentService;
import com.example.demo.service.TicketService;
import com.example.demo.util.PdfGeneratorUtil;
import com.lowagie.text.DocumentException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

public class UserController {
    package com.example.demo.controller;

import com.example.demo.model.Payment;
import com.example.demo.model.User;
import com.example.demo.model.Ticket;
import com.example.demo.service.PaymentService;
import com.example.demo.service.UserService;
import com.example.demo.service.TicketService;
import com.example.demo.util.PdfGeneratorUtil;
import com.lowagie.text.DocumentException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;
import java.util.Optional;
import java.util.Map;
import java.util.stream.Collectors;

    /**
     * Controller that handles all user-related operations.
     * This includes authentication (login/register/logout), profile management,
     * and support ticket functionality for regular users.
     */
    @Controller
    @RequestMapping("/users") // All URLs start with /users
    public class UserController {

        // Automatically inject service classes to interact with database
        @Autowired
        private UserService userService; // Handles user operations

        @Autowired
        private TicketService ticketService; // Handles support ticket operations

        @Autowired
        private PaymentService paymentService; // Handles payment and booking operations

        // ================ USER AUTHENTICATION METHODS ================

        /**
         * Shows the user registration form.
         * URL: GET /users/register
         */
        @GetMapping("/register")
        public String showRegisterForm() {
            return "register"; // Show register.jsp page
        }

        /**
         * Handles user registration form submission.
         * Validates input, checks for duplicate username/email, and creates new user account.
         * URL: POST /users/register
         */
        @PostMapping("/register")
        public String registerUser(
                @RequestParam String username,
                @RequestParam String email,
                @RequestParam String password,
                @RequestParam String confirmPassword,
                @RequestParam String role,
                @RequestParam(required = false) String gender,
                @RequestParam int age,
                Model model
        ) {
            // Check if passwords match
            if (!password.equals(confirmPassword)) {
                model.addAttribute("errorMessage", "Passwords do not match!");
                return "register";
            }

            // Check if username already exists
            if (userService.isUsernameTaken(username)) {
                model.addAttribute("errorMessage", "Username already exists!");
                return "register";
            }

            // Check if email already exists
            if (userService.isEmailTaken(email)) {
                model.addAttribute("errorMessage", "Email already exists!");
                return "register";
            }

            // Create new user with provided information
            User user = new User(username, password, email, age, role, gender);
            userService.registerUser(user);

            // Redirect to login page with success message
            return "redirect:/users/login?success=true";
        }

        /**
         * Shows the login form.
         * URL: GET /users/login
         */
        @GetMapping("/login")
        public String showLoginPage() {
            return "login"; // Show login.jsp page
        }

        /**
         * Handles user login form submission.
         * Authenticates user and creates session with cookies for navbar.
         * Redirects based on user role (Admin/Agency/User).
         * URL: POST /users/login
         */
        @PostMapping("/login")
        public String loginUser(
                @RequestParam String email,
                @RequestParam String password,
                HttpSession session,
                HttpServletResponse response,
                Model model
        ) {
            // Attempt to authenticate user with email and password
            Optional<User> userOptional = userService.login(email, password);

            if (userOptional.isPresent()) {
                // Login successful - store user in session
                User user = userOptional.get();
                session.setAttribute("loggedInUser", user);
                session.setAttribute("userRole", user.getRole());

                // Create cookies for navbar logic (to show/hide menu items)
                Cookie loginCookie = new Cookie("login", "true");
                loginCookie.setMaxAge(60 * 60); // Cookie expires in 1 hour
                loginCookie.setPath("/");
                response.addCookie(loginCookie);

                Cookie roleCookie = new Cookie("role", user.getRole());
                roleCookie.setMaxAge(60 * 60); // Cookie expires in 1 hour
                roleCookie.setPath("/");
                response.addCookie(roleCookie);

                // Redirect based on user role
                if ("AGENCY".equalsIgnoreCase(user.getRole())) {
                    return "redirect:/agency/dashboard"; // Agency users go to agency dashboard
                } else if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                    return "redirect:/admin/dashboard"; // Admin users go to admin dashboard
                } else {
                    return "redirect:/home"; // Regular users go to home page
                }

            } else {
                // Login failed - show error message
                model.addAttribute("errorMessage", "Invalid email or password.");
                return "login";
            }
        }

        /**
         * Handles user logout.
         * Invalidates session and clears cookies.
         * URL: GET /users/logout
         */
        @GetMapping("/logout")
        public String logoutUser(HttpSession session, HttpServletResponse response) {
            // Destroy user session
            session.invalidate();

            // Clear login cookie
            Cookie loginCookie = new Cookie("login", "false");
            loginCookie.setMaxAge(0); // Delete cookie immediately
            loginCookie.setPath("/");
            response.addCookie(loginCookie);

            // Clear role cookie
            Cookie roleCookie = new Cookie("role", "");
            roleCookie.setMaxAge(0); // Delete cookie immediately
            roleCookie.setPath("/");
            response.addCookie(roleCookie);

            // Redirect to login page with logout message
            return "redirect:/users/login?logout=true";
        }

        // ================ USER PROFILE METHODS ================

        /**
         * Shows the user profile page with booked packages and support tickets.
         * URL: GET /users/profile
         */
        @GetMapping("/profile")
        public String showProfile(HttpSession session, Model model) {
            try {
                System.out.println("UserController: Profile method called");

                // Get logged-in user from session
                User loggedInUser = (User) session.getAttribute("loggedInUser");
                System.out.println("User from session: " + (loggedInUser != null ? loggedInUser.getUsername() : "null"));

                // Check if user is logged in
                if (loggedInUser == null) {
                    System.out.println("No user in session, redirecting to login");
                    return "redirect:/users/login?error=Please login to view your profile";
                }

                // Get user's booked packages (successful payments)
                List<Payment> bookedPackages = new ArrayList<>();
                try {
                    bookedPackages = paymentService.getSuccessfulPaymentsByUser(loggedInUser.getId());
                    System.out.println("Booked packages retrieved: " + (bookedPackages != null ? bookedPackages.size() : "null"));
                } catch (Exception e) {
                    System.err.println("Error fetching booked packages: " + e.getMessage());
                    bookedPackages = new ArrayList<>();
                }

                // Get user's support tickets (limit to recent 5 for profile display)
                List<Ticket> userTickets = new ArrayList<>();
                try {
                    userTickets = ticketService.getTicketsByUser(loggedInUser.getId());
                    // Show only the 5 most recent tickets on profile
                    if (userTickets.size() > 5) {
                        userTickets = userTickets.subList(0, 5);
                    }
                } catch (Exception e) {
                    System.err.println("Error fetching user tickets: " + e.getMessage());
                    userTickets = new ArrayList<>();
                }

                // Add all data to profile page
                model.addAttribute("user", loggedInUser);
                model.addAttribute("bookedPackages", bookedPackages);
                model.addAttribute("userTickets", userTickets);

                System.out.println("Profile model attributes set successfully");
                return "profile"; // Show profile.jsp page

            } catch (Exception e) {
                // If error, print error and redirect to home
                System.err.println("Error in UserController.showProfile: " + e.getMessage());
                e.printStackTrace();
                return "redirect:/home?error=profile_load_failed";
            }
        }

        /**
         * Deletes the user's account and all related data.
         * URL: POST /users/delete
         */
        @PostMapping("/delete")
        public String deleteUserProfile(HttpSession session) {
            // Get logged-in user from session
            User loggedInUser = (User) session.getAttribute("loggedInUser");

            if (loggedInUser != null) {
                // Delete user account from database
                userService.deleteUser(loggedInUser.getId());

                // Destroy session
                session.invalidate();

                // Redirect to login with deletion confirmation
                return "redirect:/users/login?deleted=true";
            } else {
                return "redirect:/users/login";
            }
        }

        // ================ SUPPORT TICKET METHODS ================

        /**
         * Shows all support tickets created by the logged-in user.
         * Includes search, filter, and statistics functionality.
         * URL: GET /users/support-tickets
         */
        @GetMapping("/support-tickets")
        public String showSupportTickets(HttpSession session, Model model,
                                         @RequestParam(defaultValue = "") String search,
                                         @RequestParam(defaultValue = "all") String status,
                                         @RequestParam(defaultValue = "all") String priority) {
            try {
                // Get logged-in user from session
                User loggedUser = (User) session.getAttribute("loggedInUser");

                // Check if user is logged in
                if (loggedUser == null) {
                    return "redirect:/users/login?error=Please login to access support tickets";
                }

                // Get all tickets created by this user
                List<Ticket> tickets;
                try {
                    tickets = ticketService.getTicketsByUser(loggedUser.getId());
                    if (tickets == null) {
                        tickets = new ArrayList<>();
                    }
                } catch (Exception e) {
                    System.err.println("Error fetching tickets: " + e.getMessage());
                    tickets = new ArrayList<>();
                }

                // Apply search filter (search in subject and description)
                if (!search.isEmpty()) {
                    tickets = tickets.stream()
                            .filter(ticket ->
                                    ticket.getSubject() != null && ticket.getSubject().toLowerCase().contains(search.toLowerCase()) ||
                                            ticket.getDescription() != null && ticket.getDescription().toLowerCase().contains(search.toLowerCase())
                            )
                            .collect(Collectors.toList());
                }

                // Apply status filter (OPEN, IN_PROGRESS, SOLVED, CLOSED)
                if (!"all".equals(status)) {
                    tickets = tickets.stream()
                            .filter(ticket -> ticket.getStatus() != null && ticket.getStatus().equalsIgnoreCase(status))
                            .collect(Collectors.toList());
                }

                // Apply priority filter (URGENT, HIGH, MEDIUM, LOW)
                if (!"all".equals(priority)) {
                    tickets = tickets.stream()
                            .filter(ticket -> ticket.getPriority() != null && ticket.getPriority().equalsIgnoreCase(priority))
                            .collect(Collectors.toList());
                }

                // Calculate statistics - count tickets by status
                Map<String, Long> statusCounts = tickets.stream()
                        .filter(ticket -> ticket.getStatus() != null)
                        .collect(Collectors.groupingBy(Ticket::getStatus, Collectors.counting()));

                // Calculate statistics - count tickets by priority
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

                return "support-tickets"; // Show support-tickets.jsp page

            } catch (Exception e) {
                // If error, print error and redirect to profile
                System.err.println("Error loading support tickets: " + e.getMessage());
                e.printStackTrace();
                return "redirect:/users/profile?error=tickets_load_failed";
            }
        }

        /**
         * Shows the form to create a new support ticket.
         * URL: GET /users/support-tickets/create
         */
        @GetMapping("/support-tickets/create")
        public String showCreateTicketForm(HttpSession session, Model model) {
            // Get logged-in user from session
            User loggedUser = (User) session.getAttribute("loggedInUser");

            // Check if user is logged in
            if (loggedUser == null) {
                return "redirect:/users/login?error=Please login to create a support ticket";
            }

            model.addAttribute("user", loggedUser);
            return "create-support-ticket"; // Show create-support-ticket.jsp page
        }

        /**
         * Handles support ticket creation form submission.
         * Creates a new ticket with OPEN status.
         * URL: POST /users/support-tickets/create
         */
        @PostMapping("/support-tickets/create")
        public String createSupportTicket(@RequestParam String subject,
                                          @RequestParam String description,
                                          @RequestParam String priority,
                                          HttpSession session,
                                          RedirectAttributes redirectAttributes) {
            try {
                // Get logged-in user from session
                User loggedUser = (User) session.getAttribute("loggedInUser");

                if (loggedUser == null) {
                    return "redirect:/users/login";
                }

                // Create new ticket object with form data
                Ticket ticket = new Ticket();
                ticket.setSubject(subject);
                ticket.setDescription(description);
                ticket.setPriority(priority);
                ticket.setStatus("OPEN"); // New tickets start as OPEN
                ticket.setUser(loggedUser);
                ticket.setCreatedAt(LocalDateTime.now());
                ticket.setUpdatedAt(LocalDateTime.now());

                // Save ticket to database
                Ticket savedTicket = ticketService.createTicket(ticket);

                // Show success message with ticket ID
                redirectAttributes.addFlashAttribute("success",
                        "Support ticket created successfully! Ticket ID: #" + savedTicket.getId());
                return "redirect:/users/support-tickets";

            } catch (Exception e) {
                // If error, show error message
                System.err.println("Error creating support ticket: " + e.getMessage());
                e.printStackTrace();
                redirectAttributes.addFlashAttribute("error",
                        "Failed to create support ticket. Please try again.");
                return "redirect:/users/support-tickets/create";
            }
        }

        /**
         * Shows detailed information about a specific ticket.
         * Users can only view their own tickets.
         * URL: GET /users/support-tickets/{ticketId}
         */
        @GetMapping("/support-tickets/{ticketId}")
        public String viewTicketDetails(@PathVariable Long ticketId,
                                        HttpSession session,
                                        Model model) {
            try {
                // Get logged-in user from session
                User loggedUser = (User) session.getAttribute("loggedInUser");

                if (loggedUser == null) {
                    return "redirect:/users/login";
                }

                // Get ticket by ID
                Optional<Ticket> ticketOpt = ticketService.getTicketById(ticketId);

                if (ticketOpt.isEmpty()) {
                    return "redirect:/users/support-tickets?error=Ticket not found";
                }

                Ticket ticket = ticketOpt.get();

                // Check if user owns this ticket (security check)
                if (!ticket.getUser().getId().equals(loggedUser.getId())) {
                    return "redirect:/users/support-tickets?error=Access denied";
                }

                model.addAttribute("ticket", ticket);
                model.addAttribute("user", loggedUser);

                return "ticket-details"; // Show ticket-details.jsp page

            } catch (Exception e) {
                System.err.println("Error viewing ticket details: " + e.getMessage());
                e.printStackTrace();
                return "redirect:/users/support-tickets?error=Unable to load ticket";
            }
        }

        /**
         * Shows the edit form for a specific ticket.
         * Users can only edit their own OPEN tickets.
         * URL: GET /users/support-tickets/{ticketId}/edit
         */
        @GetMapping("/support-tickets/{ticketId}/edit")
        public String showEditTicketForm(@PathVariable Long ticketId,
                                         HttpSession session,
                                         Model model) {
            try {
                // Get logged-in user from session
                User loggedUser = (User) session.getAttribute("loggedInUser");

                if (loggedUser == null) {
                    return "redirect:/users/login";
                }

                // Get ticket by ID
                Optional<Ticket> ticketOpt = ticketService.getTicketById(ticketId);

                if (ticketOpt.isEmpty()) {
                    return "redirect:/users/support-tickets?error=Ticket not found";
                }

                Ticket ticket = ticketOpt.get();

                // Check ownership (security check)
                if (!ticket.getUser().getId().equals(loggedUser.getId())) {
                    return "redirect:/users/support-tickets?error=Access denied";
                }

                // Only allow editing OPEN tickets
                if (!"OPEN".equals(ticket.getStatus())) {
                    return "redirect:/users/support-tickets/" + ticketId + "?error=You can only edit open tickets";
                }

                model.addAttribute("ticket", ticket);
                model.addAttribute("user", loggedUser);

                return "edit-support-ticket"; // Show edit-support-ticket.jsp page

            } catch (Exception e) {
                System.err.println("Error loading edit form: " + e.getMessage());
                e.printStackTrace();
                return "redirect:/users/support-tickets?error=Unable to load edit form";
            }
        }

        /**
         * Handles ticket update form submission.
         * Users can only update their own OPEN tickets.
         * URL: POST /users/support-tickets/{ticketId}/update
         */
        @PostMapping("/support-tickets/{ticketId}/update")
        public String updateTicket(@PathVariable Long ticketId,
                                   @RequestParam String subject,
                                   @RequestParam String description,
                                   @RequestParam String priority,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
            try {
                // Get logged-in user from session
                User loggedUser = (User) session.getAttribute("loggedInUser");

                if (loggedUser == null) {
                    return "redirect:/users/login";
                }

                // Get ticket by ID
                Optional<Ticket> ticketOpt = ticketService.getTicketById(ticketId);
                if (ticketOpt.isEmpty()) {
                    redirectAttributes.addFlashAttribute("error", "Ticket not found");
                    return "redirect:/users/support-tickets";
                }

                Ticket ticket = ticketOpt.get();

                // Check ownership (security check)
                if (!ticket.getUser().getId().equals(loggedUser.getId())) {
                    redirectAttributes.addFlashAttribute("error", "You can only update your own tickets");
                    return "redirect:/users/support-tickets";
                }

                // Only allow updates if ticket is still OPEN
                if (!"OPEN".equals(ticket.getStatus())) {
                    redirectAttributes.addFlashAttribute("error",
                            "You can only update tickets that are still open");
                    return "redirect:/users/support-tickets/" + ticketId;
                }

                // Update ticket fields
                ticket.setSubject(subject);
                ticket.setDescription(description);
                ticket.setPriority(priority);
                ticket.setUpdatedAt(LocalDateTime.now());

                // Save updated ticket
                ticketService.saveTicket(ticket);

                redirectAttributes.addFlashAttribute("success", "Ticket updated successfully!");
                return "redirect:/users/support-tickets/" + ticketId;

            } catch (Exception e) {
                System.err.println("Error updating ticket: " + e.getMessage());
                redirectAttributes.addFlashAttribute("error", "Failed to update ticket. Please try again.");
                return "redirect:/users/support-tickets/" + ticketId;
            }
        }

        /**
         * Deletes a support ticket.
         * Users can only delete their own OPEN tickets.
         * URL: POST /users/support-tickets/{ticketId}/delete
         */
        @PostMapping("/support-tickets/{ticketId}/delete")
        public String deleteTicket(@PathVariable Long ticketId,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
            try {
                // Get logged-in user from session
                User loggedUser = (User) session.getAttribute("loggedInUser");

                if (loggedUser == null) {
                    return "redirect:/users/login";
                }

                // Get ticket by ID
                Optional<Ticket> ticketOpt = ticketService.getTicketById(ticketId);
                if (ticketOpt.isEmpty()) {
                    redirectAttributes.addFlashAttribute("error", "Ticket not found");
                    return "redirect:/users/support-tickets";
                }

                Ticket ticket = ticketOpt.get();

                // Check ownership (security check)
                if (!ticket.getUser().getId().equals(loggedUser.getId())) {
                    redirectAttributes.addFlashAttribute("error", "You can only delete your own tickets");
                    return "redirect:/users/support-tickets";
                }

                // Only allow deletion if ticket is still OPEN
                if (!"OPEN".equals(ticket.getStatus())) {
                    redirectAttributes.addFlashAttribute("error",
                            "You can only delete tickets that are still open");
                    return "redirect:/users/support-tickets";
                }

                // Delete ticket from database
                ticketService.deleteTicket(ticketId);

                redirectAttributes.addFlashAttribute("success", "Ticket deleted successfully!");
                return "redirect:/users/support-tickets";

            } catch (Exception e) {
                System.err.println("Error deleting ticket: " + e.getMessage());
                redirectAttributes.addFlashAttribute("error", "Failed to delete ticket. Please try again.");
                return "redirect:/users/support-tickets";
            }
        }

        /**
         * Closes a support ticket.
         * Users can close their own tickets.
         * URL: POST /users/support-tickets/{ticketId}/close
         */
        @PostMapping("/support-tickets/{ticketId}/close")
        public String closeTicket(@PathVariable Long ticketId,
                                  HttpSession session,
                                  RedirectAttributes redirectAttributes) {
            try {
                // Get logged-in user from session
                User loggedUser = (User) session.getAttribute("loggedInUser");

                if (loggedUser == null) {
                    return "redirect:/users/login";
                }

                // Get ticket by ID
                Optional<Ticket> ticketOpt = ticketService.getTicketById(ticketId);
                if (ticketOpt.isEmpty()) {
                    redirectAttributes.addFlashAttribute("error", "Ticket not found");
                    return "redirect:/users/support-tickets";
                }

                Ticket ticket = ticketOpt.get();

                // Check ownership (security check)
                if (!ticket.getUser().getId().equals(loggedUser.getId())) {
                    redirectAttributes.addFlashAttribute("error", "You can only close your own tickets");
                    return "redirect:/users/support-tickets";
                }

                // Update ticket status to CLOSED
                ticket.setStatus("CLOSED");
                ticket.setUpdatedAt(LocalDateTime.now());
                ticketService.saveTicket(ticket);

                redirectAttributes.addFlashAttribute("success", "Ticket closed successfully!");
                return "redirect:/users/support-tickets/" + ticketId;

            } catch (Exception e) {
                System.err.println("Error closing ticket: " + e.getMessage());
                redirectAttributes.addFlashAttribute("error", "Failed to close ticket. Please try again.");
                return "redirect:/users/support-tickets/" + ticketId;
            }
        }

        /**
         * Reopens a closed or solved ticket.
         * Users can reopen their own tickets.
         * URL: POST /users/support-tickets/{ticketId}/reopen
         */
        @PostMapping("/support-tickets/{ticketId}/reopen")
        public String reopenTicket(@PathVariable Long ticketId,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
            try {
                // Get logged-in user from session
                User loggedUser = (User) session.getAttribute("loggedInUser");

                if (loggedUser == null) {
                    return "redirect:/users/login";
                }

                // Get ticket by ID
                Optional<Ticket> ticketOpt = ticketService.getTicketById(ticketId);
                if (ticketOpt.isEmpty()) {
                    redirectAttributes.addFlashAttribute("error", "Ticket not found");
                    return "redirect:/users/support-tickets";
                }

                Ticket ticket = ticketOpt.get();

                // Check ownership (security check)
                if (!ticket.getUser().getId().equals(loggedUser.getId())) {
                    redirectAttributes.addFlashAttribute("error", "You can only reopen your own tickets");
                    return "redirect:/users/support-tickets";
                }

                // Only allow reopening if ticket is CLOSED or SOLVED
                if (!"CLOSED".equals(ticket.getStatus()) && !"SOLVED".equals(ticket.getStatus())) {
                    redirectAttributes.addFlashAttribute("error",
                            "You can only reopen closed or solved tickets");
                    return "redirect:/users/support-tickets/" + ticketId;
                }

                // Update ticket status to OPEN
                ticket.setStatus("OPEN");
                ticket.setUpdatedAt(LocalDateTime.now());
                ticketService.saveTicket(ticket);

                redirectAttributes.addFlashAttribute("success", "Ticket reopened successfully!");
                return "redirect:/users/support-tickets/" + ticketId;

            } catch (Exception e) {
                System.err.println("Error reopening ticket: " + e.getMessage());
                redirectAttributes.addFlashAttribute("error", "Failed to reopen ticket. Please try again.");
                return "redirect:/users/support-tickets/" + ticketId;
            }
        }

        /**
         * Downloads a PDF file containing user's purchase history.
         * Shows package name, booking date, amount paid (with masked card digits).
         * URL: GET /users/profile/download-pdf
         */
        @GetMapping("/profile/download-pdf")
        public ResponseEntity<byte[]> downloadPurchasePdf(HttpSession session) {
            // Get logged-in user from session
            User loggedUser = (User) session.getAttribute("loggedInUser");

            // Check if user is logged in
            if (loggedUser == null) {
                return ResponseEntity.status(401).build(); // Return 401 Unauthorized
            }

            try {
                // Get user's purchase details from database
                List<PdfGeneratorUtil.PurchaseDetails> purchases = paymentService.getPurchaseDetailsForUser(loggedUser.getId());

                // Generate PDF with purchase details
                byte[] pdfBytes = PdfGeneratorUtil.generatePurchasePdf(loggedUser.getFirstName() + " " + loggedUser.getLastName(), purchases);

                // Set headers to tell browser to download as PDF file
                HttpHeaders headers = new HttpHeaders();
                headers.setContentType(MediaType.APPLICATION_PDF);
                headers.set(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=purchase-details.pdf");

                // Return PDF file as response
                return ResponseEntity.ok()
                        .headers(headers)
                        .body(pdfBytes);

            } catch (DocumentException e) {
                // If PDF generation fails, return 500 Internal Server Error
                e.printStackTrace();
                return ResponseEntity.status(500).build();
            }
        }
    }

}
