import pandas as pd
import random
from faker import Faker
from datetime import datetime, timedelta

fake = Faker()

# Config
ROWS = 200_000   # total transactions to generate
FRAUD_RATIO = 0.02   # 2% fraud
customers = [f"CUST{str(i).zfill(5)}" for i in range(1, 5001)]
merchants = ["Amazon", "Walmart", "Uber", "Netflix", "Gucci", "Apple Store", "Starbucks", "Shell Gas"]

data = []

for i in range(ROWS):
    customer_id = random.choice(customers)
    txn_time = fake.date_time_between(start_date="-1y", end_date="now")
    merchant = random.choice(merchants)
    location = fake.city()
    payment_method = random.choice(["CreditCard", "DebitCard", "UPI", "Wallet"])
    
    # Default (normal transaction)
    amount = round(random.uniform(5, 500), 2)
    is_fraud = 0
    
    # Inject fraud patterns (2% transactions)
    if random.random() < FRAUD_RATIO:
        is_fraud = 1
        fraud_type = random.choice(["high_amount", "rapid_fire", "impossible_travel", "odd_merchant", "time_based"])
        
        if fraud_type == "high_amount":
            amount = round(random.uniform(5000, 20000), 2)
        
        elif fraud_type == "rapid_fire":
            txn_time = datetime.now()
            amount = round(random.uniform(100, 500), 2)
        
        elif fraud_type == "impossible_travel":
            location = random.choice(["New York", "London", "Tokyo", "Sydney"])
            amount = round(random.uniform(50, 2000), 2)
        
        elif fraud_type == "odd_merchant":
            merchant = random.choice(["Luxury Watches", "Jewelry Store", "Private Jet Rentals"])
            amount = round(random.uniform(2000, 15000), 2)
        
        elif fraud_type == "time_based":
            txn_time = txn_time.replace(hour=random.choice([1, 2, 3, 4]))
            amount = round(random.uniform(500, 3000), 2)
    
    data.append([i+1, customer_id, txn_time, amount, merchant, location, payment_method, is_fraud])

# Create DataFrame
df = pd.DataFrame(data, columns=[
    "txn_id", "customer_id", "txn_datetime", "amount", "merchant", "location", "payment_method", "is_fraud"
])

df.to_csv("synthetic_creditcard_fraud.csv", index=False)
print("✅ Synthetic fraud dataset generated successfully!")
