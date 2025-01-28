SELECT 
    EXTRACT(YEAR FROM orders.order_date) AS SalesYear,
    EXTRACT(MONTH FROM orders.order_date) AS SalesMonth,
    ROUND(SUM(order_details.quantity * order_details.unit_price)::numeric, 2) AS TotalSales
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
GROUP BY SalesYear, SalesMonth
ORDER BY SalesYear, SalesMonth;
