package com.example.demo.service;

import com.example.demo.util.PdfGeneratorUtil.PurchaseDetails;
import com.example.demo.model.Payment;
import com.example.demo.model.TravelPackage;
import com.example.demo.repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@Transactional
public class PaymentService {

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private BookingService bookingService; // Add this

    @Autowired
    private TravelPackageService travelPackageService;



    public Payment processPayment(Payment payment) {
        // Generate transaction ID
        payment.setTransactionId("TXN_" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());

        // Mask card number
        if (payment.getCardNumber() != null && payment.getCardNumber().length() > 4) {
            String lastFour = payment.getCardNumber().substring(payment.getCardNumber().length() - 4);
            payment.setCardNumber("****-****-****-" + lastFour);
        }

        try {
            payment.setStatus("SUCCESS");
            Payment savedPayment = paymentRepository.save(payment);

            // Create booking record after successful payment
            if ("SUCCESS".equals(savedPayment.getStatus())) {
                bookingService.createBooking(
                        savedPayment.getUserId(),
                        savedPayment.getPackageId(),
                        savedPayment.getId()
                );
            }

            return savedPayment;
        } catch (Exception e) {
            payment.setStatus("FAILED");
            return paymentRepository.save(payment);
        }
    }

    public List<Payment> getPaymentsByUser(Long userId) {
        return paymentRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    public List<Payment> getSuccessfulPaymentsByUser(Long userId) {
        return paymentRepository.findByUserIdAndStatus(userId, "SUCCESS");
    }


    public List<PurchaseDetails> getPurchaseDetailsForUser(Long userId) {
        // Query all successful payments by user
        List<Payment> payments = this.getSuccessfulPaymentsByUser(userId);

        List<PurchaseDetails> purchaseDetailsList = new ArrayList<>();

        // For each payment, fetch package info (assuming you have travelPackageService)
        for (Payment payment : payments) {
            TravelPackage travelPackage = travelPackageService.getPackageById(payment.getPackageId());

            PurchaseDetails details = new PurchaseDetails(
                    travelPackage.getName(),
                    payment.getCreatedAt(),
                    payment.getAmount().doubleValue(),
                    payment.getStatus(),
                    payment.getCardNumber()  // This will be masked in PDF generator
            );
            purchaseDetailsList.add(details);
        }
        return purchaseDetailsList;
    }


}
