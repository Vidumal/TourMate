package com.example.demo.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;



@Entity
@Table(name = "tickets")
public class Ticket {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String subject;
    private String description;
    private String status;
    private String priority;

    @Column(name = "admin_reply")
    private String adminReply;

    @Column(name = "agency_reply")
    private String agencyReply;

    @Column(name = "created_at")
    private LocalDateTime createdAt;


    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "agency_id")
    private Agency agency;


    public Date getCreatedAtDate() {
        return createdAt != null ?
                Date.from(createdAt.atZone(ZoneId.systemDefault()).toInstant()) : null;
    }

    public Date getUpdatedAtDate() {
        return updatedAt != null ?
                Date.from(updatedAt.atZone(ZoneId.systemDefault()).toInstant()) : null;
    }
}