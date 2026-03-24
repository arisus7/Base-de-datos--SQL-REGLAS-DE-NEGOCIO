-- ============================================================
--  RecordingLabelsDB  –  SQLite version
--  Ejecuta con:  sqlite3 recording_labels.db < setup_db.sql
-- ============================================================

PRAGMA foreign_keys = ON;

-- ── Tablas ──────────────────────────────────────────────────
-- NOTA: YearY va primero porque TopCDs y TopSongs referencian su PK

CREATE TABLE IF NOT EXISTS YearY (
    year  TEXT NOT NULL,   -- formato 'YYYY'
    CONSTRAINT PK_YearY PRIMARY KEY (year)
);

CREATE TABLE IF NOT EXISTS RecordingLabels (
    labelId    INTEGER PRIMARY KEY AUTOINCREMENT,
    labelName  VARCHAR(50) NOT NULL,
    location   VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Artists (
    artistId   INTEGER PRIMARY KEY AUTOINCREMENT,
    firstName  VARCHAR(50) NOT NULL,
    lastName   VARCHAR(50),
    yearBorn   TEXT NOT NULL   -- formato 'YYYY-MM-DD'
);

CREATE TABLE IF NOT EXISTS MusicalGroups (
    groupCode  INTEGER PRIMARY KEY AUTOINCREMENT,
    groupName  VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Member (
    artistId   INTEGER NOT NULL,
    groupCode  INTEGER NOT NULL,
    formDate   TEXT    NOT NULL,
    toDate     TEXT,
    CONSTRAINT PK_Member PRIMARY KEY (artistId, groupCode),
    CONSTRAINT FK_Member_Artists       FOREIGN KEY (artistId)  REFERENCES Artists(artistId),
    CONSTRAINT FK_Member_MusicalGroups FOREIGN KEY (groupCode) REFERENCES MusicalGroups(groupCode)
);

CREATE TABLE IF NOT EXISTS CDTitles (
    cdCode      INTEGER PRIMARY KEY AUTOINCREMENT,
    cdTitle     VARCHAR(50) NOT NULL,
    numberSold  INTEGER     NOT NULL,
    year        TEXT        NOT NULL,
    labelId     INTEGER     NOT NULL,
    groupCode   INTEGER     NOT NULL,
    CONSTRAINT FK_CDTitles_RecordingLabels FOREIGN KEY (labelId)   REFERENCES RecordingLabels(labelId),
    CONSTRAINT FK_CDTitles_MusicalGroups   FOREIGN KEY (groupCode) REFERENCES MusicalGroups(groupCode)
);

CREATE TABLE IF NOT EXISTS SongTitles (
    songCode   INTEGER PRIMARY KEY AUTOINCREMENT,
    songTitle  VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS ComposedOf (
    cdCode       INTEGER NOT NULL,
    songCode     INTEGER NOT NULL,
    trackNumber  INTEGER NOT NULL,
    CONSTRAINT PK_ComposedOf PRIMARY KEY (cdCode, songCode),
    CONSTRAINT FK_ComposedOf_CDTitles   FOREIGN KEY (cdCode)   REFERENCES CDTitles(cdCode),
    CONSTRAINT FK_ComposedOf_SongTitles FOREIGN KEY (songCode) REFERENCES SongTitles(songCode)
);

CREATE TABLE IF NOT EXISTS WrittenBy (
    songCode  INTEGER NOT NULL,
    artistId  INTEGER NOT NULL,
    CONSTRAINT PK_WrittenBy PRIMARY KEY (songCode, artistId),
    CONSTRAINT FK_WrittenBy_SongTitles FOREIGN KEY (songCode)  REFERENCES SongTitles(songCode),
    CONSTRAINT FK_WrittenBy_Artists    FOREIGN KEY (artistId)  REFERENCES Artists(artistId)
);

CREATE TABLE IF NOT EXISTS TopCDs (
    year    TEXT    NOT NULL,
    cdCode  INTEGER NOT NULL,
    rating  CHAR(10) NOT NULL,
    CONSTRAINT PK_TopCDs PRIMARY KEY (year, cdCode),
    CONSTRAINT FK_TopCDs_YearY    FOREIGN KEY (year)   REFERENCES YearY(year),
    CONSTRAINT FK_TopCDs_CDTitles FOREIGN KEY (cdCode) REFERENCES CDTitles(cdCode)
);

CREATE TABLE IF NOT EXISTS TopSongs (
    year      TEXT     NOT NULL,
    songCode  INTEGER  NOT NULL,
    rating    CHAR(10) NOT NULL,
    CONSTRAINT PK_TopSongs PRIMARY KEY (year, songCode),
    CONSTRAINT FK_TopSongs_YearY      FOREIGN KEY (year)     REFERENCES YearY(year),
    CONSTRAINT FK_TopSongs_SongTitles FOREIGN KEY (songCode) REFERENCES SongTitles(songCode)
);

-- ── Datos de ejemplo ─────────────────────────────────────────

INSERT INTO YearY VALUES ('2018'),('2019'),('2020'),('2021'),('2022'),('2023');

INSERT INTO RecordingLabels (labelName, location) VALUES
    ('Warner',   'USA'),
    ('Sony',     'USA'),
    ('Televisa', 'Mex'),
    ('Universal','USA'),
    ('EMI',      'UK');

INSERT INTO Artists (firstName, lastName, yearBorn) VALUES
    ('Michael', 'Jackson',  '1958-08-29'),
    ('Beyoncé',  NULL,       '1981-09-04'),
    ('Ed',      'Sheeran',  '1991-02-17'),
    ('Taylor',  'Swift',    '1989-12-13'),
    ('Bruno',   'Mars',     '1985-10-08'),
    ('Adele',   'Adkins',   '1988-05-05'),
    ('Drake',   'Graham',   '1986-10-24'),
    ('Billie',  'Eilish',   '2001-12-18'),
    ('Shakira', 'Mebarak',  '1977-02-02'),
    ('Bad',     'Bunny',    '1994-03-10');

INSERT INTO MusicalGroups (groupName) VALUES
    ('The Beatles'),
    ('BTS'),
    ('Maroon 5'),
    ('Coldplay'),
    ('Black Eyed Peas');

INSERT INTO Member (artistId, groupCode, formDate, toDate) VALUES
    (1, 3, '2010-01-01', NULL),
    (2, 3, '2010-01-01', '2020-12-31'),
    (3, 4, '2012-06-01', NULL),
    (4, 4, '2012-06-01', '2019-03-01'),
    (5, 5, '2009-01-01', NULL),
    (6, 5, '2009-01-01', '2018-05-01'),
    (7, 1, '2000-01-01', NULL),
    (8, 2, '2018-01-01', NULL),
    (9, 2, '2018-01-01', NULL),
    (10,2, '2018-01-01', NULL);

INSERT INTO CDTitles (cdTitle, numberSold, year, labelId, groupCode) VALUES
    ('Thriller',             1000000, '2018', 1, 3),
    ('Lemonade',              850000, '2018', 2, 4),
    ('Divide',                760000, '2019', 1, 5),
    ('Reputation',            900000, '2019', 3, 1),
    ('24K Magic',             700000, '2020', 2, 3),
    ('25',                    650000, '2020', 4, 4),
    ('Scorpion',              580000, '2021', 2, 5),
    ('When We All Fall Asleep',610000,'2021', 1, 2),
    ('El Último Tour',        540000, '2022', 3, 2),
    ('Music of the Spheres',  720000, '2022', 4, 4),
    ('Midnights',             870000, '2023', 1, 1),
    ('Renaissance',           810000, '2023', 2, 3);

INSERT INTO SongTitles (songTitle) VALUES
    ('Billie Jean'),
    ('Crazy in Love'),
    ('Shape of You'),
    ('Love Story'),
    ('Uptown Funk'),
    ('Hello'),
    ('God''s Plan'),
    ('Bad Guy'),
    ('Hips Don''t Lie'),
    ('Tití Me Preguntó'),
    ('Anti-Hero'),
    ('Break My Soul');

INSERT INTO ComposedOf (cdCode, songCode, trackNumber) VALUES
    (1, 1, 1),(1, 2, 2),(1, 3, 3),
    (2, 2, 1),(2, 4, 2),(2, 5, 3),
    (3, 3, 1),(3, 6, 2),(3, 7, 3),
    (4, 4, 1),(4, 8, 2),(4, 9, 3),
    (5, 5, 1),(5,10, 2),(5,11, 3),
    (6, 6, 1),(6, 1, 2),(6, 2, 3),
    (7, 7, 1),(7, 3, 2),(7, 4, 3),
    (8, 8, 1),(8, 5, 2),(8, 6, 3),
    (9,10, 1),(9,11, 2),(9,12, 3),
    (10,9, 1),(10,1, 2),(10,2, 3),
    (11,11,1),(11,3, 2),(11,4, 3),
    (12,12,1),(12,5, 2),(12,6, 3);

INSERT INTO WrittenBy (songCode, artistId) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10),
    (11,4),(12,2),(3,5),(4,6),(5,7);

INSERT OR IGNORE INTO YearY VALUES ('2018'),('2019'),('2020'),('2021'),('2022'),('2023');

INSERT INTO TopCDs (year, cdCode, rating) VALUES
    ('2018',1,'Gold'),
    ('2018',2,'Platinum'),
    ('2019',3,'Gold'),
    ('2019',4,'Platinum'),
    ('2020',5,'Silver'),
    ('2020',6,'Gold'),
    ('2021',7,'Gold'),
    ('2021',8,'Platinum'),
    ('2022',9,'Silver'),
    ('2022',10,'Gold'),
    ('2023',11,'Platinum'),
    ('2023',12,'Gold');

INSERT INTO TopSongs (year, songCode, rating) VALUES
    ('2018',1,'Gold'),
    ('2018',2,'Platinum'),
    ('2019',3,'Gold'),
    ('2019',4,'Silver'),
    ('2020',5,'Platinum'),
    ('2020',6,'Gold'),
    ('2021',7,'Gold'),
    ('2021',8,'Platinum'),
    ('2022',9,'Silver'),
    ('2022',10,'Gold'),
    ('2023',11,'Platinum'),
    ('2023',12,'Gold');


