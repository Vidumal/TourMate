package com.example.demo.repository;

import com.example.demo.model.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {

    //  get user's bookings
    List<Booking> findByUserIdOrderByBookingDateDesc(Long userId);

    List<Booking> findByUserIdAndBookingStatus(Long userId, String status);

    // For agency - get bookings for their packages
    List<Booking> findByPackageIdOrderByBookingDateDesc(Long packageId);

    List<Booking> findByPackageIdAndBookingStatus(Long packageId, String status);

    // Get bookings with package details for user profile
    @Query("SELECT b FROM Booking b JOIN FETCH b.travelPackage WHERE b.userId = :userId ORDER BY b.bookingDate DESC")
    List<Booking> findBookingsWithPackageByUserId(@Param("userId") Long userId);

    // Get bookings with user details for agency view
    @Query("SELECT b FROM Booking b JOIN FETCH b.user WHERE b.packageId = :packageId ORDER BY b.bookingDate DESC")
    List<Booking> findBookingsWithUserByPackageId(@Param("packageId") Long packageId);


    List<Booking> findByPackageIdInOrderByBookingDateDesc(List<Long> packageIds);

}
