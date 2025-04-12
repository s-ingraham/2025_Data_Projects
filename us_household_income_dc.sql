# US Household Income - Data Cleaning

SELECT * FROM us_household_income;
SELECT * FROM us_household_income_statistics;

ALTER TABLE us_household_income_statistics
RENAME COLUMN `ï»¿id` TO `id`;

# Check for duplicate rows in us_household_income table
SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;

# Delete duplicate rows from us_household_income table
DELETE FROM us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT row_id, id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
		FROM us_household_income
		) AS duplicates
    WHERE row_num > 1
)
;

# Check for duplicate rows in us_household_income_statistics table
SELECT id, COUNT(id)
FROM us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1
;

# Verify that all values in the State_Name column are correct
SELECT DISTINCT State_Name
FROM us_household_income
ORDER BY 1
;

# Fix misspelled state name, 'georia' -> 'Georgia'
UPDATE us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

# Check for errors in Type category
SELECT Type, COUNT(Type)
FROM us_household_income
GROUP BY Type;

# Fix misspelled Type entries
UPDATE us_household_income
SET Type = 'Borough' 
WHERE Type = 'Boroughs';

# Check for 0 or null values in ALand and AWater (area of land, area of water)
SELECT ALand, AWater
FROM us_household_income
WHERE (AWater = 0 OR AWater = '' OR AWATER IS NULL)
AND (ALand = 0 OR ALand = '' OR ALand IS NULL)
;