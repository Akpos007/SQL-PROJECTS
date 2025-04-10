# World Life Expectancy Data Analysis

## Project Overview
This project focuses on cleaning and analyzing a world life expectancy dataset using SQL. The analysis examines life expectancy trends across countries, years, and various factors such as GDP, BMI, and development status.

## Objectives
1. Clean the dataset by handling duplicates and missing values
2. Perform exploratory data analysis to uncover trends and relationships
3. Examine factors influencing life expectancy across different countries

## Dataset
The analysis uses data from the `world_life_expectancy` table containing:
- Country
- Year
- Life Expectancy
- Status (Developed/Developing)
- GDP
- BMI
- Adult Mortality
- Row_ID (unique identifier)

## Project Structure
The SQL script is organized into two main sections:

### 1. Data Cleaning
- Identifies and removes duplicate records based on Country and Year combinations
- Handles missing values in:
  - Status: Fills based on other records for the same country
  - Life Expectancy: Interpolates using average of previous and next year's values

### 2. Exploratory Data Analysis (EDA)
- Analyzes life expectancy ranges by country
- Calculates life expectancy increases over time
- Examines yearly global life expectancy trends
- Investigates relationships between:
  - Life expectancy and GDP
  - Life expectancy and development status
  - Life expectancy and BMI
- Computes rolling totals of adult mortality for specific countries

## Prerequisites
- SQL database system (e.g., MySQL, PostgreSQL)
- World life expectancy dataset loaded into a table named `world_life_expectancy`

## Usage
1. Ensure the dataset is loaded into your SQL database
2. Execute the SQL script in your preferred SQL environment
3. Review the query results for insights

## Key Findings
- Life expectancy trends over time by country
- Correlation between GDP and life expectancy
- Differences in life expectancy between developed and developing countries
- Relationship between BMI and life expectancy
- Adult mortality patterns for specific countries

