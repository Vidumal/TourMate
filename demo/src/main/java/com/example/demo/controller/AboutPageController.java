package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AboutPageController {

    @GetMapping("/about-us")
    public String showAboutUsPage() {
        return "aboutus";  // loads /WEB-INF/views/aboutus.jsp
    }
}
