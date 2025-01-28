SELECT 
    CASE 
        WHEN od.discount > 0 THEN 'Discounted' 
        ELSE 'Non-Discounted' 
    END AS DiscountType,
    COUNT(DISTINCT o.order_id) AS TotalOrders,
    SUM(od.quantity) AS TotalQuantity,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS TotalSales,
    ROUND(AVG(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS AvgSalesPerOrder
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
GROUP BY DiscountType;
