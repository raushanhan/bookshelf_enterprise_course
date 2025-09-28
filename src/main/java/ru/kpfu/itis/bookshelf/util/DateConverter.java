package ru.kpfu.itis.bookshelf.util;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class DateConverter {

    public static Date fromLocalDateTime(LocalDateTime ldt) {

        if (ldt != null) {
            return Date.from(ldt.atZone(ZoneId.systemDefault()).toInstant());
        }
        return null;
    }
}
