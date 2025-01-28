SELECT country, city,
       COUNT(customer_id) AS total_customers
FROM customers
GROUP BY country, city
ORDER BY total_customers DESC;
