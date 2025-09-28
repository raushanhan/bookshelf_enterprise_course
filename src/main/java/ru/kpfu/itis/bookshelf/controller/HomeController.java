package ru.kpfu.itis.bookshelf.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import ru.kpfu.itis.bookshelf.model.Genre;
import ru.kpfu.itis.bookshelf.repository.GenreRepository;

import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/home")
public class HomeController {

    private final GenreRepository genreRepository;

    @GetMapping
    public String homePage(@AuthenticationPrincipal UserDetails userDetails, Model model) {
        List<Genre> genres = genreRepository.findAllWithBooks();
        model.addAttribute("genres", genres);
        return "home";
    }
}
