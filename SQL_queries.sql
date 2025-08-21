-- Create Database
CREATE DATABASE fintech_fraud;

-- Use Database
USE fintech_fraud;

-- Create Table for Transactions
CREATE TABLE transactions (
    txn_id BIGINT PRIMARY KEY,
    customer_id VARCHAR(20),
    txn_datetime DATETIME,
    amount DECIMAL(12,2),
    merchant VARCHAR(100),
    location VARCHAR(100),
    payment_method VARCHAR(20),
    is_fraud TINYINT
);
truncate table transactions;
drop table transactions;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.3/Uploads/synthetic_creditcard_fraud.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- SET GLOBAL local_infile = 'ON';
-- SHOW GLOBAL VARIABLES LIKE 'local_infile';


-- Queries
-- Total Transactions, Fraud Transactions, Fraud % 
SELECT 
    COUNT(*) AS total_txns,
    SUM(is_fraud) AS fraud_txns,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_pct
FROM transactions;


-- Fraud by Payment Method
SELECT payment_method,
  SUM(is_fraud) AS fraud_txns,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_pct
FROM transactions
group by payment_method
Order by fraud_pct DESC;

-- Top Fraudulent Merchants
SELECT Merchant,
  SUM(is_fraud) AS fraud_txns,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_pct
FROM transactions
group by Merchant
Order by fraud_pct DESC;

-- Fraud by Hour of Day (Time-Based Fraud)
SELECT Hour(txn_datetime) as fraud_hour_of_Day,
  SUM(is_fraud) AS fraud_txns,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_pct
FROM transactions
group by Hour(txn_datetime)
Order by fraud_pct DESC;

-- Fraud by Location (Hotspot Cities) Part-1
SELECT location as Fraud_Locations,
  SUM(is_fraud) AS fraud_txns,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_pct
FROM transactions
group by Fraud_Locations
Order by fraud_txns DESC
Limit 10;

-- Fraud by Location (Hotspot Cities) Part-2
SELECT location as Fraud_Locations,
  SUM(is_fraud) AS fraud_txns,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_pct
FROM transactions
group by Fraud_Locations
Order by fraud_pct DESC
Limit 10;




-- High Amount Transactions (> $5000) – Fraud Check
SELECT 
    txn_id,
    customer_id,
    txn_datetime,
    amount,
    merchant,
    location,
    payment_method,
    is_fraud
FROM transactions
WHERE amount > 5000
ORDER BY amount DESC
LIMIT 10;


-- Repeat Offenders (Customers with Most Frauds)

SELECT 
    customer_id AS Repeated_Customers,
    COUNT(*) AS total_txns,
    SUM(is_fraud) AS fraud_txns,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_pct
FROM transactions
GROUP BY customer_id
ORDER BY fraud_txns DESC
LIMIT 10;

-- Month Over Month fraud_growth
WITH monthly_status AS (
    SELECT 
        YEAR(txn_datetime) AS year_growth_fraud,
        MONTH(txn_datetime) AS month_growth_fraud,
        COUNT(*) AS total_txns,
        SUM(is_fraud) AS fraud_txns,
        ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_pct
    FROM transactions
    GROUP BY YEAR(txn_datetime), MONTH(txn_datetime)
)
SELECT 
    year_growth_fraud,
    month_growth_fraud,
    total_txns,
    fraud_txns,
    fraud_pct,
    LAG(fraud_txns) OVER (ORDER BY year_growth_fraud, month_growth_fraud) AS prev_month_fraud,
    ROUND(
        ( (fraud_txns - LAG(fraud_txns) OVER (ORDER BY year_growth_fraud, month_growth_fraud)) 
          / NULLIF(LAG(fraud_txns) OVER (ORDER BY year_growth_fraud, month_growth_fraud), 0) ) * 100, 
        2
    ) AS mom_fraud_growth_pct
FROM monthly_status
ORDER BY year_growth_fraud, month_growth_fraud;

-- Rapid-Fire Fraud Detection (Multiple txns in <5 min)

SELECT t1.customer_id, t1.txn_id, t1.txn_datetime, t2.txn_id, t2.txn_datetime
FROM transactions t1
JOIN transactions t2 
  ON t1.customer_id = t2.customer_id 
 AND t1.txn_id < t2.txn_id
WHERE TIMESTAMPDIFF(MINUTE, t1.txn_datetime, t2.txn_datetime) <= 5
  AND (t1.is_fraud = 1 OR t2.is_fraud = 1)
ORDER BY t1.customer_id, t1.txn_datetime;


-- Fraud Heatmap by Merchant & Hour
SELECT Hour(txn_datetime) as hour_of_day, Merchant as Fraud_Mechants,
  SUM(is_fraud) AS fraud_txns,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_pct
FROM transactions
group by Hour(txn_datetime) ,Merchant
Order by fraud_pct DESC
Limit 10;
