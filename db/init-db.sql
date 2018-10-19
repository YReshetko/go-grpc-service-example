CREATE TABLE my_users (
    id SERIAL PRIMARY KEY,
    name CHARACTER VARYING(256) NOT NULL,
    surname CHARACTER VARYING(256) NOT NULL,
    is_active BOOLEAN NOT NULL default FALSE,
    age INTEGER NOT NULL
);

INSERT INTO my_users (name, surname, is_active, age) VALUES ('Yury', 'Rashetska', true, 31);
INSERT INTO my_users (name, surname, is_active, age) VALUES ('Eugene', 'Kortelyov', true, 30);