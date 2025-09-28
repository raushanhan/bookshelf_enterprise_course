package ru.kpfu.itis.bookshelf.mapper;

import org.springframework.stereotype.Component;
import ru.kpfu.itis.bookshelf.dto.UserRegistrationDto;
import ru.kpfu.itis.bookshelf.model.User;

@Component
public class UserRegistrationRequestDtoMapper {

    public User toEntity(UserRegistrationDto dto) {
        User user = new User();
        user.setEmail(dto.email());
        user.setName(dto.name());
        user.setSurname(dto.surname());
        user.setPatronymic(dto.patronymic());
        user.setUsername(dto.username());
        user.setIsBanned(false);
        return user;
    }
}
