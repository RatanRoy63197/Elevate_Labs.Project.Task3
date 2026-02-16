DROP TABLE IF EXISTS amazonsale;

CREATE TABLE amazonsale(
index SERIAL,
order_id VARCHAR(70) NOT NULL,
date TEXT,
status VARCHAR(120),
fulfilment VARCHAR(120),
sales_channel VARCHAR(120),
ship_service_level VARCHAR(120),
style CHAR(70),
sku CHAR(70),
category VARCHAR(120),
size CHAR(70),
asin CHAR(70),
courier_status CHAR(70),
qty INTEGER,
currency CHAR(70),
amount NUMERIC(10,2),
ship_city VARCHAR(120),
ship_state VARCHAR(120),
ship_postal_code INTEGER,
ship_country CHAR(70),
b2b BOOLEAN,
process VARCHAR(120)
);

-- DATA EXPLORATION
SELECT * FROM amazonsale;
--COUNT OF ROWS
SELECT COUNT (*) FROM amazonsale;

--SAMPLE DATA SHOWS
SELECT * FROM amazonsale
LIMIT 10;

--UPDATE DATE 
UPDATE amazonsale
SET date = TO_DATE(date, 'MM-DD-YY');

--Null Values
SELECT * FROM amazonsale
WHERE index IS NULL
OR order_id IS NULL
OR date IS NULL
OR status IS NULL
OR fulfilment IS NULL
OR sales_channel IS NULL
OR ship_service_level IS NULL
OR style IS NULL
OR sku IS NULL
OR category IS NULL
OR size IS NULL
OR asin IS NULL
OR courier_status IS NULL
OR qty IS NULL
OR currency IS NULL
OR amount IS NULL
OR ship_city IS NULL
OR ship_state IS NULL
OR ship_postal_code IS NULL
OR ship_country IS NULL
OR b2b IS NULL
OR process IS NULL;

--NULL VALUE CLENING
UPDATE amazonsale
SET
courier_status = COALESCE(courier_status,'Unknown'),
currency = COALESCE(currency,'NA'),
amount = COALESCE(amount,0),
ship_city = COALESCE(ship_city,'NA'),
ship_postal_code = COALESCE(ship_postal_code,0),
ship_country = COALESCE(ship_city,'NA'),
ship_state = COALESCE(ship_state,'NA'),
process = COALESCE(process,'NA');

--Q1.Different Product Cetegories
SELECT DISTINCT category
FROM amazonsale
ORDER BY category;

--Q2.Product Names Present Multiple times
SELECT category, COUNT(order_id) AS "Number of orders"
FROM amazonsale
GROUP BY category
HAVING COUNT(order_id) > 1
ORDER BY COUNT(order_id) DESC;

--Q3.What % of orders are getting cancelled
SELECT
ROUND(
100.0 * SUM(CASE WHEN status ILIKE '%cancel%' THEN 1 ELSE 0 END)
/ COUNT(*),2) AS cancel_percentage
FROM amazonsale;

--Q4.Revenue by Fulfilment Type
SELECT fulfilment,
SUM(amount) AS total_revenue
FROM amazonsale
GROUP BY fulfilment
ORDER BY total_revenue DESC;

--Q5.Top 5 Cities by Revenue
SELECT ship_city,
SUM(amount) AS revenue
FROM amazonsale
GROUP BY ship_city
ORDER BY revenue DESC
LIMIT 5;

--Q6.Which Categories Make the Most Money
SELECT category,
SUM(amount) AS revenue
FROM amazonsale
GROUP BY category
ORDER BY revenue DESC;

--Q7.Average Order Value
SELECT ROUND(AVG(amount),2) AS avg_order_value
FROM amazonsale
WHERE amount > 0;

--Q8.Delivered vs Cancelled Quantity
SELECT status,
SUM(qty) AS total_qty
FROM amazonsale
GROUP BY status;

--Q9.B2B vs B2C Revenue
SELECT b2b,
SUM(amount) AS revenue
FROM amazonsale
GROUP BY b2b;

--Q10.Courier Performance
SELECT courier_status,
COUNT(*) AS orders
FROM amazonsale
GROUP BY courier_status;

--Q11.Which state gives highest revenue per order
SELECT ship_state,
ROUND(SUM(amount)/COUNT(*),2) AS revenue_per_order
FROM amazonsale
GROUP BY ship_state
ORDER BY revenue_per_order DESC;

--Q12.Repeat SKU Performance
SELECT sku,
SUM(qty) AS total_sold
FROM amazonsale
GROUP BY sku
ORDER BY total_sold DESC
LIMIT 5;

--Q13.Merchant vs Amazon Delivery Success Rate
SELECT fulfilment,
ROUND(
100.0 * SUM(CASE WHEN status ILIKE '%shipped%' THEN 1 ELSE 0 END)
/ COUNT(*),2) AS delivery_success
FROM amazonsale
GROUP BY fulfilment;

--Q14.How do you calculate Total Revenue
SELECT SUM(amount) AS total_revenue
FROM amazonsale
WHERE amount > 0;

--Q15.What is Average Order Value and why important
SELECT ROUND(AVG(amount),2) AS aov
FROM amazonsale
WHERE amount > 0;

--Q16.How do you find Cancellation Rate?
SELECT
ROUND(
100.0 * SUM(CASE WHEN status ILIKE '%cancel%' THEN 1 ELSE 0 END)
/ COUNT(*),2) AS cancellation_percentage
FROM amazonsale;

--Q17.Which cities generate the highest revenue
SELECT ship_city,
SUM(amount) AS revenue
FROM amazonsale
GROUP BY ship_city
ORDER BY revenue DESC
LIMIT 5;

--Q18.How do you compare Merchant vs Amazon fulfilment
SELECT fulfilment,
SUM(amount) AS revenue
FROM amazonsale
GROUP BY fulfilment;

--Q19.How do you identify Top Selling Products
SELECT sku,
SUM(qty) AS total_sold
FROM amazonsale
GROUP BY sku
ORDER BY total_sold DESC
LIMIT 5;

--Q20.How do you find Revenue per State
SELECT ship_state,
SUM(amount) AS revenue
FROM amazonsale
GROUP BY ship_state
ORDER BY revenue DESC;

--Q21.How do you measure Delivery Success Rate
SELECT
ROUND(
100.0 * SUM(CASE WHEN status ILIKE '%shipped%' THEN 1 ELSE 0 END)
/ COUNT(*),2) AS delivery_success
FROM amazonsale;

