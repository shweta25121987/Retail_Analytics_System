/* 1. Create table orders*/
create table orders(
order_id TEXT,
customer_id TEXT,
order_status TEXT,
order_purchase_timestamp TIMESTAMP,
order_approved_at TIMESTAMP,
order_delivered_carrier_date TIMESTAMP,
order_delivered_customer_date TIMESTAMP,
order_estimated_delivery_date TIMESTAMPgit
);

/* 2. Check first 10 rows of orders table */
select *from orders LIMIT 10;

/* 3. Check all columns for missing values in orders table*/
select count(*) total_rows,
count(order_id) AS order_id_not_null,
count(customer_id) AS customer_id_not_null,
count(order_purchase_timestamp) AS purchase_not_null,
count(order_approved_at) AS approved_not_null,
count(order_delivered_carrier_date) AS carrier_not_null,
count(order_delivered_customer_date) AS delivered_not_null,
count(order_estimated_delivery_date) AS estimated_not_null
from orders;
/*
🔍 Key Learning:
Missing values are not always errors — they often represent real business scenarios like pending or cancelled orders.
📌 This analysis can help improve logistics performance, reduce cancellations, and enhance customer satisfaction.*/


/* 4. Business KPI's:  Delivery Success % */
select ROUND(100.0*SUM(CASE WHEN order_status='delivered' THEN 1 ELSE 0 END)/COUNT(*),2) AS delivery_success_percentage
from orders;
/*Business Insight:97.02% is ~97% delivery success rate indicates strong logistics performance and efficient order fullfilment */


/*Undelivered Orders Percentage */
select ROUND(100.0*SUM(CASE WHEN order_status!='delivered' THEN 1 ELSE 0 END)/COUNT(*),2) AS Undelivered_orders_rate
from orders;
/*Business Insight:2.98% is ~3% undeliverd orders rate highlights potential revenue loss and areas for improving delivery options */


/*Payment Approval %  */
select ROUND(100.0*count(order_approved_at)/count(*),2) AS payment_success_percentage
from orders;
/*Business Insight: 99.8% payment_success_percentage shows highly relaible payment system wioth minimal transaction failure. */

/*On_time_delivery %  */
select ROUND(100.0*SUM(CASE WHEN order_delivered_customer_date<=order_estimated_delivery_date THEN 1 ELSE 0 END)/COUNT(*),2) 
AS on_time_delivery_percentage
from orders;
/*Business Insight:89.15% on_time_delivery_percentage is high which improves customer satisfaction and retention */

/*Order_growth_trend */

select DATE(order_purchase_timestamp) AS order_date,
count(*) AS total_orders
from orders
group by order_date
order by order_date;
/*This is a trend Data*/

/*Total orders shows overall business growth*/
select count(*) As total_orders from orders;
/* 99441 Total orders shows overall business growth */

/* Average Daily orders*/
SELECT 
AVG(daily_orders) AS avg_daily_orders
FROM (
    SELECT 
    DATE(order_purchase_timestamp) AS order_date,
    COUNT(*) AS daily_orders
    FROM orders
    GROUP BY order_date
) sub;
/* Business Insight: 156.84 is the Average daily orders helps to understand the noramal demand level */


/*Peak Day (Highest Demand)*/
SELECT 
DATE(order_purchase_timestamp) AS order_date,
COUNT(*) AS total_orders
FROM orders
GROUP BY order_date
ORDER BY total_orders DESC
LIMIT 1;
/*Business Insight:"2017-11-24"	1176 Identifies highest demand day with total_orders → useful for planning*/

/*Growth Trend (Month-wise)*/
SELECT 
DATE_TRUNC('month', order_purchase_timestamp) AS month,
COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;
/* Business Insight:Shows business growth over time */

