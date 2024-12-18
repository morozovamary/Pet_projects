Общая выручка поставщика за поставку:

SELECT delivery_id, SUM(quantity_in_delivery * wholesale_price) AS total_revenue
FROM flowers_in_delivery
GROUP BY delivery_id
ORDER BY delivery_id;


Количество покупок различных цветов во всех магазинах:

SELECT s.shop_name, f.flower_name, SUM(fp.quantity_in_purchase) AS total_purchases
FROM shops s
JOIN purchases p ON s.shop_id = p.shop_id
JOIN flowers_in_purchases fp ON p.purchases_id = fp.purchase_id
JOIN flowers f ON fp.variety_id = f.variety_id
GROUP BY s.shop_name, f.flower_name
ORDER BY flower_name, total_purchases;

Самый продаваемый цветок:

SELECT f.flower_name, SUM(fp.quantity_in_purchase) AS total_purchases
FROM flowers f
JOIN flowers_in_purchases fp ON f.variety_id = fp.variety_id
JOIN purchases p ON fp.purchase_id = p.purchases_id
GROUP BY f.flower_name
ORDER BY total_purchases DESC
LIMIT 1;

Магазины,закупающие цветы только у одного поставщика:

SELECT s.shop_name, COUNT(DISTINCT d.provider_id) AS unique_providers_count
FROM shops s
JOIN delivery d ON s.shop_id = d.shop_id
GROUP BY s.shop_name
HAVING COUNT(DISTINCT d.provider_id) = 1
ORDER BY s.shop_name;

Магазины с самым большим разнообразием цветов:

SELECT s.shop_name, COUNT(DISTINCT f.variety_id) AS flower_variety
FROM shops s
JOIN flowers_in_shops fs ON s.shop_id = fs.shop_id
JOIN flowers f ON fs.variety_id = f.variety_id
GROUP BY s.shop_name
ORDER BY flower_variety DESC;

Суммарная выручка магазинов, аренда которых составляет более 2500:

SELECT s.shop_name, SUM(p.total) AS total_revenue
FROM shops s
JOIN purchases p ON s.shop_id = p.shop_id
WHERE s.rental_cost > 2500
GROUP BY s.shop_name;

Топ 5 самых популярных поставщиков по количеству поставок:

SELECT provider_id, COUNT(delivery_id) AS total_deliveries
FROM delivery
GROUP BY provider_id
ORDER BY total_deliveries DESC
LIMIT 5;


Магазины, продающие больше цветов, чем среднее количество продаж:

SELECT s.shop_name, COUNT(p.purchases_id) AS total_purchases
FROM shops s
JOIN purchases p ON s.shop_id = p.shop_id
GROUP BY s.shop_name
HAVING COUNT(p.purchases_id) > (SELECT AVG(total_purchases) FROM (SELECT s.shop_id, COUNT(p.purchases_id) AS total_purchases FROM shops s JOIN purchases p ON s.shop_id = p.shop_id GROUP BY s.shop_id) AS avg_purchases);

Средняя стоимость покупки в каждом магазине:

SELECT s.shop_name, AVG(p.total) AS avg_purchase_cost
FROM shops s
JOIN purchases p ON s.shop_id = p.shop_id
GROUP BY s.shop_name
ORDER BY avg_purchase_cost;

Магазины, у которых самый высокий средний процент прибыли:

SELECT s.shop_name, AVG(ss.profit / ss.turnover * 100) AS profit_percentage
FROM shops_financial_statistics ss
JOIN shops s ON ss.shop_id = s.shop_id
GROUP BY s.shop_name
ORDER BY profit_percentage DESC;



