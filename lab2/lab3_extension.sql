SELECT COUNT(*) FROM user_sessions;
SELECT * FROM user_sessions LIMIT 5;
select count (*) as total_orders from orders;
select count(shipped_date) as shipped_orders from orders;
select sum(total_amount) as total_revenue from orders;
select avg(total_amount) as avg_amount from orders;
SELECT COUNT(*) AS total_orders,
SUM(total_amount) AS total_revenue,
AVG(total_amount) AS avg_order_value,
MIN(total_amount) AS smallest_order,
MAX(total_amount) AS largest_order
FROM orders
WHERE status = 'delivered';
SELECT status,
COUNT(*) AS num_orders,
SUM(total_amount) AS total_revenue
FROM orders
GROUP BY status
ORDER BY total_revenue DESC;
SELECT status,
COUNT(*) AS num_orders,
SUM(total_amount) AS total_revenue
FROM orders
WHERE order_date >= '2025-01-01' -- filter rows first
GROUP BY status
HAVING COUNT(*) > 3 -- then filter groups
ORDER BY total_revenue DESC;
SELECT category,
COUNT(*) AS products,
ROUND(AVG(price), 2) AS avg_price
FROM products
GROUP BY category
HAVING AVG(price) > 3000
ORDER BY avg_price DESC;
-- ROW_NUMBER: assign a sequential number to each row within a group
SELECT customer_id,
order_date,
total_amount,
ROW_NUMBER() OVER (
PARTITION BY customer_id
ORDER BY total_amount DESC
) AS order_rank_by_customer
FROM orders;
-- RANK: like ROW_NUMBER but ties get the same rank
-- (two orders with equal amount both get rank 1, next is rank 3)
SELECT customer_id,
total_amount,
RANK() OVER (ORDER BY total_amount DESC) AS overall_rank
FROM orders;
-- DENSE_RANK: ties get the same rank, but no gaps in numbering
-- (two at rank 1 means next is rank 2, not rank 3)
SELECT customer_id,
total_amount,
DENSE_RANK() OVER (ORDER BY total_amount DESC) AS dense_rank
FROM orders;
-- Month-over-month revenue comparison using LAG
SELECT TO_CHAR(order_date, 'YYYY-MM') AS month,
SUM(total_amount) AS revenue,
LAG(SUM(total_amount)) OVER (
ORDER BY TO_CHAR(order_date, 'YYYY-MM')
) AS prev_month_revenue
FROM orders
WHERE status = 'delivered'
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month;
WITH customer_totals AS (
SELECT customer_id,
SUM(total_amount) AS total_spent
FROM orders
WHERE status = 'delivered'
GROUP BY customer_id
)
SELECT customer_id, total_spent
FROM customer_totals
WHERE total_spent > 10000
ORDER BY total_spent DESC;
SELECT COUNT(*) AS total_orders,
SUM(total_amount) AS total_revenue,
ROUND(AVG(total_amount), 2) AS avg_order_value,
MAX(total_amount) AS largest_order
FROM orders
WHERE status = 'delivered';
SELECT p.category,
COUNT(DISTINCT oi.order_id) AS orders_containing,
SUM(oi.quantity * oi.unit_price) AS category_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;
SELECT TO_CHAR(order_date, 'YYYY-MM') AS month,
COUNT(*) AS num_orders,
SUM(total_amount) AS monthly_revenue
FROM orders
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month;
SELECT c.city,
COUNT(DISTINCT c.customer_id) AS customers,
COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city;
SELECT device,
COUNT(*) AS total_sessions,
ROUND(AVG(duration_mins), 2) AS avg_duration,
SUM(CASE WHEN converted THEN 1 ELSE 0 END) AS conversions,
ROUND(
100.0 * SUM(CASE WHEN converted THEN 1 ELSE 0 END) / COUNT(*),
1
) AS conversion_rate_pct
FROM user_sessions
GROUP BY device
HAVING COUNT(*) >= 5
AND AVG(duration_mins) > 15
ORDER BY conversion_rate_pct DESC;
SELECT customer_id,
order_id,
order_date,
total_amount,
ROW_NUMBER() OVER (
PARTITION BY customer_id
ORDER BY total_amount DESC
) AS rank_within_customer
FROM orders
ORDER BY customer_id, rank_within_customer;
SELECT order_id,
customer_id,
total_amount,
RANK() OVER (ORDER BY total_amount DESC) AS rank,
DENSE_RANK() OVER (ORDER BY total_amount DESC) AS dense_rank
FROM orders
ORDER BY total_amount DESC
LIMIT 15;
WITH monthly_revenue AS (
SELECT TO_CHAR(order_date, 'YYYY-MM') AS month,
SUM(total_amount) AS revenue
FROM orders
WHERE status = 'delivered'
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
)
SELECT month,
revenue,
LAG(revenue) OVER (ORDER BY month) AS prev_month,
revenue - LAG(revenue) OVER (ORDER BY month)
AS absolute_change,
ROUND(
100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
/ NULLIF(LAG(revenue) OVER (ORDER BY month), 0),
1
) AS pct_change
FROM monthly_revenue
ORDER BY month;
WITH customer_spend AS (
SELECT c.customer_id,
c.name,
c.city,
COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
AND o.status = 'delivered'
GROUP BY c.customer_id, c.name, c.city
),
customer_tiers AS (
SELECT *,
CASE
WHEN total_spent > 30000 THEN 'VIP'
WHEN total_spent > 10000 THEN 'High Value'
WHEN total_spent > 0 THEN 'Active'
ELSE 'Never Purchased'
END AS tier
FROM customer_spend
)
SELECT tier,
COUNT(*) AS num_customers,
ROUND(SUM(total_spent), 2) AS tier_revenue,
ROUND(
100.0 * SUM(total_spent)
/ NULLIF(SUM(SUM(total_spent)) OVER (), 0),
1
) AS revenue_share_pct
FROM customer_tiers
GROUP BY tier
ORDER BY tier_revenue DESC;
WITH session_summary AS (
SELECT customer_id,
COUNT(*) AS total_sessions,
SUM(pages_viewed) AS total_pages,
ROUND(AVG(duration_mins), 2) AS avg_duration,
SUM(CASE WHEN converted THEN 1 ELSE 0 END) AS converted_sessions
FROM user_sessions
GROUP BY customer_id
),
order_summary AS (
SELECT customer_id,
COUNT(*) AS total_orders,
SUM(total_amount) AS total_spent
FROM orders
WHERE status = 'delivered'
GROUP BY customer_id
),
combined AS (
SELECT c.name,
c.city,
s.total_sessions,
s.total_pages,
s.avg_duration,
s.converted_sessions,
COALESCE(o.total_orders, 0) AS total_orders,
COALESCE(o.total_spent, 0) AS total_spent
FROM session_summary s
JOIN customers c ON s.customer_id = c.customer_id
LEFT JOIN order_summary o ON s.customer_id = o.customer_id
)
SELECT name,
city,
total_sessions,
total_pages,
avg_duration,
total_orders,
total_spent,
ROUND(
CASE WHEN total_sessions > 0
THEN 100.0 * total_orders / total_sessions
ELSE 0
END, 1
) AS orders_per_100_sessions
FROM combined
ORDER BY total_sessions DESC, orders_per_100_sessions ASC;

