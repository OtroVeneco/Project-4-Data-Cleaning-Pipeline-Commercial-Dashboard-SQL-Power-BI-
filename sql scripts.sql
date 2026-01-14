Prepare the data
Table product_sales
The data format and type of the csv file is not in a correct format nor Data Type so we have to fix that. (dd/mm/yyyy Varchar) instead of (yyyy-mm-dd DATE)
Improve the readability of the columns names
Table product_data
The values of the column sale_price and cost_price are wrong  in format and datatype, so we make a similar proccess. $152 VARCHAR INSTEAD OF 152 FLOAT
 --Preparing the for analysis 
--Changing format and data type to the column date
ALTER TABLE product_sales 
ALTER COLUMN "date" TYPE DATE USING TO_DATE("date", 'dd/mm/yyyy');

--Renaming all columns for better readibility
ALTER TABLE product_sales
RENAME  "date" TO "sale_date";

ALTER TABLE product_sales
RENAME  "Customer Type" TO customer_type;

ALTER TABLE product_sales
RENAME  " Discount Band " TO discount_band;

ALTER TABLE product_sales
RENAME  "Units Sold" TO units_sold;

ALTER TABLE product_sales
RENAME "Product" TO product_id;

--Using Trim to clean empty spaces on the values

UPDATE product_sales ps 
SET discount_band = TRIM(ps.discount_band)

--Lowering case of discount_band

UPDATE product_sales ps 
SET discount_band = LOWER(discount_band)
 
--Rename columns

ALTER TABLE product_data
RENAME  "Product ID" TO product_id;

ALTER TABLE product_data
RENAME  "Product" TO product_name;

ALTER TABLE product_data
RENAME  "Category" TO category;

ALTER TABLE product_data
RENAME  "Cost Price" TO cost_price;

ALTER TABLE product_data
RENAME  "Sale Price" TO sale_price;

ALTER TABLE product_data
RENAME "Brand" TO brand;

ALTER TABLE product_data
RENAME  "Description" TO description;

ALTER TABLE product_data
RENAME  "Image url" TO image_url;

--Changing data type to Float and formatting columns sale and cost price

ALTER TABLE product_data 
ALTER COLUMN cost_price TYPE FLOAT USING SUBSTRING(cost_price, '[0-9]+')::FLOAT

ALTER TABLE product_data 
ALTER COLUMN sale_price TYPE FLOAT USING SUBSTRING(sale_price, '[0-9]+')::FLOAT

--Renaming columns 

ALTER TABLE discount_data 
RENAME  "Month" TO month_name;

ALTER TABLE discount_data 
RENAME  "Discount Band" TO discount_band;

Other options to substrac values 
Other synthax of substring
SET sales_price = SUBSTRING(sale_price FROM '[0-9]+')
Position based substring
SET sales_price = SUBSTRING(sale_price FROM 2)
REGEXP_REPLACE
SET sales_price = REGEXP_REPLACE(sale_price, '[^0-9]', '')
SPLIT_PART
SET sales_price = SPLIT_PART(sale_price, '$', 2)


Bussines Problems and solutions
Create column for: revenue, total_cost, year and month

WITH cte AS 
	(
		SELECT 
		sale_date,
		TO_CHAR(sale_date, 'YYYY') AS year,
		TO_CHAR(sale_date, 'Month') AS month_name,
		customer_type,
		country,
		a.product_id,
		discount_band,
		units_sold,
		product_name,
		category,
		cost_price,
		sale_price,
		(units_sold * cost_price)::FLOAT AS total_cost,
		(units_sold * sale_price)::FLOAT AS revenue,
		brand,
		description,
		image_url
	FROM product_sales AS a
	JOIN  product_data AS b
		ON a.product_id = b.product_id
	)		
SELECT 
	*,
	(1 - discount*1.0/100) * revenue AS discount_revenue
FROM cte AS a
JOIN  discount_data  AS b
	ON a.month_name = b.month_name AND a.discount_band = b.discount_band















