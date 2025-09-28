package ru.kpfu.itis.bookshelf.advice;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.NoHandlerFoundException;
import ru.kpfu.itis.bookshelf.model.User;
import ru.kpfu.itis.bookshelf.service.UserService;
import ru.kpfu.itis.bookshelf.util.InjectingUserIntoView;

@Slf4j
@RequiredArgsConstructor
@ControllerAdvice
public class GlobalExceptionHandler {

    private final UserService userService;

    @ExceptionHandler(Exception.class)
    public String handleException(
            @AuthenticationPrincipal UserDetails userDetails,
            Exception ex,
            Model model) {
        log.error(ex.getMessage(), ex);
        if (userDetails != null) {
            User user = userService.findByUsername(userDetails.getUsername());
            InjectingUserIntoView.inject(model, user);
            model.addAttribute("user", user);
        }
        model.addAttribute("message", ex.getMessage());
        return "error/base-error";
    }

    @ExceptionHandler(NoHandlerFoundException.class)
    public String handle404(
            @AuthenticationPrincipal UserDetails userDetails,
            NoHandlerFoundException ex,
            Model model) {
        log.warn("404 Not Found: " + ex.getRequestURL());
        if (userDetails != null) {
            User user = userService.findByUsername(userDetails.getUsername());
            InjectingUserIntoView.inject(model, user);
            model.addAttribute("user", user);
        }
        model.addAttribute("message", "Страница не найдена");
        return "error/404";
    }
}
