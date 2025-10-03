package com.example.demo.controller;

import com.example.demo.model.Payment;
import com.example.demo.model.TravelPackage;
import com.example.demo.model.User;
import com.example.demo.service.PaymentService;
import com.example.demo.service.TravelPackageService;
import com.example.demo.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import com.example.demo.model.Package;
import com.example.demo.service.PackageService;
import org.springframework.ui.Model;
import java.util.List;

import jakarta.servlet.http.HttpServletRequest;

/**
 * Main controller that handles public pages and authentication.
 * This includes home page, login, registration, contact, and package browsing.
 */
@Controller
public class HomeController {

    // Automatically inject service classes to interact with database
    @Autowired
    private PaymentService paymentService; // Handles payment operations

    @Autowired
    private UserService userService; // Handles user operations

    @Autowired
    private PackageService packageService; // Handles package operations

    @Autowired
    private TravelPackageService travelPackageService; // Handles travel package CRUD

    /**
     * Shows the user registration form.
     * URL: GET /register
     */
    @GetMapping("/register")
    public String showRegisterForm() {
        return "register"; // Show register.jsp page
    }

    /**
     * Handles user registration form submission.
     * Creates a new user account with the provided details.
     * URL: POST /register
     */
    @PostMapping("/register")
    public String register(HttpServletRequest request) {
        // Create new user object
        User user = new User();

        // Get form data from request and set user properties
        user.setFullName(request.getParameter("fullName"));
        user.setFirstName(request.getParameter("firstName"));
        user.setLastName(request.getParameter("lastName"));
        user.setAge(Integer.parseInt(request.getParameter("age")));
        user.setCountry(request.getParameter("country"));
        user.setGender(request.getParameter("gender"));
        user.setAddress(request.getParameter("address"));
        user.setEmail(request.getParameter("email"));
        user.setPassword(request.getParameter("password"));
        user.setRole(request.getParameter("role"));

        // Save user to database
        userService.registerUser(user);

        // Redirect to login page after successful registration
        return "redirect:/login";
    }

    /**
     * Shows the contact page with contact information.
     * URL: GET /contact
     */
    @GetMapping("/contact")
    public String contact() {
        return "contact"; // Show contact.jsp page from /WEB-INF/jsp/contact.jsp
    }

    /**
     * Shows the login form.
     * URL: GET /login
     */
    @GetMapping("/login")
    public String showLoginForm() {
        return "login"; // Show login.jsp page
    }

    /**
     * Handles user login form submission.
     * Validates email and password, then creates a session for the user.
     * URL: POST /login
     */
    @PostMapping("/login")
    public String login(HttpServletRequest request) {
        // Get email and password from login form
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Attempt to login user
        return userService.login(email, password)
                .map(user -> {
                    // If login successful, store user in session
                    request.getSession().setAttribute("loggedInUser", user);

                    // Redirect to home page after successful login
                    return "redirect:/home";
                })
                // If login fails, redirect back to login with error message
                .orElse("redirect:/login?error");
    }

    /**
     * Shows the home page with all available travel packages.
     * URL: GET /home
     */
    @GetMapping("/home")
    public String home(Model model) {
        // Get all travel packages from database
        List<TravelPackage> packages = travelPackageService.getAllPackages();

        // Add packages to page for display
        model.addAttribute("packages", packages);
        model.addAttribute("totalPackages", packages.size());

        return "home"; // Show home.jsp page
    }

    /**
     * Shows the home page when accessing root URL (/).
     * Same as /home endpoint.
     * URL: GET /
     */
    @GetMapping("/")
    public String homelogo(Model model) {
        // Same logic as /home endpoint
        List<TravelPackage> packages = travelPackageService.getAllPackages();

        model.addAttribute("packages", packages);
        model.addAttribute("totalPackages", packages.size());

        return "home"; // Show home.jsp page
    }

    /**
     * Shows the destinations page.
     * URL: GET /destinations
     */
    @GetMapping("/destinations")
    public String destinations() {
        return "destinations"; // Show destinations.jsp page
    }

    /**
     * Shows the tours page.
     * URL: GET /tours
     */
    @GetMapping("/tours")
    public String tours() {
        return "tours"; // Show tours.jsp page
    }

    /**
     * Shows all available travel packages for booking.
     * This is the main package browsing page.
     * URL: GET /packages
     */
    @GetMapping("/packages")
    public String booknow(Model model) {
        // Get all packages directly from database (bypasses any filters)
        List<TravelPackage> allPackages = travelPackageService.getAllPackages();

        // Debug logging to check how many packages were retrieved
        System.out.println("DEBUG: Service returned " + allPackages.size() + " packages");
        for (TravelPackage pkg : allPackages) {
            System.out.println("Package: " + pkg.getName() + ", Status: " + pkg.getStatus() + ", Featured: " + pkg.getFeatured());
        }

        // Add packages to page for display
        model.addAttribute("allPackages", allPackages);
        model.addAttribute("totalPackages", allPackages.size());

        return "packages"; // Show packages.jsp page
    }

    /**
     * Shows detailed information about a specific package.
     * URL: GET /packages/{id}
     * Example: /packages/5
     */
    @GetMapping("/packages/{id}")
    public String viewPackageDetails(@PathVariable Long id, Model model) {
        try {
            // Get package by ID from database
            TravelPackage pkg = travelPackageService.getPackageById(id);

            // Add package to page (MUST be "pkg" not "package")
            model.addAttribute("pkg", pkg);

            return "package-details"; // Show package-details.jsp page
        } catch (Exception e) {
            // If package not found or error occurs, redirect to packages page
            return "redirect:/packages?error=Package not found";
        }
    }
}
