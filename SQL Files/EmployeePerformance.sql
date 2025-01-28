SELECT e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS EmployeeName,
    COUNT(o.order_id) AS TotalOrders,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS TotalSales
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY TotalSales DESC;
