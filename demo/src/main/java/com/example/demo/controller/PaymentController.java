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

@Controller
@RequestMapping("/payment")
public class PaymentController {


    @Autowired
    private PaymentService paymentService;

    @Autowired
    private TravelPackageService travelPackageService;

    @GetMapping("/{packageId}")
    public String showPaymentForm(@PathVariable Long packageId, HttpSession session, Model model) {

        User loggedInUser = (User) session.getAttribute("loggedInUser");


        if (loggedInUser == null) {
            return "redirect:/login?error=Please login to book packages";
        }


        TravelPackage pkg = travelPackageService.getPackageById(packageId);


        model.addAttribute("pkg", pkg);
        model.addAttribute("user", loggedInUser);

        return "payment";
    }

    @PostMapping("/process")
    public String processPayment(@RequestParam Long packageId,
                                 @RequestParam String cardHolderName,
                                 @RequestParam String cardNumber,
                                 @RequestParam String cardExpiry,
                                 @RequestParam String cardCvv,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {


        User loggedInUser = (User) session.getAttribute("loggedInUser");


        if (loggedInUser == null) {
            return "redirect:/login";
        }

        try {

            TravelPackage pkg = travelPackageService.getPackageById(packageId);


            Payment payment = new Payment();
            payment.setUserId(loggedInUser.getId());
            payment.setPackageId(packageId);
            payment.setCardHolderName(cardHolderName);
            payment.setCardNumber(cardNumber);
            payment.setCardExpiry(cardExpiry);
            payment.setAmount(pkg.getPrice());

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
