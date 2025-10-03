package com.example.demo.controller;

import com.example.demo.model.Payment;
import com.example.demo.model.TravelPackage;
import com.example.demo.model.User;
import com.example.demo.service.PaymentService;
import com.example.demo.service.TravelPackageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.servlet.http.HttpSession;

/**
 * Controller that handles payment processing for travel package bookings.
 * Manages payment form display and payment processing logic.
 */
@Controller
@RequestMapping("/payment") // All URLs start with /payment
public class PaymentController {

    // Automatically inject service classes to interact with database
    @Autowired
    private PaymentService paymentService; // Handles payment processing and storage

    @Autowired
    private TravelPackageService travelPackageService; // Handles travel package operations

    /**
     * Shows the payment form for a specific package.
     * Users must be logged in to access this page.
     * URL: GET /payment/{packageId}
     * Example: GET /payment/5
     */
    @GetMapping("/{packageId}")
    public String showPaymentForm(@PathVariable Long packageId, HttpSession session, Model model) {
        // Get logged-in user from session
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        // Check if user is logged in, redirect to login if not
        if (loggedInUser == null) {
            return "redirect:/login?error=Please login to book packages";
        }

        // Get the package details that user wants to book
        TravelPackage pkg = travelPackageService.getPackageById(packageId);

        // Add package and user info to payment form
        model.addAttribute("pkg", pkg);
        model.addAttribute("user", loggedInUser);

        return "payment"; // Show payment.jsp page with payment form
    }

    /**
     * Processes the payment when user submits the payment form.
     * Validates card details and creates payment record.
     * URL: POST /payment/process
     */
    @PostMapping("/process")
    public String processPayment(@RequestParam Long packageId,
                                 @RequestParam String cardHolderName,
                                 @RequestParam String cardNumber,
                                 @RequestParam String cardExpiry,
                                 @RequestParam String cardCvv,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {

        // Get logged-in user from session
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        // Check if user is logged in
        if (loggedInUser == null) {
            return "redirect:/login";
        }

        try {
            // Get the package that user is booking
            TravelPackage pkg = travelPackageService.getPackageById(packageId);

            // Create payment object with form data
            Payment payment = new Payment();
            payment.setUserId(loggedInUser.getId());
            payment.setPackageId(packageId);
            payment.setCardHolderName(cardHolderName);
            payment.setCardNumber(cardNumber);
            payment.setCardExpiry(cardExpiry);
            payment.setAmount(pkg.getPrice()); // Set amount from package price

            // Process the payment through payment service
            Payment processedPayment = paymentService.processPayment(payment);

            // Check if payment was successful
            if ("SUCCESS".equals(processedPayment.getStatus())) {
                // Payment successful - show success message and redirect to profile
                redirectAttributes.addFlashAttribute("success", "Payment successful! Package booked successfully.");
                return "redirect:/users/profile";
            } else {
                // Payment failed - show error message and return to payment form
                redirectAttributes.addFlashAttribute("error", "Payment failed. Please try again.");
                return "redirect:/payment/" + packageId;
            }

        } catch (Exception e) {
            // If any error occurs during payment processing
            redirectAttributes.addFlashAttribute("error", "An error occurred during payment processing.");
            return "redirect:/payment/" + packageId;
        }
    }
}
