package ru.kpfu.itis.bookshelf.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import ru.kpfu.itis.bookshelf.model.Duty;
import ru.kpfu.itis.bookshelf.repository.DutyRepository;

import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class DutyService {

    private final DutyRepository dutyRepository;

    public List<Duty> getAllDuty() {
        return dutyRepository.findAll();
    }

    public Optional<Duty> findById(Long id) {
        return dutyRepository.findById(id);
    }
}
