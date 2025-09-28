package ru.kpfu.itis.bookshelf.advice;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import ru.kpfu.itis.bookshelf.model.User;
import ru.kpfu.itis.bookshelf.service.UserService;
import ru.kpfu.itis.bookshelf.util.InjectingUserIntoView;

@RequiredArgsConstructor
@ControllerAdvice
public class GlobalModelAttributeAdvice {

    private final UserService userService;

    @ModelAttribute
    public void addUserToModel(@AuthenticationPrincipal UserDetails userDetails, Model model) {
        if (userDetails != null) {
            User user = userService.findByUsername(userDetails.getUsername());
            InjectingUserIntoView.inject(model, user);
            model.addAttribute("user", user);
        }
    }
}
