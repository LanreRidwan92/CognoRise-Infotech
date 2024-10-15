SELECT * FROM cogno_bigsmart.bigsmart;

                                        -- CREATE DUPLICATE TABLE FOR DATA CLEANING AND EXPLORATORY --
									
CREATE TABLE bigsma
LIKE bigsmart ;

INSERT INTO bigsma
SELECT *
FROM bigsmart;


									 -- CHECK IF THERE ARE DUPLICATE ROWS IN THE NEW TABLE CREATED --
                                     
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY Item_Identifier, Item_Weight, Item_Fat_Content, Item_Visibility, Item_Type, Item_MRP, Outlet_Identifier,
    Outlet_Establishment_Year, Outlet_Size, Outlet_Location_Type, Outlet_Type) AS Id_row
FROM bigsma;

WITH CTE_dupl AS
(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY Item_Identifier, Item_Weight, Item_Fat_Content, Item_Visibility, Item_Type, Item_MRP, Outlet_Identifier,
    Outlet_Establishment_Year, Outlet_Size, Outlet_Location_Type, Outlet_Type) AS Id_row
FROM bigsma
)
SELECT *
FROM CTE_dupl
WHERE Id_row > 1;


												-- CHECK THE DISTINCT VALUES IN COLUMN --

SELECT Item_Fat_Content,
	COUNT(Item_Identifier) AS Tot_Count
FROM bigsma
	GROUP BY Item_Fat_Content;


										-- UPDATE ITEM FAT CONTENT COLUMN WITH THE RELEVANT VALUES --- 

UPDATE bigsma
SET Item_Fat_Content = 'Low Fat'
WHERE Item_Fat_Content = 'LF';

UPDATE bigsma
SET Item_Fat_Content = 'Regular'
WHERE Item_Fat_Content = 'reg';


										  -- CHECKING THE DISTINCT VALUES IN ITEM_TYPE'S COLUMN ---
                          
SELECT Item_Type,
	COUNT(Item_Type) AS Tot_Item
FROM bigsma
    GROUP BY Item_Type
    ORDER BY Tot_Item DESC;


    
									-- CHECK THE TOTAL COUNT OF EACH VALUE IN EACH OF THE CATEGORICAL COLUMN ---
                                           
SELECT Outlet_Size,
	COUNT(Outlet_Size) AS Tot_Cnt
FROM bigsma
	GROUP BY Outlet_Size
    ORDER BY Tot_Cnt DESC;
    
    
SELECT Outlet_Location_Type,
	COUNT(Outlet_Location_Type) AS Tot_Cnt
FROM bigsma
	GROUP BY Outlet_Location_Type
    ORDER BY Tot_Cnt DESC;
    
    
SELECT Outlet_Type,
	COUNT(Outlet_Type) AS Tot_Cnt
FROM bigsma
	GROUP BY Outlet_Type
    ORDER BY Tot_Cnt DESC;    
    
SELECT Item_Type,
	COUNT(Item_Type) AS Tot_Cnt
FROM bigsma
	GROUP BY Item_Type
    ORDER BY Tot_Cnt DESC;    


   
                                          -- CHANGE THE EMPTY COLUMNS IN OUTLET_SIZE'S COLUMN TO UNKNOWN ---
UPDATE bigsma
SET Outlet_Size = 'Unknown'
WHERE Outlet_Size = '';
    
    
										   -- CHANGE THE EMPTY COLUMNS ITEM_WEIGHT'S COLUMN TO UNKNOWN ---

UPDATE bigsma
SET Item_Weight = 'Unknown'
WHERE Item_Weight = '';
    

											 -- SALES PERFORMANCE BY ITEM_FAT_CONTENT'S COLUMN ---

SELECT Item_Fat_Content,
	SUM(Item_MRP) AS Sales_By_Item_Fat
FROM bigsma
	GROUP BY Item_Fat_Content
    ORDER BY Sales_By_Item_Fat DESC;

SELECT Item_Fat_Content,
	AVG(Item_MRP) AS Sales_By_Item_Fat
FROM bigsma
	GROUP BY Item_Fat_Content
    ORDER BY Sales_By_Item_Fat DESC;


												-- SALES PERFORMANCE BY ITEM_TYPE'S COLUMN ---

SELECT Item_Type,
	SUM(Item_MRP) AS Sales_By_Item_Type
FROM bigsma
	GROUP BY Item_Type
    ORDER BY Sales_By_Item_Type DESC;

SELECT Item_Type,
	AVG(Item_MRP) AS Tot_Item_Type
FROM bigsma
	GROUP BY Item_Type
    ORDER BY Tot_Item_Type DESC;



										 -- SALES PERFORMANCE BY EACH OUTLET_IDENTIFIER ---
                                            

SELECT Outlet_Identifier,
	SUM(Item_MRP) AS Sales_By_Outlet
FROM bigsma
	GROUP BY Outlet_Identifier
    ORDER BY Sales_By_Outlet DESC;

SELECT Item_Type,
	AVG(Item_MRP) AS Tot_Item_Type
FROM bigsma
	GROUP BY Item_Type
    ORDER BY Tot_Item_Type DESC;


							    
										 -- SALES PERFORMANCE BY EACH OUTLET_LOCATION ---

SELECT Outlet_Location_Type,
	SUM(Item_MRP) AS Sales_By_Location
FROM bigsma
	GROUP BY Outlet_Location_Type
	ORDER BY Sales_By_Location DESC;
    
    
										 -- SALES PERFORMANCE BY EACH OUTLET_LOCATION ---
    
SELECT Outlet_Size,
	SUM(Item_MRP) AS Sales_By_Outlet_Size
FROM bigsma
	GROUP BY Outlet_Size
	ORDER BY Sales_By_Outlet_Size DESC;
    
    
									-- SALES PERFORMANCE BY OUTLET YEAR OF ESTABLISHMENT --


SELECT DISTINCT(Outlet_Establishment_Year)
FROM bigsma;

SELECT Outlet_Establishment_Year, 
	SUM(Item_MRP) AS Sales_By_Item_Year_Est
FROM bigsma
	GROUP BY Outlet_Establishment_Year
    ORDER BY Sales_By_Item_Year_Est DESC;


                              
                              
