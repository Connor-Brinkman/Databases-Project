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
);

-- INSERT SOME MOCK DATA
INSERT INTO "User" (email, password, nickname, registration_date) VALUES
('frank.miller@sample.com', 'ComplexPwd#1', 'FrankM', '2024-09-01'),
('grace_williams@service.info', 'SafeGuard!', 'GraceW', '2024-10-12'),
('henry.davis77@email.eu', 'KeyToLock', 'HenryD77', '2024-12-25'),
('ivy.moore@network.biz', 'SecureItNow', 'Ivy_M', '2025-02-18'),
('jack.taylor@online.cc', 'PassPhrase', 'JackT', '2025-03-05'),
('kelly.adams@web.tv', 'SecretCode', 'KellyA', '2024-07-22'),
('liam_evans@digitalage.tech', 'HiddenWord', 'LiamE', '2025-01-17'),
('mia.baker.01@cloud.space', 'StrongKey!', 'MiaB01', '2024-11-01'),
('noah.clark@global.int', 'SafePass123', 'NoahC', '2025-04-10'),
('olivia.hall@connect.me', 'MyPassword', 'OliviaH', '2024-08-29'),
('peter_green@access.net', 'SecureAccess', 'Peter_G', '2025-02-28'),
('quinn.white@data.info', 'ThePassword', 'QuinnW', '2024-12-10'),
('ryan.harris@internet.org', 'AnotherPwd', 'RyanH', '2025-03-22'),
('sophia.martin@ecom.shop', 'JustSecure', 'SophiaM', '2024-09-18'),
('thomas.king.99@mail.co', 'BestPasswd', 'ThomasK99', '2025-04-05');

INSERT INTO Friend (following_user_id, followed_user_id) VALUES
(1, 2),   
(1, 5), 
(2, 3),   
(2, 7),   
(3, 1),   
(4, 6),   
(5, 9),  
(6, 10),  
(7, 4),   
(8, 12),  
(9, 15),  
(10, 8),  
(11, 13), 
(12, 14), 
(13, 11),
(14, 1),  
(15, 2),  
(3, 5),   
(6, 8);   

INSERT INTO World (id, name, difficulty, theme, soundtrack) VALUES
(1, 'Mysterious Forest', 3, 'Nature', 'https://example.com/forest_ambience.mp3'),
(2, 'Volcanic Peak', 7, 'Fire', 'https://example.com/epic_battle_music.ogg'),
(3, 'Underwater Kingdom', 5, 'Water', 'https://example.com/calm_ocean_waves.wav');

INSERT INTO Level (id, world_id, name, coins) VALUES
(1, 1, 'Forest Trail', 10),
(2, 1, 'Hidden Grove', 25),
(3, 2, 'Lava Flow', 15),
(4, 2, 'Summit Ascent', 30),
(5, 3, 'Coral Reef', 20),
(6, 3, 'Abyssal Trench', 35);

INSERT INTO Run (user_id, level_id, score, run_time) VALUES
(1, 1, 150, '00:02:30'),
(2, 1, 120, '00:03:00'),
(3, 2, 200, '00:04:15'),
(4, 3, 180, '00:03:45'),
(5, 3, 220, '00:05:00'),
(6, 4, 250, '00:06:00'),
(7, 4, 230, '00:05:45'),
(8, 5, 190, '00:04:00'),
(9, 5, 210, '00:04:30'),
(10, 6, 240, '00:05:30'),
(11, 1, 170, '00:02:45'),
(12, 2, 195, '00:04:00'),
(13, 3, 160, '00:03:30'),
(14, 4, 260, '00:06:15'),
(15, 5, 200, '00:04:10'),
(1, 3, 190, '00:04:00'),
(2, 4, 240, '00:05:50'),
(3, 6, 220, '00:05:10');