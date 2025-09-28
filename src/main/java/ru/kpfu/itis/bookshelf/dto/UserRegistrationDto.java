package ru.kpfu.itis.bookshelf.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import ru.kpfu.itis.bookshelf.validation.PasswordMatches;

@PasswordMatches
public record UserRegistrationDto(
        @NotBlank(message = "Имя пользователя не должно быть пустым")
        @Size(min = 3, max = 20, message = "Имя пользователя должно быть от 3 до 20 символов")
        String username,

        @Size(max = 50, message = "Имя не должно превышать 50 символов")
        String name,

        @Size(max = 50, message = "Фамилия не должна превышать 50 символов")
        String surname,

        @Size(max = 50, message = "Отчество не должно превышать 50 символов")
        String patronymic,

        @NotBlank(message = "Email не должен быть пустым")
        @Email(message = "Некорректный формат email")
        String email,

        @NotBlank(message = "Введите пароль")
        @Size(min = 6, max = 100, message = "Пароль должен быть от 6 до 100 символов")
        String password,

        @NotBlank(message = "Повторите пароль")
        String password_repeat
) {
        public static UserRegistrationDto getEmptyDto() {
                return new UserRegistrationDto(null, null, null, null, null, null, null);
        }
}