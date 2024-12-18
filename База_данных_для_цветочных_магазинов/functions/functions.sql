Функция для подсчета прибыли магазина:

CREATE OR REPLACE FUNCTION Calculate_Shop_Profit(
    IN shop_id INT,
    IN start_date DATE,
    IN end_date DATE,
    OUT total_profit DECIMAL(10,2)
) AS
$$
BEGIN
    SELECT SUM(profit)
    INTO total_profit
    FROM shops_financial_statistics
    WHERE shop_id = shop_id
    AND start_dttm >= start_date
    AND end_dttm <= end_date;
END;

$$ LANGUAGE plpgsql;

Функция, возвращающая id поставщика по id доставки:

CREATE FUNCTION GetDeliveryProvider(delivery_id INT) RETURNS VARCHAR(128) AS
$$
BEGIN
    RETURN CASE
        WHEN delivery_id = delivery.delivery_id THEN
            (SELECT provider_name FROM providers WHERE provider_id = delivery.provider_id)
        ELSE 'Provider not found'
    END;
END;

$$ LANGUAGE plpgsql;


Функция,возвращающая таблицу с информацией о поставщике:

CREATE OR REPLACE FUNCTION GetProviderInfo(provider_id INT) RETURNS TABLE (
    provider_name VARCHAR(64),
    provider_address VARCHAR(128),
    provider_number INT
) AS
$$
BEGIN
    RETURN QUERY
    SELECT
        CASE
            WHEN provider_id = providers.provider_id THEN providers.provider_name
            ELSE 'Provider not found'
        END AS provider_name,
        CASE
            WHEN provider_id = providers.provider_id THEN providers.provider_address
            ELSE 'Provider not found'
        END AS provider_address,
        CASE
            WHEN provider_id = providers.provider_id THEN providers.provider_number
            ELSE NULL
        END AS provider_number
    FROM providers;
END;

$$ LANGUAGE plpgsql;
