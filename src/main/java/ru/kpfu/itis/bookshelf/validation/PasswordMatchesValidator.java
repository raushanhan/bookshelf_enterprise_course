package ru.kpfu.itis.bookshelf.validation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import ru.kpfu.itis.bookshelf.dto.UserRegistrationDto;

import java.util.Objects;

public class PasswordMatchesValidator implements ConstraintValidator<PasswordMatches, UserRegistrationDto> {

    @Override
    public boolean isValid(UserRegistrationDto dto, ConstraintValidatorContext constraintValidatorContext) {
        if (dto == null) return false;
        return Objects.equals(dto.password(), dto.password_repeat());
    }
}
