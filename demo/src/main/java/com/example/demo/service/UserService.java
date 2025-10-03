package com.example.demo.service;

import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.time.LocalDateTime;
import java.util.Map;

/**
 * Service class that handles all user-related business logic.
 * This acts as a layer between controllers and the database repository.
 * Contains methods for user registration, authentication, CRUD operations, and searches.
 */
@Service // Marks this class as a Spring service component
public class UserService {

    // Inject UserRepository to interact with database
    @Autowired
    private UserRepository userRepository;

    /**
     * Registers a new user by saving to database.
     * @param user - User object with registration details
     * @return Saved user object with generated ID
     */
    public User registerUser(User user) {
        return userRepository.save(user);
    }

    /**
     * Authenticates a user by checking email and password.
     * WARNING: This uses plain text password comparison which is NOT secure!
     * In production, use BCrypt password hashing instead.
     * @param email - User's email address
     * @param password - User's plain text password
     * @return Optional containing user if login successful, empty if failed
     */
    public Optional<User> login(String email, String password) {
        // Find user by email
        Optional<User> user = userRepository.findByEmail(email);

        // Check if user exists and password matches (INSECURE - should use BCrypt)
        if (user.isPresent() && user.get().getPassword().equals(password)) {
            return user;
        }

        // Return empty if login failed
        return Optional.empty();
    }

    /**
     * Checks if a username already exists in database.
     * Used during registration to prevent duplicate usernames.
     * @param username - Username to check
     * @return true if username exists, false otherwise
     */
    public boolean isUsernameTaken(String username) {
        return userRepository.existsByUsername(username);
    }

    /**
     * Checks if an email already exists in database.
     * Used during registration to prevent duplicate emails.
     * @param email - Email to check
     * @return true if email exists, false otherwise
     */
    public boolean isEmailTaken(String email) {
        return userRepository.existsByEmail(email);
    }

    /**
     * Deletes a user from database by ID.
     * This permanently removes the user and all related data.
     * @param id - User ID to delete
     */
    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }

    /**
     * Retrieves all users from database.
     * Used by admin to view all registered users.
     * @return List of all users
     */
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    /**
     * Saves or updates a user in database.
     * Sets creation timestamp if it's a new user.
     * @param user - User object to save
     * @return Saved user object
     */
    public User saveUser(User user) {
        // Set creation timestamp for new users
        if (user.getCreatedAt() == null) {
            user.setCreatedAt(LocalDateTime.now());
        }

        // Save without encoding password (should use BCrypt in production)
        return userRepository.save(user);
    }

    /**
     * Retrieves a user by ID.
     * Throws exception if user not found.
     * @param id - User ID to retrieve
     * @return User object
     * @throws RuntimeException if user not found
     */
    public User getUserById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    /**
     * Updates specific fields of a user using a Map of field names and values.
     * This allows partial updates without sending entire user object.
     * @param id - User ID to update
     * @param updates - Map containing field names as keys and new values
     */
    public void updateUser(Long id, Map<String, Object> updates) {
        // Get existing user from database
        User user = getUserById(id);

        // Loop through each update and apply to user object
        updates.forEach((key, value) -> {
            switch (key) {
                case "firstName" -> user.setFirstName((String) value);
                case "lastName" -> user.setLastName((String) value);
                case "email" -> user.setEmail((String) value);
                case "role" -> user.setRole((String) value);
                case "age" -> user.setAge(value != null ? Integer.valueOf(value.toString()) : null);
                case "phone" -> user.setPhone((String) value);
                case "gender" -> user.setGender((String) value);
                case "status" -> user.setStatus((String) value);
                case "password" -> user.setPassword((String) value);
            }
        });

        // Save updated user to database
        userRepository.save(user);
    }

    /**
     * Returns the total count of all users in database.
     * Used for statistics on admin dashboard.
     * @return Total number of users
     */
    public Long getTotalUsersCount() {
        return userRepository.count();
    }

    /**
     * Creates a new user with provided details.
     * Alternative method for user creation with specific parameters.
     * @param firstName - User's first name
     * @param lastName - User's last name
     * @param email - User's email
     * @param password - User's password (should be hashed in production)
     * @param role - User's role (USER, ADMIN, AGENCY)
     * @param phone - User's phone number
     * @return Created user object
     */
    public User createUser(String firstName, String lastName, String email,
                           String password, String role, String phone) {
        // Create new user object
        User user = new User();
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setPassword(password); // Should hash this in production using BCrypt
        user.setRole(role);
        user.setPhone(phone);

        // Save and return user
        return userRepository.save(user);
    }

    /**
     * Finds a user by username.
     * @param username - Username to search for
     * @return Optional containing user if found, empty otherwise
     */
    public Optional<User> getUserByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    /**
     * Finds a user by email address.
     * @param email - Email to search for
     * @return Optional containing user if found, empty otherwise
     */
    public Optional<User> getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    /**
     * Checks if username exists (alternative method).
     * @param username - Username to check
     * @return true if exists, false otherwise
     */
    public boolean existsByUsername(String username) {
        return userRepository.existsByUsername(username);
    }

    /**
     * Checks if email exists (alternative method).
     * @param email - Email to check
     * @return true if exists, false otherwise
     */
    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    /**
     * Retrieves all users with a specific role.
     * Used to get all admins, agencies, or regular users.
     * @param role - Role to filter by (USER, ADMIN, AGENCY)
     * @return List of users with specified role
     */
    public List<User> getUsersByRole(String role) {
        return userRepository.findByRole(role);
    }

    /**
     * Retrieves all active users (users who haven't been deactivated).
     * @return List of active users
     */
    public List<User> getActiveUsers() {
        return userRepository.findByActiveTrue();
    }

    /**
     * Updates an existing user (alternative method).
     * @param user - User object with updated information
     * @return Updated user object
     */
    public User updateUser(User user) {
        return userRepository.save(user);
    }

    /**
     * Searches for users by name using a keyword.
     * Searches in both first name and last name.
     * @param keyword - Search keyword
     * @return List of users matching the search
     */
    public List<User> searchUsers(String keyword) {
        return userRepository.searchByName(keyword);
    }
}
