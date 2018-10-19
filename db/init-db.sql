CREATE TABLE my_users (
    id INTEGER NOT NULL,
    name CHARACTER VARYING(256) NOT NULL,
    surname CHARACTER VARYING(256) NOT NULL,
    is_active BOOLEAN NOT NULL default FALSE,
    age INTEGER NOT NULL
);

INSERT INTO my_users (id, name, surname, is_active, age) VALUES (1, 'Yury', 'Rashetska', true, 31);
INSERT INTO my_users (id, name, surname, is_active, age) VALUES (2, 'Eugene', 'Kortelyov', true, 30);