package ru.kpfu.itis.bookshelf.controller;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import ru.kpfu.itis.bookshelf.model.User;
import ru.kpfu.itis.bookshelf.service.UserService;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {

    private final UserService userService;

    @GetMapping
    public String adminPage(@AuthenticationPrincipal UserDetails userDetails, Model model) {

        List<User> users = userService.findAll();
        model.addAttribute("users", users);

        User user = new User();
        return "admin";
    }

    @PostMapping("/ban/{user_id}")
    public ResponseEntity<?> banUser(
            @PathVariable Long user_id,
            HttpServletRequest request
    ) {
        User user = userService.findById(user_id);
        if (user == null) {
            return handleError(request, "User not found", HttpStatus.NOT_FOUND);
        }

        user.setIsBanned(true);
        userService.save(user);

        return handleSuccess(request, "User banned");
    }

    @PostMapping("/unban/{user_id}")
    public ResponseEntity<?> unbanUser(
            @PathVariable Long user_id,
            HttpServletRequest request
    ) {
        User user = userService.findById(user_id);
        if (user == null) {
            return handleError(request, "User not found", HttpStatus.NOT_FOUND);
        }

        user.setIsBanned(false);
        userService.save(user);

        return handleSuccess(request, "User unbanned");
    }

    private ResponseEntity<?> handleSuccess(HttpServletRequest request, String message) {
        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            // Это AJAX-запрос
            return ResponseEntity.ok(message);
        } else {
            // Это обычный POST — редирект
            return ResponseEntity.status(HttpStatus.FOUND)
                    .header("Location", "/admin")
                    .build();
        }
    }

    private ResponseEntity<?> handleError(HttpServletRequest request, String message, HttpStatus status) {
        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            return ResponseEntity.status(status).body(message);
        } else {
            return ResponseEntity.status(HttpStatus.FOUND)
                    .header("Location", "/admin")
                    .build();
        }
    }
}
