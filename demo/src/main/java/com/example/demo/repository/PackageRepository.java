package com.example.demo.repository;

import com.example.demo.model.TravelPackage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


import com.example.demo.model.Package;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
@Repository
public interface PackageRepository extends JpaRepository<TravelPackage, Long> {


    Long countByStatus(String status);
    Long countByFeaturedTrue();


    List<TravelPackage> findByUploadedBy(String uploadedBy);
    List<TravelPackage> findByFeaturedTrue();
    List<TravelPackage> findByStatus(String status);
    List<TravelPackage> findByStatusAndFeaturedTrue(String status);
    List<TravelPackage> findByDestinationContainingIgnoreCase(String destination);
    List<TravelPackage> findAllByOrderByCreatedAtDesc();
    List<TravelPackage> findByActiveTrue();

    // Custom search query
    @Query("SELECT p FROM TravelPackage p WHERE p.name LIKE %?1% OR p.destination LIKE %?1%")
    List<TravelPackage> searchByNameOrDestination(String keyword);


}
