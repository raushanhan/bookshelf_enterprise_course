package ru.kpfu.itis.bookshelf.util;

import java.util.Map;

public class Duties {

    public static final Map<String, String> dutyRussianNames = Map.of(
            "author", "автор",
            "reader", "читатель"
    );

    public static class RoleNames {

        private static final String ROLE_ADMIN = "ROLE_ADMIN";
        private static final String ROLE_USER = "ROLE_USER";
        private static final String ROLE_MODERATOR = "ROLE_MODERATOR";
        private static final String ROLE_CONTENT_CREATOR = "ROLE_CONTENT_CREATOR";
    }
}
