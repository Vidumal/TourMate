package com.example.demo.controller;

import com.example.demo.model.TravelPackage;
import com.example.demo.service.PackageService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

/**
 * Controller that handles package browsing, filtering, and searching.
 * This is for public users to view and search through available packages.
 */
@Controller
@RequestMapping("/travel_packages") // All URLs start with /travel_packages
@RequiredArgsConstructor // Automatically creates constructor for final fields (Lombok annotation)
public class PackageController {

    // Inject PackageService using constructor injection (via @RequiredArgsConstructor)
    private final PackageService packageService;

    /**
     * Shows all active packages on the main packages page.
     * URL: GET /travel_packages
     */
    @GetMapping
    public String showAllPackages(Model model) {
        // Get all active packages (excludes inactive/deleted packages)
        List<TravelPackage> allPackages = packageService.getActivePackages();

        // Get total count of all packages
        Long totalPackages = packageService.getTotalPackagesCount();

        // Add packages to page for display
        model.addAttribute("allPackages", allPackages);
        model.addAttribute("totalPackages", totalPackages);

        return "packages"; // Show packages.jsp page
    }

    /**
     * Shows detailed information about a specific package.
     * URL: GET /travel_packages/{id}
     * Example: /travel_packages/5
     */
    @GetMapping("/{id}")
    public String showPackageDetails(@PathVariable Long id, Model model) {
        // Get package by ID (returns Optional to handle not found case)
        Optional<TravelPackage> packageOpt = packageService.getPackageByIdOptional(id);

        if (packageOpt.isPresent()) {
            // Package found - show its details
            TravelPackage pkg = packageOpt.get();
            model.addAttribute("package", pkg);

            // Get related packages from same uploader (admin or agency)
            List<TravelPackage> relatedPackages = packageService.getPackagesByUploadedBy(pkg.getUploadedBy());
            model.addAttribute("relatedPackages", relatedPackages);

            return "package-details"; // Show package-details.jsp page
        } else {
            // Package not found - redirect to packages page with error
            return "redirect:/packages?error=Package not found";
        }
    }

    /**
     * Filters packages by type (admin, agency, or featured).
     * URL: GET /travel_packages/filter?type=admin
     * URL: GET /travel_packages/filter?type=agency
     * URL: GET /travel_packages/filter?type=featured
     */
    @GetMapping("/filter")
    public String filterPackages(@RequestParam String type, Model model) {
        List<TravelPackage> packages;

        // Filter packages based on type parameter
        switch (type.toLowerCase()) {
            case "admin":
                // Show only packages uploaded by admin
                packages = packageService.getPackagesByUploadedBy("admin");
                break;
            case "agency":
                // Show only packages uploaded by agencies
                packages = packageService.getPackagesByUploadedBy("agency");
                break;
            case "featured":
                // Show only featured/highlighted packages
                packages = packageService.getActiveAndFeaturedPackages();
                break;
            default:
                // Show all active packages if type is not recognized
                packages = packageService.getActivePackages();
        }

        // Add filtered packages to page
        model.addAttribute("allPackages", packages);
        model.addAttribute("totalPackages", (long) packages.size());
        model.addAttribute("activeFilter", type); // Remember which filter is active

        return "packages"; // Show packages.jsp page with filtered results
    }

    /**
     * Searches for packages based on a keyword query.
     * URL: GET /travel_packages/search?q=beach
     * Searches in package name, destination, description, etc.
     */
    @GetMapping("/search")
    public String searchPackages(@RequestParam String q, Model model) {
        // Search for packages matching the keyword
        List<TravelPackage> packages = packageService.searchPackages(q);

        // Add search results to page
        model.addAttribute("allPackages", packages);
        model.addAttribute("totalPackages", (long) packages.size());
        model.addAttribute("searchQuery", q); // Remember what was searched

        return "packages"; // Show packages.jsp page with search results
    }
}

