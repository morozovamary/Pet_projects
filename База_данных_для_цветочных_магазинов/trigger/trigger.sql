Триггер для обновления стоимости покупки при изменении количества цветов:

CREATE OR REPLACE FUNCTION update_purchase_total()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE purchases
    SET total = (SELECT SUM(quantity_in_purchase * retail_price) FROM flowers_in_purchases WHERE purchase_id = NEW.purchase_id)
    WHERE purchases_id = NEW.purchase_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_purchase_total_trigger
AFTER INSERT OR UPDATE ON flowers_in_purchases
FOR EACH ROW
EXECUTE FUNCTION update_purchase_total();

Триггер для обновления количества цветов в магазине после поставки:

CREATE OR REPLACE FUNCTION update_flowers_in_shops()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE flowers_in_shops
    SET quantity_in_shops = quantity_in_shops + NEW.quantity_in_delivery
    WHERE variety_id = NEW.variety_id AND shop_id = (SELECT shop_id FROM delivery WHERE delivery_id = NEW.delivery_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_flowers_in_shops_trigger
AFTER INSERT ON flowers_in_delivery
FOR EACH ROW
EXECUTE FUNCTION update_flowers_in_shops();

Триггер для обновления статистики магазина при добавлении покупки:

CREATE OR REPLACE FUNCTION update_shop_statistics()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE shops_financial_statistics
    SET purchase_number = purchase_number + 1,
        average_bill = (average_bill * purchase_number + NEW.total) / (purchase_number + 1),
        turnover = turnover + NEW.total,
        profit = turnover - rental_cost
    WHERE shop_id = NEW.shop_id AND CURRENT_DATE BETWEEN start_dttm AND end_dttm;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_shop_statistics_trigger
AFTER INSERT ON purchases
FOR EACH ROW
EXECUTE FUNCTION update_shop_statistics();

