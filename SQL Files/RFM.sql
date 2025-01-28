--RFM
--Recency
SELECT MAX(order_date) AS last_order_date FROM orders;
--"1998-05-06"
SELECT customer_id,
    EXTRACT(DAY FROM AGE('1998-05-06', MAX(order_date))) AS recency
FROM orders
WHERE customer_id IS NOT NULL
GROUP BY customer_id;

--Frequency
SELECT customer_id,
    COUNT(DISTINCT order_id) AS frequency
FROM orders
WHERE customer_id IS NOT NULL
GROUP BY customer_id;

--Monetary
SELECT o.customer_id,
    ROUND((SUM(od.unit_price * od.quantity * (1 - od.discount)))::numeric, 2) AS monetary
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
WHERE o.customer_id IS NOT NULL
GROUP BY o.customer_id;

--Complete RFM Table
SELECT o.customer_id,
    EXTRACT(DAY FROM AGE('1998-05-06', MAX(o.order_date))) AS recency,
    COUNT(DISTINCT o.order_id) AS frequency,
    ROUND((SUM(od.unit_price * od.quantity * (1 - od.discount)))::numeric, 2) AS monetary
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
WHERE o.customer_id IS NOT NULL
GROUP BY o.customer_id;

--Assigning RFM Scores
SELECT o.customer_id,
    EXTRACT(DAY FROM AGE('1998-05-06', MAX(o.order_date))) AS recency,
    COUNT(DISTINCT o.order_id) AS frequency,
    ROUND((SUM(od.unit_price * od.quantity * (1 - od.discount)))::numeric, 2) AS monetary,
    NTILE(5) OVER (ORDER BY EXTRACT(DAY FROM AGE('1998-05-06', MAX(o.order_date))) ASC) AS recency_score,
    NTILE(5) OVER (ORDER BY COUNT(DISTINCT o.order_id) DESC) AS frequency_score,
    NTILE(5) OVER (ORDER BY ROUND((SUM(od.unit_price * od.quantity * (1 - od.discount)))::numeric, 2) DESC) AS monetary_score
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
WHERE o.customer_id IS NOT NULL
GROUP BY o.customer_id;

--Combined RFM Score	
SELECT customer_id, recency, frequency, monetary, recency_score, frequency_score, monetary_score,
    CONCAT(recency_score, frequency_score, monetary_score) AS rfm_score
FROM (
    SELECT o.customer_id,
		EXTRACT(DAY FROM AGE('1998-05-06', MAX(o.order_date))) AS recency,
		COUNT(DISTINCT o.order_id) AS frequency,
		ROUND((SUM(od.unit_price * od.quantity * (1 - od.discount)))::numeric, 2) AS monetary,
		NTILE(5) OVER (ORDER BY EXTRACT(DAY FROM AGE('1998-05-06', MAX(o.order_date))) ASC) AS recency_score,
		NTILE(5) OVER (ORDER BY COUNT(DISTINCT o.order_id) DESC) AS frequency_score,
		NTILE(5) OVER (ORDER BY ROUND((SUM(od.unit_price * od.quantity * (1 - od.discount)))::numeric, 2) DESC) AS monetary_score
	FROM orders o
	JOIN order_details od ON o.order_id = od.order_id
	WHERE o.customer_id IS NOT NULL
	GROUP BY o.customer_id
) AS rfm_scored;

--Customer Segmentation
SELECT customer_id, recency, frequency, monetary, recency_score, frequency_score, monetary_score,
    CONCAT(recency_score, frequency_score, monetary_score) AS rfm_score,
	CASE
        WHEN recency_score = 5 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Champions'
        WHEN recency_score >= 4 AND frequency_score >= 3 THEN 'Loyal Customers'
        WHEN frequency_score <= 2 AND monetary_score < 3 THEN 'At Risk'
        ELSE 'General Customers'
    END AS customer_segment
FROM (
    SELECT o.customer_id,
		EXTRACT(DAY FROM AGE('1998-05-06', MAX(o.order_date))) AS recency,
		COUNT(DISTINCT o.order_id) AS frequency,
		ROUND((SUM(od.unit_price * od.quantity * (1 - od.discount)))::numeric, 2) AS monetary,
		NTILE(5) OVER (ORDER BY EXTRACT(DAY FROM AGE('1998-05-06', MAX(o.order_date))) ASC) AS recency_score,
		NTILE(5) OVER (ORDER BY COUNT(DISTINCT o.order_id) DESC) AS frequency_score,
		NTILE(5) OVER (ORDER BY ROUND((SUM(od.unit_price * od.quantity * (1 - od.discount)))::numeric, 2) DESC) AS monetary_score
	FROM orders o
	JOIN order_details od ON o.order_id = od.order_id
	WHERE o.customer_id IS NOT NULL
	GROUP BY o.customer_id
) AS rfm_scored;