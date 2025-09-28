-- Пользователи (2 автора и 2 читателя)
INSERT INTO users (username, name, surname, patronymic, email, hashed_password, duty)
VALUES
    ('akmal_fantasy', 'Акмал', 'Ибрагимов', 'Равилевич', 'akmal@example.com', 'hashed_pwd1', 1), -- автор
    ('alsu_romance', 'Алсу', 'Галиуллина', 'Ильдаровна', 'alsu@example.com', 'hashed_pwd2', 1), -- автор
    ('dina_reader', 'Дина', 'Хасанова', 'Фанусовна', 'dina@example.com', 'hashed_pwd3', 2),    -- читатель
    ('timur_reader', 'Тимур', 'Фазлыев', 'Ильгизарович', 'timur@example.com', 'hashed_pwd4', 2); -- читатель


-- Назначаем роли (все юзеры будут ROLE_USER, а один ещё ROLE_ADMIN)
INSERT INTO user_roles (user_id, role_id)
VALUES
    (1, 2), -- Акмал как пользователь
    (2, 2), -- Алсу как пользователь
    (3, 2), -- Дина как пользователь
    (4, 2), -- Тимур как пользователь
    (1, 1); -- Акмал ещё и админ


-- Книги
INSERT INTO books (author_id, title, text, description, genre_id, date_of_creation, date_of_last_update, cover_url)
VALUES
    (1, 'Крылья Тагана', 'Текст книги о волшебных существах...',
     'Фэнтези-история про мальчика, нашедшего крылья дракона.',
     1, NOW(), NOW(), 'covers/krylya_tagana.jpg'),

    (1, 'Путь сквозь звёзды', 'Текст книги о полётах к далёким мирам...',
     'Научная фантастика о космическом путешествии и встрече с иной цивилизацией.',
     2, NOW(), NOW(), 'covers/put_skvoz_zvezdy.jpg'),

    (2, 'Тайна сердца', 'Текст романтической истории...',
     'Романтика про судьбоносную встречу в Казани.',
     4, NOW(), NOW(), 'covers/taina_serdtsa.jpg'),

    (2, 'Дом на окраине', 'Текст мистической повести...',
     'Ужасы о старом доме, где оживают воспоминания.',
     5, NOW(), NOW(), 'covers/dom_na_okraine.jpg');


-- Читатели добавляют в "понравившиеся" книги
INSERT INTO liked_books (user_id, book_id)
VALUES
    (3, 1), -- Дина лайкнула "Крылья Тагана"
    (3, 3), -- Дина лайкнула "Тайна сердца"
    (4, 2), -- Тимур лайкнул "Путь сквозь звёзды"
    (4, 4); -- Тимур лайкнул "Дом на окраине"


-- Читатели отмечают "читаю сейчас"
INSERT INTO currently_reading (user_id, book_id)
VALUES
    (3, 2), -- Дина сейчас читает "Путь сквозь звёзды"
    (4, 3); -- Тимур сейчас читает "Тайна сердца"