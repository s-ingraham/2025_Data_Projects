# US Household Income - Exploratory Data Analysis

SELECT * 
FROM us_household_income;

SELECT *
FROM us_household_income_statistics; 

# Compare total areas of land and water in each state
SELECT State_Name, SUM(ALand), Sum(AWater) 
FROM us_household_income
GROUP BY State_Name
ORDER BY SUM(ALand) DESC;

# Join the two tables and check average and median incomes by city
SELECT u.State_Name, City, Mean, Median
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
ORDER BY Mean DESC
;