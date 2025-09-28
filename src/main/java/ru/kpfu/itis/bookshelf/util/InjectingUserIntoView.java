package ru.kpfu.itis.bookshelf.util;

import org.springframework.ui.Model;
import ru.kpfu.itis.bookshelf.model.User;

public class InjectingUserIntoView {

    public static void inject(Model model, User user) {
        if (user.hasRole(Roles.ROLE_ADMIN)) {
            model.addAttribute("isAdmin", true);
        }
        if (user.hasRole(Roles.ROLE_MODERATOR)) {
            model.addAttribute("isModerator", true);
        }
    }
}
