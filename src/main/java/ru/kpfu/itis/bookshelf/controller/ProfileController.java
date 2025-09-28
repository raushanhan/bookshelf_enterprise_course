package ru.kpfu.itis.bookshelf.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import ru.kpfu.itis.bookshelf.model.Duty;
import ru.kpfu.itis.bookshelf.model.User;
import ru.kpfu.itis.bookshelf.service.DutyService;
import ru.kpfu.itis.bookshelf.service.UserService;
import ru.kpfu.itis.bookshelf.util.Duties;


@Controller
@RequiredArgsConstructor
@RequestMapping("/profile")
public class ProfileController {

    private final DutyService dutyService;
    private final UserService userService;

    @GetMapping("/{username}")
    public String profilePage(
            @PathVariable String username,
            Model model
    ) {
        model.addAttribute("allDuties", dutyService.getAllDuty());
        if (!userService.existsByUsername(username)) {
            model.addAttribute("userNotFound", true);
            return "profile";
        }
        User profileOwner = userService.findByUsername(username);
        model.addAttribute("profileOwner", profileOwner);
        model.addAttribute("dutyNames", Duties.dutyRussianNames);
        return "profile";
    }

    @PostMapping("/update-duty")
    public String updateDuty(@RequestParam("dutyId") Long dutyId, @AuthenticationPrincipal UserDetails userDetails) {
        User user = userService.findByUsername(userDetails.getUsername());
        Duty newDuty = dutyService.findById(dutyId).orElse(null);
        user.setDuty(newDuty);
        userService.save(user);
        return "redirect:/profile/" + user.getUsername();
    }
}
