Сравнение оптивых и розничных цен в магазинах:

CREATE VIEW flower_price_comparison_view AS
SELECT s.shop_name, f.flower_name, f.colour, fs.retail_price, fd.wholesale_price
FROM flowers_in_shops fs
JOIN shops s ON fs.shop_id = s.shop_id
JOIN flowers f ON fs.variety_id = f.variety_id
JOIN flowers_in_delivery fd ON fd.variety_id = fs.variety_id AND fd.delivery_id = (SELECT MAX(delivery_id) FROM delivery WHERE shop_id = s.shop_id);


Магазины с прибылью выше среднего:

CREATE VIEW profitable_shops_view AS
SELECT s.shop_name, sfs.profit
FROM shops_financial_statistics sfs
JOIN shops s ON sfs.shop_id = s.shop_id
WHERE sfs.profit > (SELECT AVG(profit) FROM shops_financial_statistics);


Финансовая статистика по магазинам:

CREATE VIEW shop_financial_overview_view AS
SELECT s.shop_name, sfs.turnover, sfs.profit, sfs.average_bill
FROM shops_financial_statistics sfs
JOIN shops s ON sfs.shop_id = s.shop_id;


История покупок:

CREATE VIEW purchase_history_view AS
SELECT p.time, s.shop_name, f.flower_name, f.colour, fp.quantity_in_purchase, p.total
FROM purchases p
JOIN shops s ON p.shop_id = s.shop_id
JOIN flowers_in_purchases fp ON p.purchases_id = fp.purchase_id
JOIN flowers f ON fp.variety_id = f.variety_id;

Запас цветов в магазинах:

CREATE VIEW flower_inventory_view AS
SELECT fs.shop_id, s.shop_name, f.flower_name, f.colour, fs.quantity_in_shops, fs.retail_price
FROM flowers_in_shops fs
JOIN shops s ON fs.shop_id = s.shop_id
JOIN flowers f ON fs.variety_id = f.variety_id;

