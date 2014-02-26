CREATE TABLE cat_houses(
  id INTEGER PRIMARY KEY,
  color VARCHAR(255) NOT NULL
);

CREATE TABLE cats (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER NOT NULL,
  cat_house_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES human(id)
  FOREIGN KEY(cat_house_id) REFERENCES cat_houses(id)
);

CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER NOT NULL,

  FOREIGN KEY(house_id) REFERENCES human(id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

CREATE TABLE windows (
  id INTEGER PRIMARY KEY,
  house_id INTEGER NOT NULL,

  FOREIGN KEY(house_id) REFERENCES houses(id)
);

INSERT INTO
  cat_houses (color)
VALUES
  ("brown"), ("blue"), ("pink"), ("gold");
INSERT INTO
  houses (address)
VALUES
  ("26th and Guerrero"), ("Dolores and Market");

INSERT INTO
  humans (fname, lname, house_id)
VALUES
  ("Devon", "Watts", 1), ("Matt", "Rubens", 1), ("Ned", "Ruggeri", 2);

INSERT INTO
  cats (name, owner_id, cat_house_id)
VALUES
  ("Breakfast", 1, 1), ("Earl", 2, 2), ("Haskell", 3, 3), ("Markov", 3, 4);

INSERT INTO
  windows (house_id)
VALUES
  (1), (1), (1), (1);
