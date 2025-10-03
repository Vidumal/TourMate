package com.example.demo.repository;

import com.example.demo.model.TravelPackage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TravelPackageRepository extends JpaRepository<TravelPackage, Long> {
    // ✅ CHANGE THIS: Use agencyId instead of agencyEntityId
    List<TravelPackage> findByAgencyId(Long agencyId);

    List<TravelPackage> findByActiveTrue();

    List<TravelPackage> findByFeaturedTrue();
    List<TravelPackage> findByStatus(String status);

    List<TravelPackage> findByUploadedBy(String uploadedBy);


    // Your existing methods:

    List<TravelPackage> findByStatusAndFeaturedTrue(String status);
    List<TravelPackage> findByDestinationContainingIgnoreCase(String destination);
    List<TravelPackage> findAllByOrderByCreatedAtDesc();



    Long countByStatus(String status);
    Long countByFeaturedTrue();
    @Query("SELECT p FROM TravelPackage p WHERE p.name LIKE %?1% OR p.destination LIKE %?1%")
    List<TravelPackage> searchByNameOrDestination(String keyword);
}

