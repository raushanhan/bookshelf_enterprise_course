INSERT INTO genres(id, name)
VALUES
    (1, 'Фэнтези'),
    (2, 'Научная фантастика'),
    (3, 'Детектив'),
    (4, 'Романтика'),
    (5, 'Ужасы'),
    (6, 'Приключения'),
    (7, 'Историческая проза'),
    (8, 'Юмор'),
    (9, 'Психология'),
    (10, 'Драма');

INSERT INTO roles(name)
VALUES ('ROLE_ADMIN'),
       ('ROLE_USER'),
       ('ROLE_MODERATOR');


INSERT INTO duties(id, name)
VALUES (1, 'author'),
       (2, 'reader');