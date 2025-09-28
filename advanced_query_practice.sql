-- CREATING VIEWS FOR DATASETS: (DEPARTMENTS, EMPLOYEES, JOBS, JOB_HISTORY,LOCATIONS)
DROP VIEW IF EXISTS EMPSALARY;

CREATE VIEW EMPSALARY AS
SELECT EMP_ID, F_NAME, L_NAME, B_DATE, SEX, SALARY
FROM EMPLOYEES;
SELECT * FROM EMPSALARY;

-- Lets UPDATE the VIEW
CREATE OR REPLACE VIEW EMPSALARY AS
SELECT EMP_ID, F_NAME, L_NAME, B_DATE, SEX, JOB_TITLE, MAX_SALARY, MIN_SALARY
FROM EMPLOYEES E, JOBS J
WHERE E.JOB_ID = J.JOB_IDENT;
SELECT 
    *
FROM
    EMPSALARY;

-- Let's delete the created EMPSALARY view
-- DROP VIEW EMPSALARY;
-- SELECT * FROM EMPSALARY

-- STORED PROCEDURES (DATABASE: PETSALE)
-- We create the procedure "RETRIEVE_ALL"
DELIMITER // -- INDICATE THE NEW DELIMITER TIPE
CREATE PROCEDURE RETRIEVE_ALL()
BEGIN
	SELECT * FROM PETSALE;
END //
DELIMITER ; -- RETURN TO THE CLASSIC DELIMITER
CALL RETRIEVE_ALL;
-- DROP PROCEDURE RETRIEVE_ALL;

/* ACID TRANSACTIONS DATABASE: (BANCKACCOUNT, SHOESHOP)
Scenario: Let's buy Rose a pair of Boots from ShoeShop. 
So we have to update the Rose balance as well as the ShoeShop balance in the BankAccounts table. 
Then we also have to update Boots stock in the ShoeShop table. 
After Boots, let's also attempt to buy Rose a pair of Trainers.
*/
-- First we are going to create a new PROCEDURE called: TRANSACTION_ROSE
DELIMITER //

CREATE PROCEDURE TRANSACTION_ROSE()

	BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		RESIGNAL;
	END;
    
		START TRANSACTION;
			UPDATE BankAccounts
			SET Balance = Balance - (
				SELECT Price FROM ShoeShop
				WHERE Product = 'Boots')
			WHERE AccountName = 'Rose'
            AND Balance >= (
				SELECT Price From ShoeShop
				WHERE Product = 'Boots');
            
            UPDATE BankAccounts
            SET Balance = Balance + (
				SELECT Price FROM ShoeShop
				WHERE Product = 'Boots')
			WHERE AccountName = 'Shoe Shop';
            
            UPDATE ShoeShop
            SET Stock = Stock - 1
			WHERE Product = 'Boots'
            AND Stock > 0;
            
            COMMIT;
END //

DELIMITER ;

CALL TRANSACTION_ROSE; 
SELECT * FROM BankAccounts;
SELECT * FROM ShoeShop;

-- Lets do something about JOINS! (DEPARTMENTS, EMPLOYEES, JOBS, JOB_HISTORY,LOCATIONS)
/* 
How does a CROSS JOIN (also known as Cartesian Join) statement syntax look?

SELECT column_name(s)
FROM table1
CROSS JOIN table2;
*/
/* 
How does an INNER JOIN statement syntax look?

SELECT column_name(s)
FROM table1
LEFT OUTER JOIN table2
ON table1.column_name = table2.column_name
WHERE condition;
*/
/*
How does a LEFT OUTER JOIN statement syntax look?

SELECT column_name(s)
FROM table1
LEFT OUTER JOIN table2
ON table1.column_name = table2.column_name
WHERE condition;
*/
/*
How does a RIGHT OUTER JOIN statement syntax look?

SELECT column_name(s)
FROM table1
RIGHT OUTER JOIN table2
ON table1.column_name = table2.column_name
WHERE condition;
*/
/*
How does a FULL OUTER JOIN statement syntax look?

SELECT column_name(s)
FROM table1
LEFT  OUTER JOIN table2
ON table1.column_name = table2.column_name
WHERE condition

UNION

SELECT column_name(s)
FROM table1
RIGHT  OUTER JOIN table2
ON table1.column_name = table2.column_name
WHERE condition
*/
/*
Union operator

The UNION operator is used to combine the result-set of two or more SELECT statements.

Every SELECT statement within UNION must have the same number of columns
The columns must also have similar data types
The columns in every SELECT statement must also be in the same order

SELECT column_name(s) FROM table1
UNION
SELECT column_name(s) FROM table2;

How does a SELF JOIN statement syntax look?

SELECT column_name(s)
FROM table1 T1, table1 T2
WHERE condition;
*/

-- Problem_1: Select the names and job start dates of 
-- all employees who work for the department number 5.
SELECT E.F_NAME, E.L_NAME, JH.START_DATE
FROM EMPLOYEES AS E
INNER JOIN JOB_HISTORY AS JH ON E.EMP_ID = JH.EMPL_ID
WHERE E.DEP_ID = 5;

-- Problem_2: Select the names, job start dates, and job 
-- titles of all employees who work for the department number 5.
SELECT E.F_NAME, E.L_NAME, JH.START_DATE, J.JOB_TITLE
FROM EMPLOYEES AS E
INNER JOIN JOB_HISTORY AS JH ON E.EMP_ID = JH.EMPL_ID 
INNER JOIN JOBS AS J ON E.JOB_ID = J.JOB_IDENT
WHERE E.DEP_ID = 5;

-- Problem_3: Perform a Left Outer Join on the EMPLOYEES and DEPARTMENT tables and select 
-- employee id, last name, department id and department name for all employees.
SELECT E.EMP_ID, E.F_NAME, E.L_NAME, E.DEP_ID, D.DEP_NAME
FROM EMPLOYEES AS E
LEFT OUTER JOIN DEPARTMENTS AS D
	ON D.DEPT_ID_DEP = E.DEP_ID
ORDER BY E.DEP_ID;

-- Problem_4: Re-write the previous query but limit the result set to include only the rows 
-- for employees born before 1980.
SELECT E.EMP_ID, E.F_NAME, E.L_NAME, E.DEP_ID, D.DEP_NAME, E.B_DATE
FROM EMPLOYEES AS E
LEFT OUTER JOIN DEPARTMENTS AS D
	ON D.DEPT_ID_DEP = E.DEP_ID
WHERE YEAR(E.B_DATE) < 1980
ORDER BY E.DEP_ID;

-- Problem_5: Re-write the previous query but have the result set include all the employees but 
-- department names for only the employees who were born before 1980.
SELECT E.EMP_ID, E.F_NAME, E.L_NAME, E.DEP_ID, D.DEP_NAME, E.B_DATE
FROM EMPLOYEES AS E
LEFT OUTER JOIN DEPARTMENTS AS D
	ON D.DEPT_ID_DEP = E.DEP_ID
	AND YEAR(E.B_DATE) < 1980
ORDER BY E.DEP_ID;

-- Proble_6: Perform a Full Join on the EMPLOYEES and DEPARTMENT tables and select the First name, 
-- Last name and Department name of all employees.
SELECT E.F_NAME, E.L_NAME, D.DEP_NAME
FROM EMPLOYEES AS E
LEFT OUTER JOIN DEPARTMENTS AS D
	ON D.DEPT_ID_DEP = E.DEP_ID
    
UNION

SELECT E.F_NAME, E.L_NAME, D.DEP_NAME
FROM EMPLOYEES AS E
RIGHT OUTER JOIN DEPARTMENTS AS D
	ON D.DEPT_ID_DEP = E.DEP_ID

ORDER BY DEP_NAME DESC;

-- Proble_7: Re-write the previous query but have the result set include all employee names but department 
-- id and department names only for male employees.
SELECT E.F_NAME, E.L_NAME, D.DEP_NAME, E.DEP_ID
FROM EMPLOYEES AS E
LEFT OUTER JOIN DEPARTMENTS AS D
	ON D.DEPT_ID_DEP = E.DEP_ID AND E.SEX = 'M'

UNION

SELECT E.F_NAME, E.L_NAME, D.DEP_NAME, E.DEP_ID
FROM EMPLOYEES AS E
RIGHT OUTER JOIN DEPARTMENTS AS D
	ON D.DEPT_ID_DEP = E.DEP_ID AND E.SEX = 'M'
    
ORDER BY DEP_NAME DESC;



