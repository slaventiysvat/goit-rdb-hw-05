-- ============================================================
-- HW5 — Підзапити та функції (Northwind)
-- ============================================================

USE northwind;

-- ============================================================
-- Завдання 1
-- Відобразити всі поля order_details та customer_id з orders
-- для кожного запису order_details — підзапит у SELECT
-- ============================================================

SELECT
    od.*,
    (SELECT o.customer_id
     FROM orders o
     WHERE o.id = od.order_id) AS customer_id
FROM order_details od;

-- ============================================================
-- Завдання 2
-- Відобразити order_details, де відповідний запис orders
-- має shipper_id = 3 — підзапит у WHERE
-- ============================================================

SELECT *
FROM order_details od
WHERE od.order_id IN (
    SELECT o.id
    FROM orders o
    WHERE o.shipper_id = 3
);

-- ============================================================
-- Завдання 3
-- Підзапит у FROM: вибрати рядки quantity > 10 з order_details,
-- потім знайти середнє quantity, групуючи за order_id
-- ============================================================

SELECT
    t.order_id,
    AVG(t.quantity) AS avg_quantity
FROM (
    SELECT order_id, quantity
    FROM order_details
    WHERE quantity > 10
) AS t
GROUP BY t.order_id;

-- ============================================================
-- Завдання 4
-- Те саме через WITH (CTE)
-- ============================================================

WITH temp AS (
    SELECT order_id, quantity
    FROM order_details
    WHERE quantity > 10
)
SELECT
    order_id,
    AVG(quantity) AS avg_quantity
FROM temp
GROUP BY order_id;

-- ============================================================
-- Завдання 5
-- Функція divide_float(a FLOAT, b FLOAT) -> FLOAT
-- Ділить перший параметр на другий
-- Застосована до quantity з order_details (ділимо на 3)
-- ============================================================

DROP FUNCTION IF EXISTS divide_float;

DELIMITER //
CREATE FUNCTION divide_float(a FLOAT, b FLOAT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    RETURN a / b;
END //
DELIMITER ;

SELECT
    id,
    order_id,
    product_id,
    quantity,
    divide_float(quantity, 3) AS quantity_divided
FROM order_details;
