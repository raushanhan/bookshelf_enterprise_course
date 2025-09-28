package ru.kpfu.itis.bookshelf.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import ru.kpfu.itis.bookshelf.model.Book;
import ru.kpfu.itis.bookshelf.model.User;
import ru.kpfu.itis.bookshelf.service.BookService;
import ru.kpfu.itis.bookshelf.service.LikeService;
import java.util.Optional;

@Controller
@RequiredArgsConstructor
@RequestMapping("/book/{id}")
public class BookController {

    private final BookService bookService;
    private final LikeService likeService;

    @GetMapping("/read")
    public String readBook(@PathVariable("id") Long id, Model model) {
        Optional<Book> bookOpt = bookService.findById(id);
        if (bookOpt.isEmpty()) {
            return "error/404";
        }

        Book book = bookOpt.get();

        User author = book.getAuthor();

        model.addAttribute("book", book);
        model.addAttribute("author", author);

        model.addAttribute("lastUpdateDate", book.getDateOfLastUpdate());

        return "book-reading";
    }

    @GetMapping()
    public String bookDescription(@AuthenticationPrincipal UserDetails userDetails, @PathVariable("id") Long id, Model model) {
        Optional<Book> bookOpt = bookService.findById(id);
        if (bookOpt.isEmpty()) {
            return "error/404";
        }
        Book book = bookOpt.get();
        model.addAttribute("book", book);

        if (userDetails != null) {
            boolean likedAlready = likeService.isBookLikedByUser(id, userDetails.getUsername());
            model.addAttribute("likedAlready", likedAlready);
        }

        return "book-description";
    }

    @PostMapping("/like")
    public String likeBook(@AuthenticationPrincipal UserDetails userDetails, @PathVariable("id") Long id, Model model) {
        likeService.likeBook(id, userDetails.getUsername());
        return "redirect:/book/" + id;
    }

    @PostMapping("/unlike")
    public String unlikeBook(@AuthenticationPrincipal UserDetails userDetails, @PathVariable Long id) {
        likeService.unlikeBook(id, userDetails.getUsername());
        return "redirect:/book/" + id;
    }

}