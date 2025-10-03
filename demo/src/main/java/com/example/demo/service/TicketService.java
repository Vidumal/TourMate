package com.example.demo.service;

import com.example.demo.model.Ticket;
import com.example.demo.repository.TicketRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;


@Service
public class TicketService {

    @Autowired
    private TicketRepository ticketRepository;

    // ================ CREATE OPERATIONS ================


    public Ticket createTicket(Ticket ticket) {
        if (ticket.getCreatedAt() == null) {
            ticket.setCreatedAt(LocalDateTime.now());
        }
        if (ticket.getUpdatedAt() == null) {
            ticket.setUpdatedAt(LocalDateTime.now());
        }
        return ticketRepository.save(ticket);
    }


    public Ticket saveTicket(Ticket ticket) {
        ticket.setUpdatedAt(LocalDateTime.now());
        return ticketRepository.save(ticket);
    }

    // ================ READ OPERATIONS ================


    public List<Ticket> getAllTickets() {
        return ticketRepository.findAllByOrderByCreatedAtDesc();
    }


    public Optional<Ticket> getTicketById(Long id) {
        return ticketRepository.findById(id);
    }

    public List<Ticket> getTicketsByAgency(Long agencyId) {
        return ticketRepository.findByAgencyIdOrderByCreatedAtDesc(agencyId);
    }


    public List<Ticket> getTicketsByUser(Long userId) {
        return ticketRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }


    public List<Ticket> getTicketsByStatus(String status) {
        return ticketRepository.findByStatusOrderByCreatedAtDesc(status);
    }

    public List<Ticket> getTicketsByPriority(String priority) {
        return ticketRepository.findByPriorityOrderByCreatedAtDesc(priority);
    }


    public List<Ticket> getTicketsByUserAndStatus(Long userId, String status) {
        return ticketRepository.findByUserIdAndStatusOrderByCreatedAtDesc(userId, status);
    }


    public List<Ticket> getTicketsByUserInLastDays(Long userId, int days) {
        LocalDateTime fromDate = LocalDateTime.now().minusDays(days);
        return ticketRepository.findUserTicketsCreatedAfter(userId, fromDate);
    }


    public List<Ticket> searchTickets(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllTickets();
        }
        return ticketRepository.searchByKeyword(keyword);
    }


    public List<Ticket> getAllTicketsWithFilters(String search, String status, String priority) {
        try {
            // Try using repository query first (more efficient)
            return ticketRepository.findWithFilters(search, status, priority);
        } catch (Exception e) {
            // Fallback to manual filtering if query fails
            System.err.println("Error with repository filter query, using manual filter: " + e.getMessage());
            return getAllTicketsManualFilter(search, status, priority);
        }
    }


    private List<Ticket> getAllTicketsManualFilter(String search, String status, String priority) {
        List<Ticket> tickets = getAllTickets();

        if (tickets == null) {
            tickets = new ArrayList<>();
        }

        // Apply search filter
        if (search != null && !search.trim().isEmpty()) {
            tickets = tickets.stream()
                    .filter(ticket ->
                            (ticket.getSubject() != null && ticket.getSubject().toLowerCase().contains(search.toLowerCase())) ||
                                    (ticket.getDescription() != null && ticket.getDescription().toLowerCase().contains(search.toLowerCase()))
                    )
                    .collect(Collectors.toList());
        }

        // Apply status filter
        if (status != null && !"all".equalsIgnoreCase(status)) {
            tickets = tickets.stream()
                    .filter(ticket -> ticket.getStatus() != null && ticket.getStatus().equalsIgnoreCase(status))
                    .collect(Collectors.toList());
        }

        // Apply priority filter
        if (priority != null && !"all".equalsIgnoreCase(priority)) {
            tickets = tickets.stream()
                    .filter(ticket -> ticket.getPriority() != null && ticket.getPriority().equalsIgnoreCase(priority))
                    .collect(Collectors.toList());
        }

        return tickets;
    }



    public Ticket updateTicket(Long ticketId, String subject, String description, String priority) {
        Optional<Ticket> ticketOpt = ticketRepository.findById(ticketId);
        if (ticketOpt.isPresent()) {
            Ticket ticket = ticketOpt.get();
            ticket.setSubject(subject);
            ticket.setDescription(description);
            ticket.setPriority(priority);
            ticket.setUpdatedAt(LocalDateTime.now());
            return ticketRepository.save(ticket);
        }
        throw new RuntimeException("Ticket not found with ID: " + ticketId);
    }


    public void updateTicketStatus(Long ticketId, String status) {
        Optional<Ticket> ticketOpt = ticketRepository.findById(ticketId);
        if (ticketOpt.isEmpty()) {
            throw new RuntimeException("Ticket not found with id: " + ticketId);
        }

        Ticket ticket = ticketOpt.get();
        ticket.setStatus(status.toUpperCase());
        ticket.setUpdatedAt(LocalDateTime.now());
        ticketRepository.save(ticket);
    }


    public void updateStatus(Long ticketId, String status) {
        updateTicketStatus(ticketId, status);
    }


    public boolean deleteTicket(Long ticketId) {
        try {
            if (ticketRepository.existsById(ticketId)) {
                ticketRepository.deleteById(ticketId);
                return true;
            }
            return false;
        } catch (Exception e) {
            System.err.println("Error deleting ticket: " + e.getMessage());
            return false;
        }
    }


    public boolean deleteTicketsByUser(Long userId) {
        try {
            ticketRepository.deleteByUserId(userId);
            return true;
        } catch (Exception e) {
            System.err.println("Error deleting tickets for user: " + e.getMessage());
            return false;
        }
    }

    public long getTotalTicketsCount() {
        return ticketRepository.count();
    }


    public long countTicketsByUser(Long userId) {
        return ticketRepository.countByUserId(userId);
    }


    public long countTicketsByStatus(String status) {
        return ticketRepository.countByStatus(status);
    }


    public long countTicketsByPriority(String priority) {
        return ticketRepository.countByPriority(priority);
    }

    public long countOpenTicketsByUser(Long userId) {
        return ticketRepository.countByUserIdAndStatus(userId, "OPEN");
    }

    public long getOpenTicketsCount() {
        return countTicketsByStatus("OPEN");
    }


    public long getSolvedTicketsCount() {
        return countTicketsByStatus("SOLVED");
    }


    public long getClosedTicketsCount() {
        return countTicketsByStatus("CLOSED");
    }

    // ================ NOTIFICATION SYSTEM ================


    public long getNewTicketsCount(int minutes) {
        LocalDateTime cutoffTime = LocalDateTime.now().minusMinutes(minutes);
        return ticketRepository.countByCreatedAtAfter(cutoffTime);
    }


    public List<Ticket> getRecentTickets(int minutes) {
        LocalDateTime cutoffTime = LocalDateTime.now().minusMinutes(minutes);
        return ticketRepository.findByCreatedAtAfterOrderByCreatedAtDesc(cutoffTime);
    }

    // ================ REPLY MANAGEMENT ================

    public void replyToTicket(Long ticketId, String reply, String repliedBy) {
        Optional<Ticket> ticketOpt = ticketRepository.findById(ticketId);
        if (ticketOpt.isEmpty()) {
            throw new RuntimeException("Ticket not found with id: " + ticketId);
        }

        Ticket ticket = ticketOpt.get();

        // Set reply based on who is replying
        if ("AGENCY".equalsIgnoreCase(repliedBy)) {
            ticket.setAgencyReply(reply);
        } else if ("ADMIN".equalsIgnoreCase(repliedBy)) {
            ticket.setAdminReply(reply);
        } else {
            throw new IllegalArgumentException("Invalid repliedBy value: " + repliedBy);
        }

        // Update status to IN_PROGRESS if still OPEN
        if ("OPEN".equalsIgnoreCase(ticket.getStatus())) {
            ticket.setStatus("IN_PROGRESS");
        }

        ticket.setUpdatedAt(LocalDateTime.now());
        ticketRepository.save(ticket);
    }


    public void addAdminReply(Long ticketId, String reply) {
        replyToTicket(ticketId, reply, "ADMIN");
    }


    public void addAgencyReply(Long ticketId, String reply) {
        replyToTicket(ticketId, reply, "AGENCY");
    }


    public void addReply(Long ticketId, String reply, String userType, String userName) {
        replyToTicket(ticketId, reply, userType);
    }


    public boolean hasReply(Ticket ticket) {
        return (ticket.getAdminReply() != null && !ticket.getAdminReply().trim().isEmpty()) ||
                (ticket.getAgencyReply() != null && !ticket.getAgencyReply().trim().isEmpty());
    }


    public List<Ticket> getTicketsWithAdminReply() {
        return ticketRepository.findTicketsWithAdminReply();
    }


    public List<Ticket> getTicketsWithAgencyReply() {
        return ticketRepository.findTicketsWithAgencyReply();
    }

    public List<Ticket> getUnansweredTickets() {
        return ticketRepository.findTicketsWithoutReply();
    }

    public void markAsResolved(Long ticketId) {
        updateTicketStatus(ticketId, "SOLVED");
    }


    public void markTicketAsResolved(Long ticketId, String resolvedBy) {
        Optional<Ticket> ticketOpt = ticketRepository.findById(ticketId);
        if (ticketOpt.isEmpty()) {
            throw new RuntimeException("Ticket not found with id: " + ticketId);
        }

        Ticket ticket = ticketOpt.get();
        ticket.setStatus("SOLVED");

        // Set the reply based on who resolved it (only if no reply exists)
        if ("AGENCY".equalsIgnoreCase(resolvedBy) &&
                (ticket.getAgencyReply() == null || ticket.getAgencyReply().trim().isEmpty())) {
            ticket.setAgencyReply("This ticket has been resolved by our agency team.");
        } else if ("ADMIN".equalsIgnoreCase(resolvedBy) &&
                (ticket.getAdminReply() == null || ticket.getAdminReply().trim().isEmpty())) {
            ticket.setAdminReply("This ticket has been resolved by our admin team.");
        }

        ticket.setUpdatedAt(LocalDateTime.now());
        ticketRepository.save(ticket);
    }

    public void closeTicket(Long ticketId) {
        updateTicketStatus(ticketId, "CLOSED");
    }


    public void reopenTicket(Long ticketId) {
        updateTicketStatus(ticketId, "OPEN");
    }

    public boolean canUserModifyTicket(Long userId, Long ticketId) {
        Optional<Ticket> ticketOpt = ticketRepository.findById(ticketId);
        return ticketOpt.isPresent() && ticketOpt.get().getUser().getId().equals(userId);
    }


    public boolean isTicketOpen(Long ticketId) {
        Optional<Ticket> ticketOpt = ticketRepository.findById(ticketId);
        return ticketOpt.isPresent() && "OPEN".equalsIgnoreCase(ticketOpt.get().getStatus());
    }


    public boolean canEditTicket(Long ticketId) {
        return isTicketOpen(ticketId);
    }

    public boolean canDeleteTicket(Long ticketId) {
        Optional<Ticket> ticketOpt = ticketRepository.findById(ticketId);
        if (ticketOpt.isPresent()) {
            String status = ticketOpt.get().getStatus();
            return "OPEN".equalsIgnoreCase(status) || "CLOSED".equalsIgnoreCase(status);
        }
        return false;
    }
}
