-- Creating the ARTIST table first
CREATE TABLE ARTIST (
    artistName VARCHAR2(50),
    nationality VARCHAR2(50),
    PRIMARY KEY (artistName)
);

-- Creating the LABEL table
CREATE TABLE LABEL (
    labelName VARCHAR2(100),
    revenue DECIMAL(15, 2),
    PRIMARY KEY (labelName)
);

-- Creating the ALBUM table
CREATE TABLE ALBUM (
    albumTitle VARCHAR2(100),
    releaseYear INT,
    producedBy VARCHAR2(100),
    playedBy VARCHAR2(50),
    PRIMARY KEY (albumTitle),
    FOREIGN KEY (producedBy) REFERENCES LABEL(labelName),
    FOREIGN KEY (playedBy) REFERENCES ARTIST(artistName)
);

-- Creating the SONG table
CREATE TABLE SONG (
    songTitle VARCHAR2(100),
    length VARCHAR2(8),
    writtenBy VARCHAR2(50),
    writtenYear INT,
    PRIMARY KEY (songTitle),
    FOREIGN KEY (writtenBy) REFERENCES ARTIST(artistName)
);

-- Creating the SONG_INALBUM table
CREATE TABLE SONG_INALBUM (
    albumSong VARCHAR2(100),
    album VARCHAR2(100),
    trackNumber INT,
    PRIMARY KEY (albumSong, album),
    FOREIGN KEY (albumSong) REFERENCES SONG(songTitle),
    FOREIGN KEY (album) REFERENCES ALBUM(albumTitle)
);

-- Inserting data into the ARTIST table
INSERT INTO ARTIST VALUES ('David Louis', 'french');
INSERT INTO ARTIST VALUES ('Baker Switzerland', 'swiss');
INSERT INTO ARTIST VALUES ('Dave Witmuller', 'swiss');

-- Inserting data into the LABEL table
INSERT INTO LABEL VALUES ('Son', 50000000);
INSERT INTO LABEL VALUES ('ECC', 3000000);
INSERT INTO LABEL VALUES ('LabelBlue', 150000);
INSERT INTO LABEL VALUES ('GROW', 10000);

-- Inserting data into the SONG table
INSERT INTO SONG VALUES ('After Tomorrow', '5:35', 'David Louis', 2008);
INSERT INTO SONG VALUES ('I Do', '3:40', 'David Louis', 2008);
INSERT INTO SONG VALUES ('Standing', '4:26', 'David Louis', 1995);
INSERT INTO SONG VALUES ('Introducing', '6:00', 'Dave Witmuller', 2000);

-- Inserting data into the ALBUM table
INSERT INTO ALBUM VALUES ('Rain', 2008, 'ECC', 'David Louis');
INSERT INTO ALBUM VALUES ('Carney de Roy', 1995, 'LabelBlue', 'David Louis');
INSERT INTO ALBUM VALUES ('WestWest', 2005, 'GROW', 'Baker Switzerland');

-- Inserting data into the SONG_INALBUM table
INSERT INTO SONG_INALBUM VALUES ('After Tomorrow', 'Rain', 1);
INSERT INTO SONG_INALBUM VALUES ('I Do', 'Rain', 9);
INSERT INTO SONG_INALBUM VALUES ('Standing', 'Carney de Roy', 1);
INSERT INTO SONG_INALBUM VALUES ('Introducing', 'WestWest', 4);

-- Creating the REVIEWS table
CREATE TABLE REVIEWS (
    magazine VARCHAR2(100),
    albumTitle VARCHAR2(100),
    releaseYear NUMBER,
    issue NUMBER,
    criticName VARCHAR2(100) NOT NULL,
    rating VARCHAR2(10) CHECK (rating IN ('positive', 'negative', 'neutral')) NOT NULL,
    reviewText VARCHAR2(4000) NOT NULL,
    PRIMARY KEY (magazine, albumTitle),
    FOREIGN KEY (albumTitle) REFERENCES ALBUM(albumTitle) ON DELETE CASCADE,
    FOREIGN KEY (criticName) REFERENCES ARTIST(artistName) ON DELETE CASCADE
);


SELECT a.albumTitle,
       SUM(
           TO_NUMBER(SUBSTR(s.length, 1, INSTR(s.length, ':') - 1)) * 60 + 
           TO_NUMBER(SUBSTR(s.length, INSTR(s.length, ':') + 1))
       ) AS totalLengthInSeconds
FROM ALBUM a
JOIN SONG_INALBUM si ON a.albumTitle = si.album
JOIN SONG s ON si.albumSong = s.songTitle
GROUP BY a.albumTitle;
