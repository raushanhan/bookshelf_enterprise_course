package ru.kpfu.itis.bookshelf.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kpfu.itis.bookshelf.dto.UserRegistrationDto;
import ru.kpfu.itis.bookshelf.mapper.UserRegistrationRequestDtoMapper;
import ru.kpfu.itis.bookshelf.model.Role;
import ru.kpfu.itis.bookshelf.model.User;
import ru.kpfu.itis.bookshelf.repository.RoleRepository;
import ru.kpfu.itis.bookshelf.repository.UserRepository;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;
    private final UserRegistrationRequestDtoMapper userRegistrationRequestDtoMapper;

    @Transactional
    public User registerUser(UserRegistrationDto userRegistrationDto) {
        User user = userRegistrationRequestDtoMapper.toEntity(userRegistrationDto);
        user.setPassword(passwordEncoder.encode(userRegistrationDto.password()));
        User userEntity = userRepository.save(user);
        assignRoleToUser(userEntity, "ROLE_USER");
        return userEntity;
    }

    @Transactional
    public void assignRoleToUser(Long userId, String roleName) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Пользователь не найден"));

        Role role = roleRepository.findByName(roleName)
                .orElseThrow(() -> new RuntimeException("Роль не найдена"));

        user.getRoles().add(role);
        userRepository.save(user);
    }

    @Transactional
    public void assignRoleToUser(User user, String roleName) {
        Role role = roleRepository.findByName(roleName)
                .orElseThrow(() -> new RuntimeException("Роль не найдена"));

        log.warn("assigning role to user: " + user);
        user.getRoles().add(role);
        userRepository.save(user);
    }

    public boolean existsByUsername(String username) {
        return userRepository.findByUsername(username).isPresent();
    }

    public boolean existsByEmail(String email) {
        return userRepository.findByEmail(email).isPresent();
    }

    public User findByUsername(String username) {
        return userRepository.findByUsername(username).orElse(null);
    }

    public User findById(Long id) {
        return userRepository.findById(id).orElse(null);
    }

    public List<User> findAll() {
        return userRepository.findAll();
    }

    public void save(User user) {
        userRepository.save(user);
    }
}
