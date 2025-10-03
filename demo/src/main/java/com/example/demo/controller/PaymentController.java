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