package com.example.demo.service;

import com.example.demo.model.TravelPackage;
import com.example.demo.repository.TravelPackageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class TravelPackageService {

    @Autowired
    private TravelPackageRepository travelPackageRepository;

    public List<TravelPackage> getAllTravelPackages() {
        return travelPackageRepository.findAll();
    }

    // ✅ FIXED: Now calls findByAgencyId
    public List<TravelPackage> getTravelPackagesByAgency(Long agencyId) {
        return travelPackageRepository.findByAgencyId(agencyId);
    }

    public Optional<TravelPackage> getTravelPackageById(Long id) {
        return travelPackageRepository.findById(id);
    }

    public List<TravelPackage> getFeaturedPackages() {
        return travelPackageRepository.findByFeaturedTrue();
    }

    public List<TravelPackage> getActivePackages() {
        return travelPackageRepository.findByStatus("ACTIVE");
    }


    public TravelPackage saveTravelPackage(TravelPackage pkg) {
        if (pkg.getCreatedAt() == null) {
            pkg.setCreatedAt(LocalDateTime.now());
        }
        return travelPackageRepository.save(pkg);
    }

    public void deleteTravelPackage(Long id) {
        travelPackageRepository.deleteById(id);
    }


    public List<TravelPackage> getAllPackages() {
        return travelPackageRepository.findAll();
    }

    public TravelPackage savePackage(TravelPackage pkg) {
        return travelPackageRepository.save(pkg);
    }

    public TravelPackage getPackageById(Long id) {
        return travelPackageRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Package not found with id: " + id));
    }

    public List<TravelPackage> getPackagesByUploadedBy(String uploadedBy) {
        return travelPackageRepository.findByUploadedBy(uploadedBy);
    }





}