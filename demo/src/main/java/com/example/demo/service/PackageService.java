package com.example.demo.service;


import com.example.demo.model.TravelPackage;
import com.example.demo.repository.PackageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
@Service
@Transactional
public class PackageService {

    @Autowired
    private PackageRepository packageRepository;





    public List<TravelPackage> getAllPackages() {
        return packageRepository.findAll();
    }

    public TravelPackage getPackageById(Long id) {
        return packageRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Package not found"));
    }

    public Long getTotalPackagesCount() {
        return packageRepository.count();
    }

    public Long getActivePackagesCount() {
        return packageRepository.countByStatus("ACTIVE");
    }

    public Long getInactivePackagesCount() {
        return packageRepository.countByStatus("INACTIVE");
    }

    public Long getFeaturedPackagesCount() {
        return packageRepository.countByFeaturedTrue();
    }


    public void deletePackage(Long id) {
        packageRepository.deleteById(id);
    }



    // Save and delete
    public TravelPackage savePackage(TravelPackage travelPackage) {
        if (travelPackage.getCreatedAt() == null) {
            travelPackage.setCreatedAt(LocalDateTime.now());
        }
        return packageRepository.save(travelPackage);
    }





    // Get package by ID (Optional)
    public Optional<TravelPackage> getPackageByIdOptional(Long id) {
        return packageRepository.findById(id);
    }



    // Filter methods - ADD THESE MISSING METHODS
    public List<TravelPackage> getPackagesByUploadedBy(String uploadedBy) {
        return packageRepository.findByUploadedBy(uploadedBy);
    }

    public List<TravelPackage> getFeaturedPackages() {
        return packageRepository.findByFeaturedTrue();
    }

    public List<TravelPackage> getActivePackages() {
        return packageRepository.findByStatus("ACTIVE");
    }

    public List<TravelPackage> getActiveAndFeaturedPackages() {
        return packageRepository.findByStatusAndFeaturedTrue("ACTIVE");
    }

    public List<TravelPackage> getAllPackagesOrderedByDate() {
        return packageRepository.findAllByOrderByCreatedAtDesc();
    }

    // Search methods - ADD THESE MISSING METHODS
    public List<TravelPackage> searchPackagesByDestination(String destination) {
        return packageRepository.findByDestinationContainingIgnoreCase(destination);
    }

    public List<TravelPackage> searchPackages(String keyword) {
        return packageRepository.searchByNameOrDestination(keyword);
    }



}
