package com.example.demo.repository;

import com.example.demo.model.Ticket;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface TicketRepository extends JpaRepository<Ticket, Long> {

    // ================ BASIC FINDERS ================

    /**
     * Find tickets by agency ID
     */
    List<Ticket> findByAgencyId(Long agencyId);

    /**
     * Find tickets by user ID
     */
    List<Ticket> findByUserId(Long userId);

    /**
     * Find tickets by status (OPEN, IN_PROGRESS, SOLVED, CLOSED)
     */
    List<Ticket> findByStatus(String status);

    /**
     * Find tickets by priority (URGENT, HIGH, MEDIUM, LOW)
     */
    List<Ticket> findByPriority(String priority);

    // ================ ORDERED FINDERS ================

    /**
     * Find all tickets ordered by creation date (newest first)
     */
    List<Ticket> findAllByOrderByCreatedAtDesc();

    /**
     * Find user's tickets ordered by creation date (newest first)
     */
    List<Ticket> findByUserIdOrderByCreatedAtDesc(Long userId);

    /**
     * Find agency's tickets ordered by creation date (newest first)
     */
    List<Ticket> findByAgencyIdOrderByCreatedAtDesc(Long agencyId);

    /**
     * Find tickets by status ordered by creation date (newest first)
     */
    List<Ticket> findByStatusOrderByCreatedAtDesc(String status);

    /**
     * Find tickets by priority ordered by creation date (newest first)
     */
    List<Ticket> findByPriorityOrderByCreatedAtDesc(String priority);

    // ================ COMBINED FILTERS ================

    /**
     * Find tickets by user ID and status
     */
    List<Ticket> findByUserIdAndStatus(Long userId, String status);

    /**
     * Find tickets by user ID and priority
     */
    List<Ticket> findByUserIdAndPriority(Long userId, String priority);

    /**
     * Find tickets by status and priority
     */
    List<Ticket> findByStatusAndPriority(String status, String priority);

    /**
     * Find tickets by user ID and status, ordered by creation date
     */
    List<Ticket> findByUserIdAndStatusOrderByCreatedAtDesc(Long userId, String status);

    /**
     * Find tickets by user ID and priority, ordered by creation date
     */
    List<Ticket> findByUserIdAndPriorityOrderByCreatedAtDesc(Long userId, String priority);

    // ================ DATE-BASED QUERIES ================

    /**
     * Count tickets created after a specific date/time
     * Used for notification system (e.g., new tickets in last 5 minutes)
     */
    long countByCreatedAtAfter(LocalDateTime dateTime);

    /**
     * Find tickets created after a specific date/time, ordered by creation date
     * Used for notification system to show recent tickets
     */
    List<Ticket> findByCreatedAtAfterOrderByCreatedAtDesc(LocalDateTime dateTime);

    /**
     * Find tickets created after a specific date
     */
    @Query("SELECT t FROM Ticket t WHERE t.createdAt >= :fromDate ORDER BY t.createdAt DESC")
    List<Ticket> findTicketsCreatedAfter(@Param("fromDate") LocalDateTime fromDate);

    /**
     * Find user's tickets created after a specific date
     */
    @Query("SELECT t FROM Ticket t WHERE t.user.id = :userId AND t.createdAt >= :fromDate ORDER BY t.createdAt DESC")
    List<Ticket> findUserTicketsCreatedAfter(@Param("userId") Long userId, @Param("fromDate") LocalDateTime fromDate);

    // ================ COUNTING OPERATIONS ================

    /**
     * Count total tickets by user ID
     */
    long countByUserId(Long userId);

    /**
     * Count tickets by status
     */
    long countByStatus(String status);

    /**
     * Count tickets by priority
     */
    long countByPriority(String priority);

    /**
     * Count tickets by user ID and status
     */
    long countByUserIdAndStatus(Long userId, String status);

    /**
     * Count tickets by agency ID
     */
    long countByAgencyId(Long agencyId);

    /**
     * Count active tickets (OPEN or IN_PROGRESS)
     */
    @Query("SELECT COUNT(t) FROM Ticket t WHERE t.status IN ('OPEN', 'IN_PROGRESS')")
    long countActiveTickets();

    /**
     * Count active tickets by user
     */
    @Query("SELECT COUNT(t) FROM Ticket t WHERE t.user.id = :userId AND t.status IN ('OPEN', 'IN_PROGRESS')")
    long countActiveTicketsByUser(@Param("userId") Long userId);

    // ================ SEARCH QUERIES ================

    /**
     * Search tickets by keyword in subject or description (case-insensitive)
     */
    @Query("SELECT t FROM Ticket t WHERE " +
            "LOWER(t.subject) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(t.description) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<Ticket> searchByKeyword(@Param("keyword") String keyword);

    /**
     * Search user's tickets by keyword
     */
    @Query("SELECT t FROM Ticket t WHERE t.user.id = :userId AND " +
            "(LOWER(t.subject) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(t.description) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<Ticket> findByUserIdAndKeyword(@Param("userId") Long userId, @Param("keyword") String keyword);

    /**
     * Complex search with filters (search text, status, priority)
     * Used by admin and agency ticket management pages
     */
    @Query("SELECT t FROM Ticket t WHERE " +
            "(:search IS NULL OR :search = '' OR " +
            "LOWER(t.subject) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
            "LOWER(t.description) LIKE LOWER(CONCAT('%', :search, '%'))) AND " +
            "(:status IS NULL OR :status = 'all' OR LOWER(t.status) = LOWER(:status)) AND " +
            "(:priority IS NULL OR :priority = 'all' OR LOWER(t.priority) = LOWER(:priority)) " +
            "ORDER BY t.createdAt DESC")
    List<Ticket> findWithFilters(
            @Param("search") String search,
            @Param("status") String status,
            @Param("priority") String priority
    );

    // ================ REPLY-RELATED QUERIES ================

    /**
     * Find tickets that have an admin reply
     */
    @Query("SELECT t FROM Ticket t WHERE t.adminReply IS NOT NULL AND t.adminReply != ''")
    List<Ticket> findTicketsWithAdminReply();

    /**
     * Find tickets that have an agency reply
     */
    @Query("SELECT t FROM Ticket t WHERE t.agencyReply IS NOT NULL AND t.agencyReply != ''")
    List<Ticket> findTicketsWithAgencyReply();

    /**
     * Find tickets without any reply (unanswered tickets)
     */
    @Query("SELECT t FROM Ticket t WHERE " +
            "(t.adminReply IS NULL OR t.adminReply = '') AND " +
            "(t.agencyReply IS NULL OR t.agencyReply = '')")
    List<Ticket> findTicketsWithoutReply();

    /**
     * Find tickets with any reply (admin OR agency)
     */
    @Query("SELECT t FROM Ticket t WHERE " +
            "(t.adminReply IS NOT NULL AND t.adminReply != '') OR " +
            "(t.agencyReply IS NOT NULL AND t.agencyReply != '')")
    List<Ticket> findTicketsWithAnyReply();

    // ================ DELETE OPERATIONS ================

    /**
     * Delete all tickets by user ID
     * Use with caution - typically used when deleting a user account
     */
    void deleteByUserId(Long userId);

    /**
     * Delete all tickets by status
     * Use with caution - typically used for cleanup
     */
    void deleteByStatus(String status);
}
