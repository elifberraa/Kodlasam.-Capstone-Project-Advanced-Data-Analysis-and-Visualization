SELECT s.supplier_id,
       s.company_name,
       COUNT(o.order_id) AS total_orders,
       ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS total_sales,
       ROUND(AVG(o.shipped_date - o.order_date), 0) AS avg_delivery_time
FROM suppliers s
JOIN products p ON s.supplier_id = p.supplier_id
JOIN order_details od ON od.product_id = p.product_id
JOIN orders o ON od.order_id = o.order_id
WHERE o.shipped_date IS NOT NULL
GROUP BY s.supplier_id, s.company_name
ORDER BY total_sales DESC;
