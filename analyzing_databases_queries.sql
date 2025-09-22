-- (PROBLEM 1) First we are going to find de total number of crimes RECORDED
SELECT COUNT(*) FROM chicago_crime;
-- (PROBLEM 2) Here we can see some examples
SELECT * FROM chicago_crime
LIMIT 10;
-- (PROBLEM 3) Now we can analyze the arrest crimes
SELECT COUNT(ARREST) FROM chicago_crime
WHERE ARREST = 'TRUE';
-- In proportion, that means
SELECT ROUND(
    (SUM(CASE WHEN ARREST = 'TRUE' THEN 1 ELSE 0 END)*100) / COUNT(*),2
    ) AS ARREST_PERCENTAGE
FROM chicago_crime;
-- (PROBLEM 4) Let see how many unique crimes the GAS STATION workes have see
SELECT PRIMARY_TYPE FROM chicago_crime
WHERE LOCATION_DESCRIPTION LIKE "GAS%";
SELECT COUNT(DISTINCT(PRIMARY_TYPE)) FROM chicago_crime
WHERE LOCATION_DESCRIPTION LIKE "GAS%";

-- For now is enough talking about crimes. Lets go with CENSUS_DATA
-- (PROBLEM 5) I'm interested in those communitty areas whose names start with the letter 'B'
SELECT * FROM chicago_socioeconomic_data
WHERE COMMUNITY_AREA_NAME LIKE "B%";
-- (PROBLEM 6) BORING, lets go with schools
SELECT NAME_OF_SCHOOL, COMMUNITY_AREA_NUMBER
FROM chicago_public_schools
WHERE COMMUNITY_AREA_NUMBER BETWEEN 10 AND 15;
-- (PROBLEM 7) I want to scholarize my children, but where?
SELECT DISTINCT(COMMUNITY_AREA_NAME), ROUND(AVG(SAFETY_SCORE),2) AS AVG_SAFETY FROM chicago_public_schools
GROUP BY COMMUNITY_AREA_NAME 
ORDER BY AVG_SAFETY DESC LIMIT 15;
-- (PROBLEM 8) Lets see if there is a possible "correlation" between safety and enrrollment
SELECT DISTINCT(COMMUNITY_AREA_NAME), ROUND(AVG(SAFETY_SCORE),2) AS AVG_SAFETY, AVG(COLLEGE_ENROLLMENT) AS AVG_ENROLLMENT FROM  chicago_public_schools
GROUP BY COMMUNITY_AREA_NAME 
ORDER BY AVG_ENROLLMENT DESC LIMIT 5;
-- Obviously not, you pay for the safety, and not everyone has the money to pay that...
-- (PROBLEM 9) Use a sub-query to determine which Community Area has the least value for school Safety Score?
SELECT DISTINCT(COMMUNITY_AREA_NAME)
FROM chicago_public_schools
WHERE COMMUNITY_AREA_NAME = (
    SELECT MIN(COMMUNITY_AREA_NAME) FROM chicago_public_schools
    );
-- (PROBLEM 10) [Without using an explicit JOIN operator] Find the Per Capita Income of the Community Area which has a school Safety Score of 1.
SELECT COMMUNITY_AREA_NAME, PER_CAPITA_INCOME 
FROM chicago_socioeconomic_data
WHERE COMMUNITY_AREA_NAME IN (
    SELECT COMMUNITY_AREA_NAME FROM chicago_public_schools
    WHERE SAFETY_SCORE = 1
    );