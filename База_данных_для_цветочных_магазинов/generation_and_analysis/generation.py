import sqlite3
from faker import Faker
import random
import datetime
import pandas as pd
import matplotlib.pyplot as plt

conn = sqlite3.connect('flower_shop.db')
c = conn.cursor()

fake = Faker()

variety_ids = random.sample(range(1, 100), 10)
for variety_id in variety_ids:
    flower_name = fake.word()
    colour = fake.color_name()
    is_potted = random.choice([0, 1])
    size = round(random.uniform(1, 10), 2)
    c.execute("INSERT INTO flowers VALUES (?, ?, ?, ?, ?)", (variety_id, flower_name, colour, is_potted, size))


shop_ids = random.sample(range(1, 100), 5)
for shop_id in shop_ids:
    shop_name = fake.company()
    shop_address = fake.address()
    shop_number = fake.phone_number()
    rental_cost = fake.random_int(min=1000, max=5000)
    c.execute("INSERT INTO shops VALUES (?, ?, ?, ?, ?)", (shop_id, shop_name, shop_address, shop_number, rental_cost))


provider_ids = random.sample(range(1, 100), 3)
for provider_id in provider_ids:
    provider_name = fake.company()
    provider_address = fake.address()
    provider_number = fake.phone_number()
    c.execute("INSERT INTO providers VALUES (?, ?, ?, ?)", (provider_id, provider_name, provider_address, provider_number))


delivery_ids = random.sample(range(1, 100), 20)
for delivery_id in delivery_ids:
    delivery_time = fake.date_time_this_month()
    shop_id = random.sample(shop_ids, 1)[0]
    provider_id = random.sample(provider_ids, 1)[0]
    c.execute("INSERT INTO delivery VALUES (?, ?, ?, ?)", (delivery_id, delivery_time, shop_id, provider_id))


purchase_ids = random.sample(range(1, 100), 50)
for purchase_id in purchase_ids:
    time = fake.date_time_this_year()
    shop_id = random.sample(shop_ids, 1)[0]
    total = fake.random_int(min=10, max=500)
    c.execute("INSERT INTO purchases VALUES (?, ?, ?, ?)", (purchase_id, time, shop_id, total))


for _ in range(100):
    variety_id = random.sample(variety_ids, 1)[0]
    purchase_id = random.sample(purchase_ids, 1)[0]
    quantity_in_purchase = fake.random_int(min=1, max=10)
    c.execute("INSERT INTO flowers_in_purchases VALUES (?, ?, ?)", (variety_id, purchase_id, quantity_in_purchase))


for _ in range(100):
    variety_id = random.sample(variety_ids, 1)[0]
    delivery_id = random.sample(delivery_ids, 1)[0]
    quantity_in_delivery = fake.random_int(min=1, max=10)
    wholesale_price = round(random.uniform(1, 20), 2)
    c.execute("INSERT INTO flowers_in_delivery VALUES (?, ?, ?, ?)", (variety_id, delivery_id, quantity_in_delivery, wholesale_price))


for _ in range(100):
    variety_id = random.sample(variety_ids, 1)[0]
    shop_id = random.sample(shop_ids, 1)[0]
    quantity_in_shops = fake.random_int(min=1, max=20)
    retail_price = round(random.uniform(5, 50), 2)
    c.execute("INSERT INTO flowers_in_shops VALUES (?, ?, ?, ?)", (variety_id, shop_id, quantity_in_shops, retail_price))


for shop_id in shop_ids:
    purchase_number = fake.random_int(min=50, max=200)
    average_bill = round(random.uniform(20, 100), 2)
    turnover = round(average_bill * purchase_number, 2)
    profit = round(turnover * random.uniform(0.1, 0.3), 2)
    start_dttm = fake.date_time_this_year()
    end_dttm = start_dttm + datetime.timedelta(days=30)
    c.execute("INSERT INTO shops_financial_statistics VALUES (?, ?, ?, ?, ?, ?, ?)", 
                   (shop_id, purchase_number, average_bill, turnover, profit, start_dttm, end_dttm))

conn.commit()
conn.close()

conn = sqlite3.connect('flower_shop.db')

query = "SELECT shop_id, turnover, profit FROM shops_financial_statistics WHERE end_dttm = '2024-05-09'"
data = pd.read_sql_query(query, conn)

conn.close()


plt.figure(figsize=(10, 6))
plt.bar(data['shop_id'], data['turnover'], color='skyblue', label='Оборот')
plt.bar(data['shop_id'], data['profit'], color='salmon', label='Выручка')
plt.xlabel('Индекс магазина')
plt.ylabel('')
plt.title('Оборот и выручка для каждого магазина за 9 мая 2024')
plt.legend()
plt.xticks(data['shop_id'])
plt.grid(axis='y', linestyle='--', alpha=0.7)
plt.show()
