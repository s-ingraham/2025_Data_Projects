# SQL Data Cleaning Project
# Create a stored procedure which copies a table and performs a set of 
# pre-determined cleaning tasks with the event scheduler

DROP PROCEDURE IF EXISTS Copy_and_Clean_Data;

DELIMITER $$
CREATE PROCEDURE Copy_and_Clean_Data()
BEGIN
	# Create a copy of the us_household_income table
	CREATE TABLE IF NOT EXISTS `us_household_income_cleaned` (
	  `row_id` int DEFAULT NULL,
	  `id` int DEFAULT NULL,
	  `State_Code` int DEFAULT NULL,
	  `State_Name` text,
	  `State_ab` text,
	  `County` text,
	  `City` text,
	  `Place` text,
	  `Type` text,
	  `Primary` text,
	  `Zip_Code` int DEFAULT NULL,
	  `Area_Code` int DEFAULT NULL,
	  `ALand` int DEFAULT NULL,
	  `AWater` int DEFAULT NULL,
	  `Lat` double DEFAULT NULL,
	  `Lon` double DEFAULT NULL,
	  `TimeStamp` TIMESTAMP DEFAULT NULL
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
    
    # Copy data into the new table
    INSERT INTO us_household_income_cleaned
    SELECT *, CURRENT_TIMESTAMP
    FROM bakery.us_household_income;
    
    # Data cleaning steps
	# Delete duplicate rows from the table
	DELETE FROM us_household_income_cleaned
	WHERE row_id IN (
		SELECT row_id
		FROM (
			SELECT row_id, id,
			ROW_NUMBER() OVER(
            PARTITION BY id, `TimeStamp`
            ORDER BY id, `TimeStamp`) AS row_num
			FROM us_household_income_cleaned
			) AS duplicates
		WHERE row_num > 1
	)
	;

	# Fix data quality issues, standardize location names
    UPDATE us_household_income_cleaned
	SET State_Name = 'Georgia'
	WHERE State_Name = 'georia';

	UPDATE us_household_income_cleaned
	SET County = UPPER(County);

	UPDATE us_household_income_cleaned
	SET City = UPPER(City);

	UPDATE us_household_income_cleaned
	SET Place = UPPER(Place);

	UPDATE us_household_income_cleaned
	SET State_Name = UPPER(State_Name);

	UPDATE us_household_income_cleaned
	SET `Type` = 'CDP'
	WHERE `Type` = 'CPD';

	UPDATE us_household_income_cleaned
	SET `Type` = 'Borough'
	WHERE `Type` = 'Boroughs';

END $$
DELIMITER ;

CALL Copy_and_Clean_Data();

# Create the event - copy and clean the table every 30 days
CREATE EVENT run_data_cleaning
	ON SCHEDULE EVERY 30 DAY
    DO CALL Copy_and_Clean_Data();