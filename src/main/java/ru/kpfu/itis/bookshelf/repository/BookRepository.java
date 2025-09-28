package ru.kpfu.itis.bookshelf.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.kpfu.itis.bookshelf.model.Book;
import ru.kpfu.itis.bookshelf.model.Duty;

@Repository
public interface BookRepository extends JpaRepository<Book, Long> {


}
