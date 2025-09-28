package ru.kpfu.itis.bookshelf.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import ru.kpfu.itis.bookshelf.dto.UserRegistrationDto;
import ru.kpfu.itis.bookshelf.service.UserService;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AuthController {

    private final UserService userService;

    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("form", UserRegistrationDto.getEmptyDto());
        model.addAttribute("fieldErrors", new HashMap<>());
        return "register";
    }

    @PostMapping("/register")
    public String registerUser(
            @Valid @ModelAttribute UserRegistrationDto dto,
            BindingResult bindingResult,
            Model model,
            HttpServletRequest request) {
        model.addAttribute("form", dto);
        model.addAttribute("fieldErrors", new HashMap<>());
        if (bindingResult.hasErrors()) {
            log.error(dto.toString());
            log.error("errors in validating registration form:\n" + bindingResult.getAllErrors());
            Map<String, String> errors = bindingResult.getFieldErrors()
                    .stream()
                    .collect(Collectors.toMap(
                            FieldError::getField,
                            fe -> Objects.requireNonNullElse(fe.getDefaultMessage(), "Ошибка в поле"),
                            (message1, message2) -> message1
                    ));
            model.addAttribute("fieldErrors", errors);
            log.error("Validation errors: " + errors);
            return "redirect:/register";
        }

        log.info("Registering user: " + dto.toString());

        if (userService.existsByUsername(dto.username())) {
            model.addAttribute("usernameAlreadyExistsError", "Данное имя пользователя уже занято");
        }
        if (userService.existsByEmail(dto.email())) {
            model.addAttribute("emailAlreadyExistsError", "Данный email уже занят");
        }
        if (model.containsAttribute("emailAlreadyExistsError") || model.containsAttribute("usernameAlreadyExistsError")) {
            return "redirect:/register";
        }

        userService.registerUser(dto);

        try {
            request.login(dto.username(), dto.password()); // ты должен передавать оригинальный пароль (НЕ захешированный!)
        } catch (ServletException e) {
            e.printStackTrace();
            return "redirect:/login?error";
        }

        return "redirect:/home";
    }

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }
}
