package service;

import models.User;
import repository.UserRepository;
import java.util.Optional;
import org.mindrot.jbcrypt.BCrypt; // Recommended for password hashing

public class UserService {

    private final UserRepository userRepository;

    public UserService() {
        this.userRepository = new UserRepository();
    }

    /**
     * Registers a new user with a hashed password.
     */
    public boolean registerUser(String username, String plainPassword) {
        // Basic validation
        if (username == null || username.isEmpty() || plainPassword == null || plainPassword.length() < 6) {
            return false;
        }

        // Check if user already exists
        if (userRepository.findByUsername(username).isPresent()) {
            return false;
        }

        // FR5: Security - Password hashing
        String hashedPw = BCrypt.hashpw(plainPassword, BCrypt.gensalt());

        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(hashedPw);

        userRepository.save(newUser);
        return true;
    }

    /**
     * Authenticates a user.
     * Returns the User object if successful, empty if failed.
     */
    public Optional<User> login(String username, String plainPassword) {
        Optional<User> userOpt = userRepository.findByUsername(username);

        if (userOpt.isPresent()) {
            User user = userOpt.get();
            // Verify the hashed password
            if (BCrypt.checkpw(plainPassword, user.getPassword())) {
                return Optional.of(user);
            }
        }
        return Optional.empty();
    }

    /**
     * Retrieves a user by ID (Uses 2nd level cache via Repository).
     */
    public User getUserById(Long id) {
        return userRepository.findById(id);
    }
}