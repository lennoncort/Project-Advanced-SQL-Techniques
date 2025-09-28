-- LITTLE PROJECT (DATA: chicago_socioeconomic_data, chicago_crime, chicago_public_schools)
USE mysql_learners;
-- 1_USING JOINS
-- We are going to list school names, community names and average attendance for communities with a hardahip index of 98
SELECT P.NAME_OF_SCHOOL, P.COMMUNITY_AREA_NAME, P.AVERAGE_STUDENT_ATTENDANCE, S.HARDSHIP_INDEX
FROM chicago_public_schools as P
LEFT OUTER JOIN chicago_socioeconomic_data AS S
	ON P.COMMUNITY_AREA_NUMBER = S.COMMUNITY_AREA_NUMBER
    WHERE S.HARDSHIP_INDEX = 98;

-- List all crimes that took place at a school. Include case number, crime type and community name.
SELECT C.CASE_NUMBER, C.DESCRIPTION, S.COMMUNITY_AREA_NUMBER
FROM chicago_crime AS C
LEFT OUTER JOIN chicago_socioeconomic_data AS S
	ON C.COMMUNITY_AREA_NUMBER = S.COMMUNITY_AREA_NUMBER
WHERE C.LOCATION_DESCRIPTION LIKE '%School%';

-- 2_CREATING VIEWS
DROP VIEW IF EXISTS RENAME_TABLE;

CREATE VIEW RENAME_TABLE AS
SELECT 
    NAME_OF_SCHOOL          AS School_name,
    Safety_Icon             AS Safety_Rating,
    Family_Involvement_Icon AS Family_Rating,
    Environment_Icon        AS Environment_Rating,
    Instruction_Icon        AS Instruction_Rating,
    Leaders_Icon            AS Leaders_Rating,
    Teachers_Icon           AS Teachers_Rating
FROM chicago_public_schools;

SELECT * FROM RENAME_TABLE;

SELECT School_Name, Leaders_Rating FROM RENAME_TABLE;

-- CREATING A STORED PROCEDURE
SET SQL_SAFE_UPDATES = 0;

DROP PROCEDURE IF EXISTS UPDATE_LEADERS_SCORE;

DELIMITER //

CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE(
    IN in_School_ID INT,
    IN in_Leaders_Score INT
)
BEGIN
	UPDATE chicago_public_schools
    SET Leaders_Score = in_Leaders_Score,
    	Leaders_Icon = CASE
        	WHEN in_Leaders_Score BETWEEN 80 AND 99 THEN 'Very Strong'
            WHEN in_Leaders_Score BETWEEN 60 AND 79 THEN 'Strong'
            WHEN in_Leaders_Score BETWEEN 40 AND 59 THEN 'Average'
            WHEN in_Leaders_Score BETWEEN 20 AND 39 THEN 'Weak'
            WHEN in_Leaders_Score BETWEEN 0 AND 19 THEN 'Very Weak'
        END
    WHERE School_ID = in_School_ID;
END //

DELIMITER ;

CALL UPDATE_LEADERS_SCORE(610038,75);
SELECT School_ID, Leaders_Score, Leaders_Icon
FROM chicago_public_schools
WHERE School_ID = 610038;

-- 4 USING TRANSACTIONS
/*
You realise that if someone calls your code with a score outside of the allowed range (0-99), 
then the score will be updated with the invalid data and the icon will remain at its previous value. 
There are various ways to avoid this problem, one of which is using a transaction
*/
/*
Update your stored procedure definition. Add a generic ELSE clause to the IF statement that rolls back 
the current work if the score did not fit any of the preceding categories.
*/
DROP PROCEDURE IF EXISTS UPDATE_LEADERS_SCORE;

DELIMITER //

CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE(
    IN in_School_ID INT,
    IN in_Leaders_Score INT
)
BEGIN
	UPDATE chicago_public_schools
    SET Leaders_Score = in_Leaders_Score
	WHERE School_ID = in_School_ID;

    -- now updating the icon based on the valid range
    IF in_Leaders_Score BETWEEN 80 AND 99 THEN
        UPDATE chicago_public_schools
        SET Leaders_Icon = 'Very Strong'
        WHERE School_ID = in_School_ID;
    ELSEIF in_Leaders_Score BETWEEN 60 AND 79 THEN
        UPDATE chicago_public_schools
        SET Leaders_Icon = 'Strong'
        WHERE School_ID = in_School_ID;
    ELSEIF in_Leaders_Score BETWEEN 40 AND 59 THEN
        UPDATE chicago_public_schools
        SET Leaders_Icon = 'Average'
        WHERE School_ID = in_School_ID;
    ELSEIF in_Leaders_Score BETWEEN 20 AND 39 THEN
        UPDATE chicago_public_schools
        SET Leaders_Icon = 'Weak'
        WHERE School_ID = in_School_ID;
    ELSEIF in_Leaders_Score BETWEEN 0 AND 19 THEN
        UPDATE chicago_public_schools
        SET Leaders_Icon = 'Very Weak'
        WHERE School_ID = in_School_ID;
    ELSE
        -- invalid score → roll back changes and signal an error
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Score must be between 0 and 99';
    END IF;

    -- commit only if we didn’t roll back
    COMMIT;
END //

CALL UPDATE_LEADERS_SCORE(610038, 380);
SELECT School_ID, Leaders_Score, Leaders_Icon
FROM chicago_public_schools
WHERE School_ID = 610038;