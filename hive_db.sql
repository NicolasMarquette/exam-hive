-- Create database
CREATE DATABASE IF NOT EXISTS imdb;


-- Select the database
USE imdb;


-- Set statment for Hive
SET hive.lazysimple.extended_boolean_literal=true;
set hive.support.quoted.identifiers=none;
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;


-- Create temporary table for title_akas
CREATE TEMPORARY TABLE IF NOT EXISTS temp_title_akas
(
    titleId STRING,
    ordering INT,
    title STRING,
    region STRING,
    language STRING,
    types ARRAY<STRING>,
    attributes ARRAY<STRING>,
    isOriginalTitle BOOLEAN
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY "\t"
LINES TERMINATED BY "\n"
STORED AS TEXTFILE;
LOAD DATA LOCAL INPATH "/data/title.akas.tsv.gz"
INTO TABLE temp_title_akas;

-- Create buckets table for title_akas
CREATE TABLE IF NOT EXISTS title_akas
(
    titleId STRING,
    ordering INT,
    title STRING,
    region STRING,
    language STRING,
    types ARRAY<STRING>,
    attributes ARRAY<STRING>,
    isOriginalTitle BOOLEAN
)
CLUSTERED BY (region) INTO 12 BUCKETS
ROW FORMAT DELIMITED
FIELDS TERMINATED BY "\t"
LINES TERMINATED BY "\n"
STORED AS TEXTFILE;
INSERT INTO TABLE title_akas
SELECT *
FROM temp_title_akas;


-- Create temporary table for title_basics
CREATE TEMPORARY TABLE IF NOT EXISTS temp_title_basics
(
    tconst STRING,
    titleType STRING,
    primaryTitle STRING,
    originalTitle STRING,
    isAdult BOOLEAN,
    startYear INT,
    endYear INT,
    runtimeMinutes INT,
    genres ARRAY<STRING>
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY "\t"
LINES TERMINATED BY "\n"
STORED AS TEXTFILE;
LOAD DATA LOCAL INPATH "/data/title.basics.tsv.gz"
INTO TABLE temp_title_basics;

-- Create partitioned table for title_basics
CREATE TABLE IF NOT EXISTS title_basics
(
    tconst STRING,
    /*titleType STRING,*/
    primaryTitle STRING,
    originalTitle STRING,
    isAdult BOOLEAN,
    startYear INT,
    endYear INT,
    runtimeMinutes INT,
    genres ARRAY<STRING>
)
PARTITIONED BY (titleType STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY "\t"
LINES TERMINATED BY "\n"
STORED AS TEXTFILE;
INSERT INTO TABLE title_basics
PARTITION (titleType)
SELECT `(titleType)?+.+`, titleType
FROM temp_title_basics;


-- Create temporary table for title_crew
CREATE TEMPORARY TABLE IF NOT EXISTS temp_title_crew
(
    tconst STRING,
    directors ARRAY<STRING>,
    writers ARRAY<STRING>
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY "\t"
LINES TERMINATED BY "\n"
STORED AS TEXTFILE;
LOAD DATA LOCAL INPATH "/data/title.crew.tsv.gz"
INTO TABLE temp_title_crew;

-- Create buckets table for title_crew
CREATE TABLE IF NOT EXISTS title_crew
(
    tconst STRING,
    directors ARRAY<STRING>,
    writers ARRAY<STRING>
)
CLUSTERED BY (tconst) INTO 3 BUCKETS
ROW FORMAT DELIMITED
FIELDS TERMINATED BY "\t"
LINES TERMINATED BY "\n"
STORED AS TEXTFILE;
INSERT INTO TABLE title_crew
SELECT *
FROM temp_title_crew;


-- Create temporary table for title_episode
CREATE TEMPORARY TABLE IF NOT EXISTS temp_title_episode
(
    tconst STRING,
    parentTconst STRING,
    seasonNumber INT,
    episodeNumber INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY "\t"
LINES TERMINATED BY "\n"
STORED AS TEXTFILE;
LOAD DATA LOCAL INPATH "/data/title.episode.tsv.gz"
INTO TABLE temp_title_episode;

-- Create buckets table for title_episode
CREATE TABLE IF NOT EXISTS title_episode
(
    tconst STRING,
    parentTconst STRING,
    seasonNumber INT,
    episodeNumber INT
)
CLUSTERED BY (parentTconst) INTO 2 BUCKETS
ROW FORMAT DELIMITED
FIELDS TERMINATED BY "\t"
LINES TERMINATED BY "\n"
STORED AS TEXTFILE;
INSERT INTO TABLE title_episode
SELECT *
FROM temp_title_episode;


-- Create temporary table for title_principals
CREATE TEMPORARY TABLE IF NOT EXISTS temp_title_principals
(
    tconst STRING,
    ordering INT,
    nconst STRING,
    category STRING,
    job STRING,
    characters STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY "\t"
LINES TERMINATED BY "\n"
STORED AS TEXTFILE;
LOAD DATA LOCAL INPATH "/data/title.principals.tsv.gz"
INTO TABLE temp_title_principals;

-- Create partitioned table for title_principals
CREATE TABLE IF NOT EXISTS title_principals
(
    tconst STRING,
    ordering INT,
    nconst STRING,
    /*category STRING,*/
    job STRING,
    characters STRING
)
PARTITIONED BY (category STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY "\t"
LINES TERMINATED BY "\n"
STORED AS TEXTFILE;
INSERT INTO TABLE title_principals
PARTITION (category)
SELECT `(category)?+.+`, category
FROM temp_title_principals;


-- Create temporary table for title_ratings
CREATE TEMPORARY TABLE IF NOT EXISTS temp_title_ratings
(
    tconst STRING,
    averageRating FLOAT,
    numVotes INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY "\t"
LINES TERMINATED BY "\n"
STORED AS TEXTFILE;
LOAD DATA LOCAL INPATH "/data/title.ratings.tsv.gz"
INTO TABLE temp_title_ratings;

-- Create buckets table for title_ratings
CREATE TABLE IF NOT EXISTS title_ratings
(
    tconst STRING,
    averageRating FLOAT,
    numVotes INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY "\t"
LINES TERMINATED BY "\n"
STORED AS TEXTFILE;
INSERT INTO TABLE title_ratings
SELECT *
FROM temp_title_ratings;


-- Create temporary table for name_basics
CREATE TEMPORARY TABLE IF NOT EXISTS temp_name_basics
(
    nconst STRING,
    primaryName STRING,
    birthYear INT,
    deathYear INT,
    primaryProfession ARRAY<STRING>,
    knownForTitles ARRAY<STRING>
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY "\t"
LINES TERMINATED BY "\n"
STORED AS TEXTFILE;
LOAD DATA LOCAL INPATH "/data/name.basics.tsv.gz"
INTO TABLE temp_name_basics;

-- Create buckets table for name_basics
CREATE TABLE IF NOT EXISTS name_basics
(
    nconst STRING,
    primaryName STRING,
    birthYear INT,
    deathYear INT,
    primaryProfession ARRAY<STRING>,
    knownForTitles ARRAY<STRING>
)
CLUSTERED BY (nconst) INTO 6 BUCKETS
ROW FORMAT DELIMITED
FIELDS TERMINATED BY "\t"
LINES TERMINATED BY "\n"
STORED AS TEXTFILE;
INSERT INTO TABLE name_basics
SELECT *
FROM temp_name_basics;
