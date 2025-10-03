package com.example.demo.repository;

import com.example.demo.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {
    List<Payment> findByUserIdOrderByCreatedAtDesc(Long userId);
    List<Payment> findByUserIdAndStatus(Long userId, String status);
    List<Payment> findByPackageId(Long packageId);
}
