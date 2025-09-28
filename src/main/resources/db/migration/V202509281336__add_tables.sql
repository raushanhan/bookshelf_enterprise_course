CREATE TABLE users
(
    id              BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    username        VARCHAR(50)  not null unique,
    name            VARCHAR(50),
    surname         VARCHAR(50),
    patronymic      VARCHAR(50),
    email           varchar(255) not null unique,
    hashed_password VARCHAR(255) not null,
    is_banned       BOOLEAN      NOT NULL DEFAULT FALSE,
    duty            INT
);

CREATE TABLE duties
(
    id   INT PRIMARY KEY,
    name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE roles
(
    id   BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE user_roles
(
    id      BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT NOT NULL REFERENCES users (id),
    role_id INT    NOT NULL REFERENCES roles (id)
);

CREATE TABLE genres
(
    id   BIGINT PRIMARY KEY,
    name VARCHAR(20)
);

CREATE TABLE books
(
    id                  BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    author_id           BIGINT       NOT NULL REFERENCES users (id),
    title               VARCHAR(100) NOT NULL,
    text                TEXT         NOT NULL,
    description         VARCHAR(300) NOT NULL,
    genre_id               BIGINT REFERENCES genres (id),
    date_of_creation    TIMESTAMP,
    date_of_last_update TIMESTAMP,
    cover_url           TEXT
);

CREATE TABLE liked_books
(
    id      BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT NOT NULL REFERENCES users (id),
    book_id BIGINT NOT NULL REFERENCES books (id)
);

CREATE TABLE currently_reading
(
    id      BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT NOT NULL REFERENCES users (id),
    book_id BIGINT NOT NULL REFERENCES books (id)
);



