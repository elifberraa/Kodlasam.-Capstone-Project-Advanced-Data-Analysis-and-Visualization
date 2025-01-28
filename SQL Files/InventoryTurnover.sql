SELECT p.product_id, p.product_name,
	(SUM(p.unit_in_stock) + SUM(od.quantity)) AS TotalStock,
    SUM(od.quantity) AS TotalQuantitySold,
    ROUND(SUM(od.quantity) / (SUM(p.unit_in_stock) + SUM(od.quantity))::numeric, 2) AS InventoryTurnover
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name, p.unit_in_stock
ORDER BY InventoryTurnover DESC;
