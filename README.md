
# SQL Portfolio Project: World Life Expectancy Data Cleaning

## Overview
This repository contains SQL scripts for cleaning and preparing a "World Life Expectancy" dataset. The project demonstrates fundamental data cleaning techniques using SQL, including identifying and removing duplicates, handling missing data, and ensuring data consistency. The goal is to transform raw data into a reliable dataset suitable for further analysis.

## Project Description
The dataset used in this project includes life expectancy data across various countries and years. The SQL scripts focus on:
- Identifying and removing duplicate records.
- Handling missing values in key columns such as `Status` and `Life Expectancy`.
- Ensuring data integrity through updates based on logical assumptions and relationships.

This project showcases my ability to write efficient SQL queries for data cleaning and preparation, a critical step in any data analysis pipeline.

## Features
1. **Duplicate Removal**:
   - Identifies duplicate entries based on a combination of `Country` and `Year`.
   - Deletes duplicate rows while retaining the first occurrence.

2. **Handling Missing Data**:
   - Fills missing `Status` values (`Developed` or `Developing`) by referencing other records for the same country.
   - Imputes missing `Life Expectancy` values by averaging the life expectancy of the previous and next years for the same country.

3. **Data Validation**:
   - Uses subqueries and window functions to detect anomalies.
   - Applies updates systematically to maintain consistency.

## Dataset
The dataset (`world_life_expectancy`) includes the following key columns:
- `Row_ID`: Unique identifier for each row.
- `Country`: Name of the country.
- `Year`: Year of the record.
- `Status`: Development status of the country (`Developed` or `Developing`).
- `Life Expectancy`: Life expectancy value for the country in a given year.

## SQL Scripts
The main SQL operations are outlined below:

### 1. Data Cleaning
- **Preview Data**: Basic `SELECT` query to explore the dataset.
- **Duplicate Detection**: Uses `CONCAT(Country, Year)` to identify duplicates and assigns row numbers to flag them.
- **Duplicate Removal**: Deletes duplicate rows based on `Row_ID`.

### 2. Handling Missing Data
- **Missing Status**:
  - Identifies countries with empty `Status`.
  - Updates missing `Status` values by joining with records of the same country that have valid `Status` values.
- **Missing Life Expectancy**:
  - Identifies records with empty `Life Expectancy`.
  - Calculates the average of the previous and next year’s life expectancy for the same country and updates the missing value.

## Usage
1. **Requirements**:
   - A SQL database management system (e.g., MySQL, PostgreSQL, SQL Server).
   - The `world_life_expectancy` table loaded into your database.

2. **How to Run**:
   - Import the dataset into your SQL environment.
   - Execute the SQL scripts in the following order:
     1. Preview the data.
     2. Remove duplicates.
     3. Handle missing `Status` values.
     4. Handle missing `Life Expectancy` values.
   - Verify the results after each step using `SELECT` queries.
