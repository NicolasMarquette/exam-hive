-- Select the database
USE imdb;

-- Set statment for the queries.
SET hive.cli.print.header=true;
SET hive.vectorized.execution.enabled=true;
SET hive.vectorized.execution.reduce.enabled=true;
SET hive.auto.convert.join=true;

-- Query to get the first 100 title with best average rating.
SELECT "";
SELECT "-------first 100 title with best average rating-------";
SELECT "";
SELECT t.originalTitle AS original_title, r.averageRating AS rating, r.numVotes AS nb_votes
FROM title_basics AS t
INNER JOIN (
    SELECT *
    FROM title_ratings
    WHERE numVotes > 5000) AS r
ON r.tconst=t.tconst
SORT BY rating DESC
LIMIT 100;

-- Query to get the first 100 director with better average rating.
SELECT "";
SELECT "-------first 100 director with better average rating-------";
SELECT "";
SELECT p.primaryName AS name, ROUND(AVG(r.averageRating), 1) AS avg_rating
FROM title_ratings AS r
INNER JOIN (
    SELECT tconst, nconst
    FROM title_principals
    WHERE job LIKE '%director%') AS c
ON c.tconst=r.tconst
INNER JOIN name_basics AS p
ON p.nconst=c.nconst
GROUP BY p.primaryName
SORT BY avg_rating DESC
LIMIT 100;
