package ru.kpfu.itis.bookshelf.service;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import ru.kpfu.itis.bookshelf.repository.UserRepository;

@Service
public class LikeService {

    private final JdbcTemplate jdbcTemplate;
    private final UserRepository userRepository;

    public LikeService(JdbcTemplate jdbcTemplate, UserRepository userRepository) {
        this.jdbcTemplate = jdbcTemplate;
        this.userRepository = userRepository;
    }

    public boolean isBookLikedByUser(Long bookId, String username) {
        Long userId = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"))
                .getId();

        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM liked_books WHERE user_id = ? AND book_id = ?",
                Integer.class, userId, bookId
        );

        return count != null && count > 0;
    }

    public void likeBook(Long bookId, String username) {
        if (!isBookLikedByUser(bookId, username)) {
            Long userId = userRepository.findByUsername(username).get().getId();
            jdbcTemplate.update(
                    "INSERT INTO liked_books (user_id, book_id) VALUES (?, ?)",
                    userId, bookId
            );
        }
    }

    public void unlikeBook(Long bookId, String username) {
        Long userId = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"))
                .getId();
        jdbcTemplate.update(
                "DELETE FROM liked_books WHERE user_id = ? AND book_id = ?",
                userId, bookId
        );
    }
}