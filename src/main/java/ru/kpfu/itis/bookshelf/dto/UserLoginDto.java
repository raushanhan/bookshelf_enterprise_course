package ru.kpfu.itis.bookshelf.dto;

public record UserLoginDto(
        String email,
        String password
) {
}
