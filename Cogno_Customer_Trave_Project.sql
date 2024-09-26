SELECT * FROM cogno_custravel.customertravel;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------                                         
                                                            --  CREATE DUPLICATE TABLE FOR DATA CLEANING  ---     
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE cust_dupl
LIKE customertravel;

INSERT INTO cust_dupl
SELECT *
FROM customertravel;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
											                -- CHECK THE DUPLCATES VALUES IN TABLE ---
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------										---


SELECT *,
ROW_NUMBER() OVER (
PARTITION BY Age, FrequentFlyer, AnnualIncomeClass, ServicesOpted, AccountSyncedToSocialMedia, BookedHotelOrNot, Target ) AS Row_num
FROM cust_dupl;

WITH CTE_dup AS
(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY Age, FrequentFlyer, AnnualIncomeClass, ServicesOpted, AccountSyncedToSocialMedia, BookedHotelOrNot, Target ) AS Row_num
FROM cust_dupl
)
SELECT *
FROM CTE_dup
WHERE Row_num > 1;



-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                   -- CREATE NEW TABLE AND ROW_NUM COLUMN TO IT ---
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE `cust_dupl_upd` (
  `Age` int DEFAULT NULL,
  `FrequentFlyer` text,
  `AnnualIncomeClass` text,
  `ServicesOpted` int DEFAULT NULL,
  `AccountSyncedToSocialMedia` text,
  `BookedHotelOrNot` text,
  `Target` int DEFAULT NULL,
  `Row_num` int
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO cust_dupl_upd
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY Age, FrequentFlyer, AnnualIncomeClass, ServicesOpted, AccountSyncedToSocialMedia, BookedHotelOrNot, Target ) AS Row_num
FROM cust_dupl;

SELECT *
FROM cust_dupl_upd
WHERE Row_num = 4;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                          -- REARRANGING SOME COLUMNS'S NAME ---
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE cust_dupl
RENAME COLUMN FrequentFlyer TO Frequent_Flyer;

ALTER TABLE cust_dupl
RENAME COLUMN AnnualIncomeClass TO Annual_Income_Class;

ALTER TABLE cust_dupl
RENAME COLUMN Sevice_Opted TO Service_Opted;

ALTER TABLE cust_dupl
RENAME COLUMN AccountSyncedToSocialMedia TO Account_Synced_To_Social_Media;

ALTER TABLE cust_dupl
RENAME COLUMN BookedHotelOrNot TO Booked_Hotel;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                         -- CHECKING DISTINCT VALUES OF EACH COLUMN ---
----------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT 
	DISTINCT Frequent_Flyer
FROM cust_dupl;

SELECT
	DISTINCT Annual_Income_Class,
    COUNT(Annual_Income_Class) AS Total_Annual_Income_Class
FROM cust_dupl
    GROUP BY Annual_Income_Class
    ORDER BY Total_Annual_Income_Class;
    

SELECT
	DISTINCT Service_Opted,
    COUNT(Service_Opted) AS Total_Service_Opted
FROM cust_dupl 
	GROUP BY Service_Opted
    ORDER BY Total_Service_Opted ;

SELECT
	DISTINCT Account_Synced_To_Social_Media,
    COUNT(Account_Synced_To_Social_Media) AS Total_Account_Synced_To_Social_Media
FROM cust_dupl 
	GROUP BY Account_Synced_To_Social_Media
    ORDER BY Total_Account_Synced_To_Social_Media;

SELECT
	DISTINCT Booked_Hotel,
    COUNT(Booked_Hotel) AS Total_Booked_Hotel
FROM cust_dupl 
	GROUP BY Booked_Hotel
    ORDER BY Total_Booked_Hotel;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                           --  THE TOTAL NUMBER OF CUSTOMER IN EACH AGE ---
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT 
	DISTINCT Age,
    COUNT(Age) AS Total_Age
FROM cust_dupl
GROUP BY Age
ORDER BY Total_Age DESC;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                           -- TOTAL NUMBER OF FREQUENT FLYER BY AGE ---
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT 
	DISTINCT Age,
    COUNT(Frequent_Flyer) AS Total_Frequent_Flyer
FROM cust_dupl
WHERE Frequent_Flyer = 'Yes'
GROUP BY Age
ORDER BY Total_Frequent_Flyer DESC ;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                           -- TOTAL NUMBER OF FREQUENT FLYER BY ANNUAL INCOME CLASS ---
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT 
	DISTINCT Annual_Income_Class,
    COUNT(Frequent_Flyer) AS Total_Num_Frq_By_Annual_Income_Class
FROM cust_dupl
WHERE Frequent_Flyer = 'Yes'
GROUP BY Annual_Income_Class
ORDER BY Total_Num_Frq_By_Annual_Income DESC;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                           -- SERVICE OPTED BY AGE AND ANNUAL INCOME CLASS ---
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT 
	DISTINCT Age,
    COUNT(Service_Opted) AS Num_of_Service_Opted
FROM cust_dupl
	GROUP BY Age
    ORDER BY Num_of_Service_Opted DESC;
    

SELECT 
	DISTINCT Annual_Income_Class,
    COUNT(Annual_Income_Class) AS Num_Ann_Inc_Class
FROM cust_dupl
	GROUP BY Annual_Income_Class
    ORDER BY Num_Ann_Inc_Class DESC;
    
    
    
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
							-- TOTAL NUM OF ACCOUNT_SYNCHED TO SOCIAL MEDIA BY CUSTOMER AGE AND THEIR ANNUAL_INCOME CLASS ---
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT 
	DISTINCT Age,
    COUNT(Account_Synced_To_Social_Media) AS Num_of_Acc_Synched_By_Age
FROM cust_dupl
	WHERE Account_Synced_To_Social_Media = 'Yes'
	GROUP BY Age
    ORDER BY Num_of_Acc_Synched_By_Age DESC;
    

SELECT 
	DISTINCT Annual_Income_Class,
    COUNT(Account_Synced_To_Social_Media) AS Num_of_Acc_Synched_By_Annual_Income_Class
FROM cust_dupl
	WHERE Account_Synced_To_Social_Media = 'Yes'
	GROUP BY Annual_Income_Class
    ORDER BY Num_of_Acc_Synched_By_Annual_Income_Class DESC;
    


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
							-- TOTAL NUM OF HOTEL_BOOKED BY CUSTOMER AGE AND THEIR ANNUAL INCOME CLASS ---
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT 
	DISTINCT Age,
    COUNT(Booked_Hotel) AS Num_of_Booked_Hotel_By_Age
FROM cust_dupl
	WHERE Booked_Hotel = 'Yes'
	GROUP BY Age
    ORDER BY Num_of_Booked_Hotel_By_Age DESC;
    
    
SELECT 
	DISTINCT Annual_Income_Class,
    COUNT(Booked_Hotel) AS Num_of_Booked_Hotel_By_Age
FROM cust_dupl
	WHERE Booked_Hotel = 'Yes'
	GROUP BY Annual_Income_Class
    ORDER BY Num_of_Booked_Hotel_By_Age DESC;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
							-- TOTAL NUM OF CUSTOMER CHURNED BY AGE AND ANNUAL INCOME CLASS ---
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT 
	DISTINCT Annual_Income_Class,
    COUNT(Target) AS Num_of_Cust_Churned_By_Age
FROM cust_dupl
	WHERE Target = 1
	GROUP BY Annual_Income_Class
    ORDER BY Num_of_Cust_Churned_By_Age DESC;


SELECT 
	DISTINCT Age,
    COUNT(Target) AS Total_Cust_Churn_By_Age
FROM cust_dupl
	WHERE Target = 1
    GROUP BY Age
    ORDER BY Total_Cust_Churn_By_Age DESC;





