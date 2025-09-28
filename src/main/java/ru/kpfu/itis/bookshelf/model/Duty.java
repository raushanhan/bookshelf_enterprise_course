package ru.kpfu.itis.bookshelf.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Table(name = "duties")
public class Duty {


    @Id
    private Long id;

    @Column(name = "name", nullable = false, unique = true, length = 50)
    private String name;
}
