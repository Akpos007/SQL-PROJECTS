-- DATA CLEANING SECTION
-- Retrieve all data from the world_life_expectancy table to inspect the dataset
SELECT * 
FROM world_life_expectancy;

-- IDENTIFY AND REMOVE DUPLICATE RECORDS
-- Check for duplicate records by concatenating Country and Year, grouping, and counting occurrences
SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1;

-- Identify duplicate rows using ROW_NUMBER to assign a row number to each record within groups of Country+Year
SELECT *
FROM (
    SELECT Row_ID,
           CONCAT(Country, Year),
           ROW_NUMBER() OVER (PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
    FROM world_life_expectancy
) AS Row_Table
WHERE Row_Num > 1;

-- Delete duplicate records, keeping only the first occurrence of each Country+Year combination
DELETE FROM world_life_expectancy
WHERE Row_ID IN (
    SELECT Row_ID 
    FROM (
        SELECT Row_ID,
               CONCAT(Country, Year),
               ROW_NUMBER() OVER (PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
        FROM world_life_expectancy
    ) AS Row_Table
    WHERE Row_Num > 1
);

-- HANDLE MISSING DATA
-- COUNTRY STATUS COLUMN
-- Identify records where the Status column is empty
SELECT Country
FROM world_life_expectancy
WHERE Status = '';

-- Retrieve distinct countries with a 'Developing' status to understand valid values
SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing';

-- Update empty Status fields to 'Developing' for countries that have 'Developing' in other records
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing';

-- Update empty Status fields to 'Developed' for countries that have 'Developed' in other records
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed';

-- LIFE EXPECTANCY COLUMN
-- Identify records where Life Expectancy is empty
SELECT *
FROM world_life_expectancy
WHERE `Life Expectancy` = '';

-- Calculate the average Life Expectancy for missing values using the previous and next year's data for the same country
SELECT t1.Country, t1.Year, t1.`Life Expectancy`,
       t2.Country, t2.Year, t2.`Life Expectancy`,
       t3.Country, t3.Year, t3.`Life Expectancy`,
       ROUND((t2.`Life Expectancy` + t3.`Life Expectancy`)/2, 1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
    ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life Expectancy` = '';

-- Update empty Life Expectancy values with the rounded average of the previous and next year's values
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
    ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life Expectancy` = ROUND((t2.`Life Expectancy` + t3.`Life Expectancy`)/2, 1)
WHERE t1.`Life Expectancy` = '';
