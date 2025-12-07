-- 1. Basic retrieval (SELECT *)
SELECT 'Staff (5 rows):' as table_name FROM dual;
SELECT * FROM staff WHERE ROWNUM <= 5;

SELECT 'Products (5 rows):' as table_name FROM dual;
SELECT * FROM products WHERE ROWNUM <= 5;

SELECT 'Alerts (5 rows):' as table_name FROM dual;
SELECT * FROM alerts WHERE ROWNUM <= 5;

-- 2. Joins 
SELECT 'Alerts with Product & Staff Details (5 rows):' as query FROM dual;
SELECT 
    a.alert_id,
    p.product_name,
    p.category,
    a.alert_type,
    a.status,
    s.name as assigned_staff
FROM alerts a
JOIN products p ON a.product_id = p.product_id
LEFT JOIN staff s ON a.assigned_to = s.staff_id
WHERE ROWNUM <= 5;

-- 3. Aggregations (GROUP BY) - ACTUAL from output
SELECT 'Products by Category Analysis:' as query FROM dual;
SELECT 
    category,
    COUNT(*) as product_count,
    SUM(stock_qty) as total_stock,
    ROUND(AVG(unit_price), 2) as avg_price,
    SUM(CASE WHEN status = 'CRITICAL' THEN 1 ELSE 0 END) as critical,
    SUM(CASE WHEN status = 'NEAR_EXPIRY' THEN 1 ELSE 0 END) as near_expiry
FROM products
GROUP BY category
ORDER BY product_count DESC;

-- 4. Subqueries - ACTUAL from output
SELECT 'Product Statistics with Counts (5 rows):' as query FROM dual;
SELECT 
    p.product_name,
    p.category,
    (SELECT COUNT(*) FROM alerts WHERE product_id = p.product_id) as alert_count,
    (SELECT COUNT(*) FROM sales WHERE product_id = p.product_id) as sale_count,
    (SELECT COUNT(*) FROM action_log WHERE product_id = p.product_id) as log_count
FROM products p
WHERE ROWNUM <= 5;