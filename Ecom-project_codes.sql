Create Database Ecom_project
USE Ecom_project;


SELECT * FROM customer_master;
SELECT * FROM customer_reviews;
SELECT * FROM delivery_logistics;
SELECT * FROM inventory_stock;
SELECT * FROM marketing_campaigns;
SELECT * FROM order_details;
SELECT * FROM payment_transactions;
SELECT * FROM product_master;
SELECT * FROM sales_transactions;
SELECT * FROM supplier_master;
SELECT * FROM website_analytics;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM customer_master;
-- "Age Bucket", each if [Age] > 55 then 55 
--else if [Age] > 46 then "46-55" 
--else if [Age] > 36 then "36-45" 
--else if [Age] > 26 then "26-35"
--else "18-25"
----"Customer_Type", each if [Loyalty_Points] >= 7000 then "Loyal" 
--else if [Loyalty_Points] >= 4000 then "Active"
--else if [Loyalty_Points] >= 2000 then "New" 
--else "New")

	select *,
	DATENAME(month,Registration_Date) as reg_month,
	DATENAME(year,Registration_Date) as reg_year,
	CONCAT('Q',DATEPART(QUARTER,Registration_Date)) as reg_quarter,
	case 
		when Loyalty_Points>=7000 then 'Loyal'
		when Loyalty_Points>=4000 then 'Active'
		when Loyalty_Points>=2000 then 'Regular'
		else 'New'
	end as Customer_type,
	DATEDIFF(MONTH, Registration_Date, GETDATE()) AS Customer_Tenure,
	case
		when age>55 then '55+'
		when age>45 then '46-55'
		when age>35 then '36-45'
		when age>25 then '26-35'
		else '18-25'
	end as Age_Bucket
	from customer_master;



--creating a view
CREATE VIEW Customer_Master_View
AS
SELECT
Customer_ID,
Customer_Name,
Gender,
Date_of_Birth,
Age,
CASE
   WHEN Age > 55 THEN '55+'
   WHEN Age > 45 THEN '46-55'
   WHEN Age > 35 THEN '36-45'
   WHEN Age > 25 THEN '26-35'
   ELSE '18-25'
END AS Age_Bucket,
Email_ID,
Mobile_Number,
City,
[State],
Country,
Registration_Date,
YEAR(Registration_Date) AS Registration_Year,
DATENAME(MONTH, Registration_Date) AS Registration_month,
CONCAT('Q', DATEPART(QUARTER, Registration_Date)) AS reg_quarter,
Customer_Segment,
Loyalty_Points,
Membership_Status,
CASE
   WHEN Loyalty_Points >= 7000 THEN 'Loyal'
   WHEN Loyalty_Points >= 4000 THEN 'Active'
   WHEN Loyalty_Points >= 2000 THEN 'Regular'
   ELSE 'New'
END AS Customer_type,
DATEDIFF(MONTH, Registration_Date, GETDATE()) AS Customer_Tenure
FROM customer_master;

select * from Customer_Master_View

-------------------------------------------------------------------------------------------------------------------------------------

Create view Customer_Review_View
as
Select * from customer_reviews;


select * from Customer_Review_View 






-------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM delivery_logistics;

Select 
Delivery_id,
Order_ID,
Courier_Partner,
Dispatch_Date,
YEAR(Dispatch_Date)as Dispatch_Year,
DATENAME(MONTH,Dispatch_Date)as Dispatch_Month,
CONCAT('Q', DATEPART(QUARTER, Dispatch_Date)) AS Dispatch_Quarter,
Delivery_Date,
YEAR(Delivery_Date)as Delivery_year,
DATENAME(MONTH,Delivery_Date)as Delivery_Month,
CONCAT('Q', DATEPART(QUARTER, Delivery_Date)) AS Delivery_Quarter,
CASE
   WHEN Delivery_Status = 'RTO' THEN 'Returned'
   ELSE Delivery_Status
END AS Delivery_Status,
Delivery_Days,
CASE 
   WHEN Delivery_Days = Null THEN 'Pending'
   WHEN Delivery_Days<=4 THEN 'On-Time'
   ELSE 'Delayed'
END as Delivery_Performance,
Shipping_Cost,
Delivery_City,
Delivery_State
from delivery_logistics

--if [Delivery_Days] = null then "Pending" else if [Delivery_Days] <= 4 then "On Time" else "Delayed")


CREATE VIEW Delivery_Logistics_view
AS
SELECT
    Delivery_ID,
    Order_ID,
    Courier_Partner,

    Dispatch_Date,
    YEAR(Dispatch_Date) AS Dispatch_Year,
    DATENAME(MONTH, Dispatch_Date) AS Dispatch_Month,
    CONCAT('Q', DATEPART(QUARTER, Dispatch_Date)) AS Dispatch_Quarter,

    Delivery_Date,
    YEAR(Delivery_Date) AS Delivery_Year,
    DATENAME(MONTH, Delivery_Date) AS Delivery_Month,
    CONCAT('Q', DATEPART(QUARTER, Delivery_Date)) AS Delivery_Quarter,

    CASE
        WHEN Delivery_Status = 'RTO' THEN 'Returned'
        ELSE Delivery_Status
    END AS Delivery_Status,

    Delivery_Days,

    CASE
        WHEN Delivery_Days IS NULL THEN 'Pending'
        WHEN Delivery_Days <= 4 THEN 'On-Time'
        ELSE 'Delayed'
    END AS Delivery_Performance,

    Shipping_Cost,
    Delivery_City,
    Delivery_State
FROM delivery_logistics


Select * from Delivery_Logistics_view
--------------------------------------------------------------------------------------------------------------------------------------------

select * from inventory_stock

SELECT
    Product_ID,
    Warehouse_ID,
    Warehouse_City,
    Stock_Available,
    CASE
        WHEN Stock_Available >= 2.5 * Reorder_Level THEN 'High'
        WHEN Stock_Available <= Reorder_Level THEN 'Low'
        ELSE 'Normal'
    END AS Stock_Alert,
    CASE
        WHEN Stock_Available = 0 THEN 'Out-of Stock'
        WHEN Stock_Available <= 100 THEN 'Critical Stock'
        WHEN Stock_Available <= 400 THEN 'Low Stock'
        ELSE 'In-stock'
    END AS Stock_Bucket,
    Reorder_Level,
    Reorder_Qty,
    Last_Stock_Update,
    YEAR(Last_Stock_Update) AS Last_Stock_Year,
    DATENAME(MONTH, Last_Stock_Update) AS Last_Stock_Month,
    CONCAT('Q', DATEPART(QUARTER, Last_Stock_Update)) AS Last_Stock_Quarter,
    Inventory_Value
FROM inventory_stock;
 

-- "Stock_Alert", each if [Stock_Available] <= [Reorder_Level] then "Low" else "Normal")


--View
CREATE VIEW Inventory_Stock_View
AS
SELECT
    Product_ID,
    Warehouse_ID,
    Warehouse_City,
    Stock_Available,
    CASE
        WHEN Stock_Available >= 2.5 * Reorder_Level THEN 'High'
        WHEN Stock_Available <= Reorder_Level THEN 'Low'
        ELSE 'Normal'
    END AS Stock_Alert,
    CASE
        WHEN Stock_Available = 0 THEN 'Out-of Stock'
        WHEN Stock_Available <= 100 THEN 'Critical Stock'
        WHEN Stock_Available <= 400 THEN 'Low Stock'
        ELSE 'In-stock'
    END AS Stock_Bucket,
    Reorder_Level,
    Reorder_Qty,
    Last_Stock_Update,
    YEAR(Last_Stock_Update) AS Last_Stock_Year,
    DATENAME(MONTH, Last_Stock_Update) AS Last_Stock_Month,
    CONCAT('Q', DATEPART(QUARTER, Last_Stock_Update)) AS Last_Stock_Quarter,
    Inventory_Value
FROM inventory_stock;

select * from Inventory_Stock_View

----------------------------------------------------------------------------------------------------------------------

Select * from marketing_campaigns

--if [Channel] = "Google ads" then "Paid Search"
--else if List.Contains({"Facebook", "Instagram", "WhatsAap"}, [Channel]) then "Social Media"
--else if [Channel] = "Email" then "Email"
--else if [Channel] = "Seo" then "Organic Search"
--else if [Channel] = "Youtube" then "Video"
--else "Others"

Select
Campaign_ID,
Campaign_Name,
CASE
    WHEN Campaign_Name LIKE '%instagram%' THEN 'Instagram'
    WHEN Campaign_Name LIKE '%facebook%' THEN 'Facebook'
    WHEN Campaign_Name LIKE '%whatsapp%' THEN 'WhatsApp'
    WHEN Campaign_Name LIKE '%youtube%' THEN 'YouTube'
	WHEN Campaign_Name LIKE '%Google Ads%' THEN 'Google Ads'
	WHEN Campaign_Name LIKE '%Direct%' THEN 'Direct'
	WHEN Campaign_Name LIKE '%Affiliate%' THEN 'Affiliate'
	WHEN Campaign_Name LIKE '%Email%' THEN 'Email'
	WHEN Campaign_Name LIKE '%seo%' THEN 'SEO'
    ELSE 'Other'
END AS curated_channel,
Channel,
CASE
   WHEN Channel='Google ads' THEN 'Paid Search'
   WHEN Channel IN ('Instagram','Facebook','WhatsApp') THEN 'Social Media'
   WHEN Channel='Email' THEN 'Email'
   WHEN Channel='SEO' THEN 'Organic Search'
   WHEN Channel='Youtube' THEN 'Video'
   ELSE 'Other'
END as Channel_Group,
Start_Date,
YEAR(Start_Date) as Start_Year,
DATENAME(MONTH,Start_Date) as Start_Month,
CONCAT('Q',DATEPART(QUARTER,Start_Date))as Start_Quarter,
End_Date,
Spend_Amount,
Clicks,
Impressions,
Leads,
Orders,
Revenue,
datediff(DAY,Start_Date,End_Date) as Campaign_duration,
(Revenue/Spend_Amount) as ROAS,
(Spend_Amount/Orders) as CPA,
(Orders/Clicks) as Converstion_Rate,
(Clicks/Impressions) as CTR, 
(Spend_Amount/Clicks)as CPC
from marketing_campaigns


---------------------------------
CREATE VIEW Marketing_Campaigns_View
AS
SELECT
Campaign_ID,
Campaign_Name,
CASE
   WHEN LOWER(Campaign_Name) LIKE '%instagram%' THEN 'Instagram'
   WHEN LOWER(Campaign_Name) LIKE '%facebook%' THEN 'Facebook'
   WHEN LOWER(Campaign_Name) LIKE '%whatsapp%' THEN 'WhatsApp'
   WHEN LOWER(Campaign_Name) LIKE '%youtube%' THEN 'YouTube'
   WHEN LOWER(Campaign_Name) LIKE '%google ads%' THEN 'Google Ads'
   WHEN LOWER(Campaign_Name) LIKE '%direct%' THEN 'Direct'
   WHEN LOWER(Campaign_Name) LIKE '%affiliate%' THEN 'Affiliate'
   WHEN LOWER(Campaign_Name) LIKE '%email%' THEN 'Email'
   WHEN LOWER(Campaign_Name) LIKE '%seo%' THEN 'SEO'
   ELSE 'Other'
END AS Curated_Channel,
Channel,
CASE
    WHEN LOWER(Channel) = 'google ads' THEN 'Paid Search'
    WHEN LOWER(Channel) IN ('instagram', 'facebook', 'whatsapp') THEN 'Social Media'
    WHEN LOWER(Channel) = 'email' THEN 'Email'
    WHEN LOWER(Channel) = 'seo' THEN 'Organic Search'
    WHEN LOWER(Channel) = 'youtube' THEN 'Video'
    ELSE 'Other'
END AS Channel_Group,
Start_Date,
YEAR(Start_Date) AS Start_Year,
DATENAME(MONTH, Start_Date) AS Start_Month,
CONCAT('Q', DATEPART(QUARTER, Start_Date)) AS Start_Quarter,
End_Date,
Spend_Amount,
Clicks,
Impressions,
Leads,
Orders,
Revenue,
DATEDIFF(DAY, Start_Date, End_Date) AS Campaign_Duration,
Format( Revenue / NULLIF(Spend_Amount, 0),'n2') AS ROAS,
format(Spend_Amount / NULLIF(Orders, 0),'n2') AS CPA,
format(CAST(Orders AS DECIMAL(18,4)) / NULLIF(Clicks, 0),'p2') AS Conversion_Rate,
Format(CAST(Clicks AS DECIMAL(18,4)) / NULLIF(Impressions, 0),'p2') AS CTR,
Spend_Amount / NULLIF(Clicks, 0) AS CPC
FROM marketing_campaigns;

select * from Marketing_Campaigns_View

-----------------------------------------------------------------------------------------------

Select * from  order_details


SELECT
Order_ID,
Order_Status,
Order_Date,
Delivery_Date,
Cancellation_Date,
Return_Date,
COALESCE(Return_Reason, 'N/A') AS Return_Reason
FROM order_details;

CREATE VIEW order_details_view AS
SELECT
    Order_ID,
    Order_Status,
    Order_Date,
    Delivery_Date,
    Cancellation_Date,
    Return_Date,
    COALESCE(Return_Reason, 'N/A') AS Return_Reason
FROM order_details;

select * from order_details_view



-----------------------------------------------------------------------------------------------------------------
select * from payment_transactions


Create view Payment_Transactions_View
As
SELECT * from payment_transactions

select * from Payment_Transactions_View


---------------------------------------------------------------------------------------------------------
Select * from product_master


select 
Product_ID,
Product_Name,
Product_Category,
Product_Sub_Category,
Brand,
Product_Cost,
Selling_Price,
Launch_Date,
Supplier_ID,
Product_Rating,
Product_Status,
(Selling_Price-Product_Cost) as Profit,
CASE
   WHEN Selling_Price< 1000  THEN '$0-$1k'
   WHEN Selling_Price< 5000  THEN '$1K-$5k'
   WHEN Selling_Price< 10000 THEN '$5k-$10k'
   WHEN Selling_Price< 25000 THEN '$10k-$25k'
   WHEN Selling_Price< 50000 THEN '$25k-$50k'
   ELSE '50k+'
END as Price_Range,
  DATEDIFF(DAY, Launch_Date, CAST(GETDATE() AS DATE)) AS Days_Since_Launch,
((Selling_Price-Product_Cost)/Selling_Price) as Profit_Margin,
CASE
   WHEN Product_Rating> 4.5 THEN 'Excellent'
   WHEN Product_Rating> 4 THEN 'Good'
   WHEN Product_Rating> 3 THEN 'Average'
   ELSE 'Poor'
END as Product_Rating_Group

from product_master

CREATE VIEW Product_Master_View AS
SELECT
    Product_ID,
    Product_Name,
    Product_Category,
    Product_Sub_Category,
    Brand,
    Product_Cost,
    Selling_Price,
    Launch_Date,
    Supplier_ID,
    Product_Rating,
    Product_Status,

    (Selling_Price - Product_Cost) AS Profit,

    CASE
        WHEN Selling_Price < 1000 THEN '$0-$1K'
        WHEN Selling_Price < 5000 THEN '$1K-$5K'
        WHEN Selling_Price < 10000 THEN '$5K-$10K'
        WHEN Selling_Price < 25000 THEN '$10K-$25K'
        WHEN Selling_Price < 50000 THEN '$25K-$50K'
        ELSE '$50K+'
    END AS Price_Range,

    DATEDIFF(DAY, Launch_Date, CAST(GETDATE() AS DATE)) AS Days_Since_Launch,

    ROUND(
        ((Selling_Price - Product_Cost) * 100.0) /
        NULLIF(Selling_Price, 0), 2
    ) AS Profit_Margin,

    CASE
        WHEN Product_Rating > 4.5 THEN 'Excellent'
        WHEN Product_Rating > 4.0 THEN 'Good'
        WHEN Product_Rating > 3.0 THEN 'Average'
        ELSE 'Poor'
    END AS Product_Rating_Group

FROM product_master;

------------------------------------------------------------------------------------------------------------------------------------------
select * from sales_transactions

SELECT
    order_id,
    Order_Date,
    Customer_ID,
    Product_ID,
    Quantity,
    Unit_Price,
    Discount_Amount,
    Gross_Sales,
    Tax_Amount,
    Net_Sales,
    Product_Cost,
    Profit,
    Payment_ID,
    Delivery_ID,
    COALESCE(Campaign_ID, 'N/A') AS Campaign_ID,
    Order_Channel
FROM sales_transactions;



CREATE VIEW sales_transactions_view AS
SELECT
    order_id,
    Order_Date,
    Customer_ID,
    Product_ID,
    Quantity,
    Unit_Price,
    Discount_Amount,
    Gross_Sales,
    Tax_Amount,
    Net_Sales,
    Product_Cost,
    Profit,
    Payment_ID,
    Delivery_ID,
    COALESCE(Campaign_ID, 'N/A') AS Campaign_ID,
    Order_Channel
FROM sales_transactions;

Select * from sales_transactions_view

------------------------------------------------------------------------------------------------------------------------------------------

Select * from supplier_master


create view Supplier_Master_View
as
select * from supplier_master


-------------------------------------------------------------------------------------------------------------


Select * from website_analytics

select 
Visit_ID,
Customer_ID,
Visit_Date,
Device_Type,
Browser,
Traffic_Source,
Page_Views,
Session_Duration_Seconds,
Cart_Additions,
Checkout_Started
from website_analytics

-----------------------------------------------------------------------------------------------------------------------
-- due to duplicates values it is makes a many to many joins therefore to avoid messing the data remove the duplicate values


WITH ranked_visits AS (
    SELECT
        Visit_ID,
        Customer_ID,
        Visit_Date,
        Device_Type,
        Browser,
        Traffic_Source,
        Page_Views,
        Session_Duration_Seconds,
        Cart_Additions,
        Checkout_Started,
        ROW_NUMBER() OVER (
            PARTITION BY Customer_ID
            ORDER BY Visit_Date DESC, Visit_ID DESC
        ) AS rn
    FROM website_analytics
)
SELECT
    Visit_ID,
    Customer_ID,
    Visit_Date,
    Device_Type,
    Browser,
    Traffic_Source,
    Page_Views,
    Session_Duration_Seconds,
    Cart_Additions,
    Checkout_Started
FROM ranked_visits
WHERE rn = 1;


Create view Website_analytics_views
as
WITH ranked_visits AS (
    SELECT
        Visit_ID,
        Customer_ID,
        Visit_Date,
        Device_Type,
        Browser,
        Traffic_Source,
        Page_Views,
        Session_Duration_Seconds,
        Cart_Additions,
        Checkout_Started,
        ROW_NUMBER() OVER (
            PARTITION BY Customer_ID
            ORDER BY Visit_Date DESC, Visit_ID DESC
        ) AS rn
    FROM website_analytics
)
SELECT
    Visit_ID,
    Customer_ID,
    Visit_Date,
    Device_Type,
    Browser,
    Traffic_Source,
    Page_Views,
    Session_Duration_Seconds,
    Cart_Additions,
    Checkout_Started
FROM ranked_visits
WHERE rn = 1;
go

Select * from Website_analytics_views

--------------------------------------------------------------------------------------------------------------------------------------------------------------
select * from Customer_Master_View
select * from Customer_Review_View
select * from Delivery_Logistics_view
select * from Inventory_Stock_View
select * from Marketing_Campaigns_View
select * from order_details_view
select * from Payment_Transactions_View
select * from Product_Master_View
select * from sales_transactions_view
select * from Supplier_Master_View
select * from Website_analytics_views















































