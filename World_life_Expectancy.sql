#------- DATA CLEANING
#--Select all data from the world_life_expectancy table to inspect initial dataset
SELECT * 
FROM world_life_expectancy;

#-------Identify and remove duplicates
# Check for duplicate records by concatenating Country and Year
SELECT Country, Year, CONCAT(Country, Year), count(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING count(CONCAT(Country, Year)) > 1;

# ---Create a temporary table with row numbers to identify duplicates
SELECT *
FROM (
    SELECT Row_ID,
    CONCAT(Country, Year),
    ROW_NUMBER() OVER (PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
    FROM world_life_expectancy
    ) AS Row_Table
WHERE Row_Num > 1;

#---- Delete duplicate records keeping only the first occurrence
DELETE FROM world_life_expectancy
WHERE 
    Row_ID IN (
    SELECT Row_ID 
    FROM (
        SELECT Row_ID,
        CONCAT(Country, Year),
        ROW_NUMBER() OVER (PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
        FROM world_life_expectancy
        ) AS Row_Table
    WHERE Row_Num > 1
);

#------Identifying and handling missing data
#.........COUNTRY---------
#--Find records where Status is missing (empty string)
SELECT Country
FROM world_life_expectancy
WHERE Status = '';

#---- View distinct countries with 'Developing' status
SELECT DISTINCT(country)
FROM world_life_expectancy
WHERE Status = 'Developing';

#---Update missing Status to 'Developing' based on other records for the same country
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing';

#---Update missing Status to 'Developed' based on other records for the same country
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed';

#--------Life Expectancy-----------------
#---Identify records with missing Life Expectancy values
SELECT *
FROM world_life_expectancy
WHERE `Life Expectancy` = '';

#---Preview interpolation of missing Life Expectancy using average of previous and next year
SELECT t1.Country, t1.Year, t1.`Life Expectancy`,
t2.Country, t2.Year, t2.`Life Expectancy`,
t3.Country, t3.Year, t3.`Life Expectancy`,
ROUND((t2.`Life Expectancy` + t3.`Life Expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
    ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life Expectancy` = '';

#---Update missing Life Expectancy values with average of previous and next year
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
    ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life Expectancy` = ROUND((t2.`Life Expectancy` + t3.`Life Expectancy`)/2,1)
WHERE t1.`Life Expectancy` = '';

#----------EXPLORATORY DATA ANALYSIS (EDA)---------------------
#---Find minimum and maximum life expectancy by country
SELECT Country,
MIN(`Life Expectancy`),
MAX(`Life Expectancy`)
FROM world_life_expectancy
GROUP BY Country
ORDER BY Country DESC;

#---Filter out zero values for more meaningful min/max analysis
SELECT Country,
MIN(`Life Expectancy`),
MAX(`Life Expectancy`)
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life Expectancy`) <> 0
AND MAX(`Life Expectancy`) <> 0
ORDER BY Country DESC;

# ---Calculate life expectancy increase over 15 years by country
SELECT Country,
MIN(`Life Expectancy`),
MAX(`Life Expectancy`),
ROUND(MAX(`Life Expectancy`) - MIN(`Life Expectancy`),1) AS Life_increases_15_years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life Expectancy`) <> 0
AND MAX(`Life Expectancy`) <> 0
ORDER BY Life_increases_15_years ASC;

#---Calculate average life expectancy by year
SELECT Year, ROUND(AVG(`Life Expectancy`),2)
FROM world_life_expectancy
WHERE `Life Expectancy` <> 0
GROUP BY Year
ORDER BY Year;

#---Analyze relationship between life expectancy and GDP by country
SELECT Country, 
ROUND(AVG(`Life Expectancy`),1) AS Life_Exp, 
ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND GDP > 0
ORDER BY Life_Exp;

#---Count countries with high GDP (threshold: 1500)
SELECT 
SUM(CASE
    WHEN GDP >= 1500 THEN 1
    ELSE 0
END) High_GDP_Count
FROM world_life_expectancy;

#---Compare life expectancy between high and low GDP countries
SELECT
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
ROUND(AVG(CASE WHEN GDP >= 1500 THEN `Life Expectancy` ELSE NULL END),2) High_GDP_Life_Expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
ROUND(AVG(CASE WHEN GDP <= 1500 THEN `Life Expectancy` ELSE NULL END),2) Low_GDP_Life_Expectancy
FROM world_life_expectancy;

#---Compare average life expectancy by development status
SELECT Status, ROUND(AVG(`Life Expectancy`),1)
FROM world_life_expectancy
GROUP BY Status;

#---Count countries and average life expectancy by development status
SELECT Status, 
COUNT(DISTINCT Country),
ROUND(AVG(`Life Expectancy`),1)
FROM world_life_expectancy
GROUP BY Status;

#---Analyze relationship between life expectancy and BMI by country
SELECT Country, 
ROUND(AVG(`Life Expectancy`),1) AS Life_Exp, 
ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND BMI > 0
ORDER BY BMI ASC;

#---Calculate rolling total of adult mortality for countries containing 'united'
SELECT Country,
Year,
`Life Expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
WHERE Country LIKE '%united%';
