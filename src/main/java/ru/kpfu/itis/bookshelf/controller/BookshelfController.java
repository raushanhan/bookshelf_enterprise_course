package ru.kpfu.itis.bookshelf.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import ru.kpfu.itis.bookshelf.model.Book;
import ru.kpfu.itis.bookshelf.model.User;
import ru.kpfu.itis.bookshelf.repository.LikedBookRepository;
import ru.kpfu.itis.bookshelf.repository.UserRepository;
import ru.kpfu.itis.bookshelf.model.LikedBook;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/bookshelf")
public class BookshelfController {

    private final LikedBookRepository likedBookRepository;
    private final UserRepository userRepository;

    public BookshelfController(LikedBookRepository likedBookRepository, UserRepository userRepository) {
        this.likedBookRepository = likedBookRepository;
        this.userRepository = userRepository;
    }

    @GetMapping
    public String getBookshelf(Model model, @AuthenticationPrincipal UserDetails userDetails) {

        String username = userDetails.getUsername();
        Optional<User> optionalUser = userRepository.findByUsername(username);

        User user = optionalUser.get();
        List<LikedBook> likedBooks = likedBookRepository.findAllByUser(user);

        List<Book> books = likedBooks.stream()
                .map(LikedBook::getBook)
                .collect(Collectors.toList());

        model.addAttribute("likedBooks", books);
        model.addAttribute("user", user);

        return "bookshelf";
    }
}