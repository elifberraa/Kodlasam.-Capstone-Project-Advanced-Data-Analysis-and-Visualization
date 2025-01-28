SELECT p.category_id, c.category_name, 
	ROUND(SUM(od.quantity * od.unit_price)::numeric, 2) AS TotalSales
FROM order_details od
JOIN products p ON od.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY p.category_id, c.category_name;