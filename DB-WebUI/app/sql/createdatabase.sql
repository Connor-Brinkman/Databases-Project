DROP TABLE IF EXISTS "User" CASCADE;
CREATE TABLE "User" (
    id SERIAL NOT NULL,
    email text NOT NULL UNIQUE,
    password text NOT NULL,
    nickname text NOT NULL,
    registration_date date,
    PRIMARY KEY (id),
    CONSTRAINT valid_email CHECK (email ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
    CONSTRAINT valid_nickname CHECK (nickname ~ '^[a-zA-Z0-9_]+$') --Allow underscores in Nicknames
);

DROP TABLE IF EXISTS Friend CASCADE;
CREATE TABLE Friend (
    following_user_id int NOT NULL,
    followed_user_id int NOT NULL,
    PRIMARY KEY (following_user_id, followed_user_id),
    FOREIGN KEY (following_user_id) REFERENCES "User"(id) ON DELETE CASCADE,
    FOREIGN KEY (followed_user_id) REFERENCES "User"(id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS Run CASCADE;
CREATE TABLE Run (
    id SERIAL NOT NULL,
    user_id int NOT NULL,
    level_id int NOT NULL,
    score int,
    run_time INTERVAL,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES "User"(id) ON DELETE CASCADE,
    FOREIGN KEY (level_id) REFERENCES Level(id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS World CASCADE;
CREATE TABLE World (
    id int PRIMARY KEY,
    name text,
    difficulty int,
    theme text,
    soundtrack text
);
COMMENT ON COLUMN World.soundtrack IS 'URL to soundtrack file';

DROP TABLE IF EXISTS Level CASCADE;
CREATE TABLE Level (
    id int NOT NULL,
    world_id int NOT NULL,
    name text NOT NULL,
    coins int,
    PRIMARY KEY (id),
    FOREIGN KEY (world_id) REFERENCES World(id)
);

DROP TABLE IF EXISTS Monster CASCADE;
CREATE TABLE Monster (
    id int PRIMARY KEY,
    health int,
    damage int
);

DROP TABLE IF EXISTS Contains CASCADE;
CREATE TABLE Contains (
    world_id int,
    monster_id int,
    PRIMARY KEY (world_id, monster_id),
    FOREIGN KEY (world_id) REFERENCES World(id),
    FOREIGN KEY (monster_id) REFERENCES Monster(id)
);

DROP TABLE IF EXISTS Pouncer CASCADE;
CREATE TABLE Pouncer (
    monster_id int PRIMARY KEY,
    pounce_height int,
    FOREIGN KEY (monster_id) REFERENCES Monster(id)
);

DROP TABLE IF EXISTS Walker CASCADE;
CREATE TABLE Walker (
    monster_id int PRIMARY KEY,
    walk_speed int,
    FOREIGN KEY (monster_id) REFERENCES Monster(id)
);

DROP TABLE IF EXISTS Flyer CASCADE;
CREATE TABLE Flyer (
    monster_id int PRIMARY KEY,
    fly_direction int,
    FOREIGN KEY (monster_id) REFERENCES Monster(id)
)