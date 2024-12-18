CREATE TABLE IF NOT EXISTS flowers (
  variety_id INT PRIMARY KEY,
  flower_name VARCHAR(64) NOT NULL,
  colour VARCHAR(64) NOT NULL,
  is_potted BIT DEFAULT(0),
  size NUMERIC NOT NULL
);


CREATE TABLE IF NOT EXISTS shops (
  shop_id INT PRIMARY KEY,
  shop_name VARCHAR(64) NOT NULL,
  shop_adress VARCHAR(128) NOT NULL,
  shop_number INT NOT NULL,
  rental_cost INT NOT NULL
);


CREATE TABLE IF NOT EXISTS providers (
  provider_id INT PRIMARY KEY,
  provider_name VARCHAR(64) NOT NULL,
  provider_adress VARCHAR(128) NOT NULL,
  provider_number INT NOT NULL
);


CREATE TABLE IF NOT EXISTS delivery (
  delivery_id INT PRIMARY KEY,
  delivery_time NUMERIC NOT NULL,
  shop_id INT REFERENCES shops(shop_id),
  provider_id INT REFERENCES providers(provider_id)
);


CREATE TABLE IF NOT EXISTS purchases (
  purchases_id INT PRIMARY KEY,
  time NUMERIC NOT NULL,
  shop_id INT REFERENCES shops(shop_id),
  total INT NOT NULL
);


CREATE TABLE IF NOT EXISTS flowers_in_purchases (
  variety_id INT REFERENCES flowers(variety_id),
  purchase_id INT REFERENCES purchases(purchases_id),
  quantity_in_purchase INT NOT NULL,

  PRIMARY KEY(variety_id, purchase_id)
);


CREATE TABLE IF NOT EXISTS flowers_in_delivery (
  variety_id INT REFERENCES flowers(variety_id),
  delivery_id INT REFERENCES delivery(delivery_id),
  quantity_in_delivery INT NOT NULL,
  wholesale_price NUMERIC NOT NULL,

  PRIMARY KEY(variety_id, delivery_id)
);


CREATE TABLE IF NOT EXISTS flowers_in_shops (
  variety_id INT REFERENCES flowers(variety_id),
  shop_id INT REFERENCES shops(shop_id),
  quantity_in_shops INT NOT NULL,
  retail_price NUMERIC NOT NULL,

  PRIMARY KEY(variety_id, shop_id)
);


CREATE TABLE IF NOT EXISTS shops_financial_statistics (
  shop_id INT REFERENCES shops(shop_id),
  purchase_number INT NOT NULL,
  average_bill NUMERIC NOT NULL,
  turnover NUMERIC NOT NULL,
  profit NUMERIC NOT NULL,
  start_dttm DATE NOT NULL,
  end_dttm DATE NOT NULL,

  CHECK (end_dttm > start_dttm),
  PRIMARY KEY(shop_id, start_dttm)
);

