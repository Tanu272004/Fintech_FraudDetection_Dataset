📌 README.md
# FinTech Fraud Analytics Dashboard 🚨💳

## 📖 Project Overview
This project is an **end-to-end FinTech Fraud Detection & Analytics pipeline**.  
We engineered a synthetic dataset of **200,000+ credit card transactions** with injected fraud patterns, stored it in **MySQL**, queried insights with **SQL**, and built an **interactive Power BI dashboard**.  

The dashboard uncovers **fraud hotspots** by:
- Peak hours of fraudulent activity
- High-risk merchants
- Fraud-prone cities
- Risk by payment method
- Repeat offenders (customers with multiple frauds)

---

## ⚙️ Tech Stack
- **Python** → Data generation (Faker, Random, Pandas)
- **MySQL** → Database storage & SQL queries
- **Power BI** → Interactive dashboard visualization
- **Quadratic AI** → Exported CSV in AI-first spreadsheet

---

## 📊 Business Insights
- **Peak Hours**: Fraud spikes between **11:00 AM – 1:00 PM**  
- **Top Merchants**: Jewellery Stores & Luxury Watches are highly targeted  
- **Hotspot Locations**: New York, Tokyo, Sydney  
- **Payment Methods**: UPI & Wallet show higher fraud risk  
- **Repeat Offenders**: A small cluster of customers is responsible for multiple frauds  

---

## 🛠️ Setup Instructions
### 1. Clone Repo
```bash
git clone https://github.com/<your-username>/Fintech-Fraud-Analytics.git
cd Fintech-Fraud-Analytics

2. Install Dependencies
pip install -r requirements.txt

3. Generate Synthetic Data

Run the Python script to create a synthetic dataset:

python generate_fraud_data.py


This will create a CSV file: synthetic_creditcard_fraud.csv

4. Load into MySQL
CREATE DATABASE fintech_fraud;
USE fintech_fraud;

-- Create table
CREATE TABLE transactions (
  txn_id INT PRIMARY KEY,
  customer_id VARCHAR(20),
  txn_datetime DATETIME,
  amount DECIMAL(10,2),
  merchant VARCHAR(100),
  location VARCHAR(100),
  payment_method VARCHAR(50),
  is_fraud TINYINT
);

-- Import CSV
LOAD DATA INFILE 'synthetic_creditcard_fraud.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

5. Run SQL Queries

Refer to queries.sql for:

Fraud by hour

Fraud by location

High-value fraud detection

Repeat offenders

6. Power BI Dashboard

Import the MySQL table into Power BI

Add slicers (time, payment method)

Add KPIs, donut charts, fraud heatmaps

🚀 Future Improvements

Deploy ML-based fraud detection model

Stream real-time fraud alerts with Kafka & Spark

Integrate with Azure Synapse for scalable storage

📌 Author

Thank You
LinkedIn: https://www.linkedin.com/in/tanmay-sharma-800599373/ 
Git Hub: https://github.com/Tanu272004/Fintech_FraudDetection_Dataset.git


