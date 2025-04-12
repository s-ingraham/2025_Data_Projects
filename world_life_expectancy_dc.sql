# World Life Expectancy Project - Data Cleaning

SELECT * 
FROM world_life_expectancy
;

# Identify any duplicate rows (two rows with same country & year)
SELECT *
FROM (
	SELECT Row_ID, CONCAT(country, year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(country, year) 
		ORDER BY CONCAT(country, year)) AS Row_Num
	FROM world_life_expectancy
    ) AS Row_table
WHERE Row_Num > 1
;

# Delete the duplicate rows
DELETE FROM  world_life_expectancy
WHERE 
	Row_ID IN (
    SELECT Row_ID
    FROM (
		SELECT Row_ID, CONCAT(country, year),
		ROW_NUMBER() OVER(PARTITION BY CONCAT(country, year) 
			ORDER BY CONCAT(country, year)) AS Row_Num
		FROM world_life_expectancy
		) AS Row_table
	WHERE Row_Num > 1
    )
;

# Populate any blank Status entries (using self join)
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
SET t1.status = 'Developing'
	WHERE t1.status = ''
    AND t2.status <> ''
    AND t2.status = 'Developing'
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
SET t1.status = 'Developed'
	WHERE t1.status = ''
    AND t2.status <> ''
    AND t2.status = 'Developed'
;