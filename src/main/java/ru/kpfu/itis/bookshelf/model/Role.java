package ru.kpfu.itis.bookshelf.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Table(name = "roles")
public class Role {

    @Id
    private Long id;

    @Column(name = "name", nullable = false, unique = true, length = 50)
    private String name;
}
