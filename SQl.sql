-- ==========================================
-- Phase 1: Standard SQL Validation Queries
-- Netflix Content Analyzer Project
-- ==========================================

-- 1. View Complete Dataset
SELECT *
FROM netflix_titles;

-- 2. Count Total Records
SELECT COUNT(*) AS Total_Content
FROM netflix_titles;

-- 3. Check Unique Content Types
SELECT DISTINCT type
FROM netflix_titles;

-- 4. Check NULL Values
SELECT *
FROM netflix_titles
WHERE show_id IS NULL
   OR title IS NULL
   OR type IS NULL
   OR country IS NULL
   OR release_year IS NULL;

-- 5. Check Duplicate Primary Keys
SELECT show_id, COUNT(*) AS Duplicate_Count
FROM netflix_titles
GROUP BY show_id
HAVING COUNT(*) > 1;

-- 6. Verify Data Types (SQL Server)
EXEC sp_help 'netflix_titles';

-- 7. Check Unique Ratings
SELECT DISTINCT rating
FROM netflix_titles;

-- 8. GROUP BY (Content Count by Type)
SELECT
    type,
    COUNT(*) AS Total_Content
FROM netflix_titles
GROUP BY type;

-- 9. ORDER BY (Latest Released Content)
SELECT *
FROM netflix_titles
ORDER BY release_year DESC;

-- 10. Top 10 Recently Added Content
SELECT TOP 10 *
FROM netflix_titles
ORDER BY date_added DESC;

-- ==========================================
-- Phase 2: Business Analysis Queries
-- Netflix Content Analyzer Project
-- ==========================================

-- 1. Movies vs TV Shows
SELECT
    type,
    COUNT(*) AS Total_Content
FROM netflix_titles
GROUP BY type;

-- 2. Top 10 Countries with Most Content
SELECT TOP 10
    country,
    COUNT(*) AS Total_Content
FROM netflix_titles
WHERE country IS NOT NULL
GROUP BY country
ORDER BY Total_Content DESC;

-- 3. Top 10 Genres
SELECT TOP 10
    listed_in,
    COUNT(*) AS Total_Content
FROM netflix_titles
GROUP BY listed_in
ORDER BY Total_Content DESC;

-- 4. Content Added Per Year
SELECT
    YEAR(date_added) AS Added_Year,
    COUNT(*) AS Total_Content
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY YEAR(date_added)
ORDER BY Added_Year;

-- 5. Content by Rating
SELECT
    rating,
    COUNT(*) AS Total_Content
FROM netflix_titles
GROUP BY rating
ORDER BY Total_Content DESC;

-- 6. Top 10 Directors
SELECT TOP 10
    director,
    COUNT(*) AS Total_Content
FROM netflix_titles
WHERE director IS NOT NULL
GROUP BY director
ORDER BY Total_Content DESC;

-- 7. Top 10 Actors
SELECT TOP 10
    cast,
    COUNT(*) AS Total_Content
FROM netflix_titles
WHERE cast IS NOT NULL
GROUP BY cast
ORDER BY Total_Content DESC;

-- 8. Average Movie Duration
SELECT
    AVG(CAST(REPLACE(duration,' min','') AS INT)) AS Average_Duration_Minutes
FROM netflix_titles
WHERE type = 'Movie';

-- 9. Content by Release Year
SELECT
    release_year,
    COUNT(*) AS Total_Content
FROM netflix_titles
GROUP BY release_year
ORDER BY release_year;

-- 10. Top 10 Newest Titles
SELECT TOP 10
    title,
    release_year
FROM netflix_titles
ORDER BY release_year DESC;

-- 11. Top 10 Oldest Titles
SELECT TOP 10
    title,
    release_year
FROM netflix_titles
ORDER BY release_year ASC;

-- 12. Movies and TV Shows by Country
SELECT
    country,
    type,
    COUNT(*) AS Total_Content
FROM netflix_titles
WHERE country IS NOT NULL
GROUP BY country, type
ORDER BY Total_Content DESC;
-- ==========================================
-- Final Netflix Analysis Dataset
-- ==========================================

SELECT
    show_id,
    type,
    title,
    director,
    cast,
    country,
    TRY_CONVERT(date, date_added) AS date_added,
    release_year,
    rating,
    duration,
    listed_in AS genre,
    description,

    -- Extract Month
    DATENAME(MONTH, TRY_CONVERT(date, date_added)) AS Added_Month,

    -- Extract Year
    YEAR(TRY_CONVERT(date, date_added)) AS Added_Year,

    -- Movie Duration in Minutes
    CASE
        WHEN type = 'Movie'
        THEN TRY_CAST(REPLACE(duration,' min','') AS INT)
        ELSE NULL
    END AS Movie_Duration_Minutes,

    -- TV Show Seasons
    CASE
        WHEN type = 'TV Show'
        THEN TRY_CAST(REPLACE(REPLACE(duration,' Seasons',''),' Season','') AS INT)
        ELSE NULL
    END AS Number_of_Seasons

FROM netflix_titles;