# World Life Expectancy Project - Exploratory Data Analysis

# Compare min and max life expectancy values for each country in the 15 year period
SELECT country, 
MIN(`Life expectancy`), 
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_increase_over_15_years
FROM world_life_expectancy
GROUP BY country
HAVING MIN(`Life expectancy`) <> 0
	AND MAX(`Life expectancy`) <> 0
ORDER BY Life_increase_over_15_years
;

# Review global average life expectancy during each year
SELECT year, ROUND(AVG(`Life expectancy`),2)
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
GROUP BY year
ORDER BY year
;

# Compare average life expectancy to average GDP in each country
SELECT country, 
ROUND(AVG(`Life expectancy`),1) AS AVG_life_exp, 
ROUND(AVG(GDP),1) AS AVG_GDP
FROM world_life_expectancy
GROUP BY country
HAVING AVG_life_exp > 0
	AND AVG_GDP > 0
ORDER BY AVG_GDP
;

# Compare average life expectancy in high GDP country-years vs. low GDP country-years
SELECT
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) AS High_GDP_count,
AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END) AS High_GDP_life_expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) AS Low_GDP_count,
AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END) AS Low_GDP_life_expectancy
FROM world_life_expectancy
;

# Compare average life expectancy in developed vs developing countries
SELECT status, 
COUNT(DISTINCT country) AS num_countries,
ROUND(AVG(`Life expectancy`),1) AS AVG_life_exp
FROM world_life_expectancy
GROUP BY status
;

# Compare average life expectancy to average BMI in each country
SELECT country, 
ROUND(AVG(`Life expectancy`),1) AS AVG_life_exp, 
ROUND(AVG(BMI),1) AS AVG_BMI
FROM world_life_expectancy
GROUP BY country
HAVING AVG_life_exp > 0
	AND AVG_BMI > 0
ORDER BY AVG_BMI DESC
;

# View rolling total of adult mortality over time in each country
SELECT country,
year,
`Life expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY country ORDER BY year) AS Rolling_Total
FROM world_life_expectancy
;

