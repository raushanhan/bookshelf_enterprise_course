package ru.kpfu.itis.bookshelf.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.kpfu.itis.bookshelf.model.LikedBook;
import ru.kpfu.itis.bookshelf.model.User;
import java.util.List;

public interface LikedBookRepository extends JpaRepository<LikedBook, Long> {
    List<LikedBook> findAllByUser(User user);

//    @Query("SELECT b.title, COUNT(lb.id) AS likes_count" +
//            " FROM Book b" +
//            " LEFT JOIN LikedBook lb ON b.id = lb.book.id" +
//            " GROUP BY b.id" +
//            " HAVING COUNT(lb.id) >= (" +
//            "     SELECT AVG(likes) " +
//            "     FROM (" +
//            "         SELECT COUNT(id) AS likes" +
//            "         FROM LikedBook" +
//            "         GROUP BY book.id" +
//            "     ) AS avg_likes" +
//            ")" +
//            " ORDER BY likes_count DESC")
//    Optional<LikedBook> findMostLikedBook();
}
