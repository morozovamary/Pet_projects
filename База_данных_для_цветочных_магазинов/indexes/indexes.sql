Индексируем таблицу flowers_in_purchases:

CREATE INDEX idx_flowers_in_purchases_variety_id ON flowers_in_purchases (variety_id);
CREATE INDEX idx_flowers_in_purchases_purchase_id ON flowers_in_purchases (purchase_id);

Индексируем таблицу flowers_in_delivery:

CREATE INDEX idx_flowers_in_delivery_variety_id ON flowers_in_delivery (variety_id);
CREATE INDEX idx_flowers_in_delivery_delivery_id ON flowers_in_delivery (delivery_id);

Индексируем таблицу flowers_in_shops:

CREATE INDEX idx_flowers_in_shops_variety_id ON flowers_in_shops (variety_id);
CREATE INDEX idx_flowers_in_shops_shop_id ON flowers_in_shops (shop_id);
