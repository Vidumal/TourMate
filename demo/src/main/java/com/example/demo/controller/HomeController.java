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

}