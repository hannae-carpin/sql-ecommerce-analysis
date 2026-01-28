/* ANALYSE 3 : Rétention par Cohorte (Cohort Analysis)
Objectif : Voir le pourcentage de clients qui reviennent acheter après leur premier mois.
Technique : CTEs (Common Table Expressions) + Self-Join
*/

WITH first_purchase AS (
    SELECT 
        customer_unique_id,
        MIN(strftime('%Y-%m', order_purchase_timestamp)) as cohort_month
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY customer_unique_id
),

user_activities AS (
    SELECT DISTINCT
        c.customer_unique_id,
        strftime('%Y-%m', o.order_purchase_timestamp) as activity_month
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
),

cohort_size AS (
    SELECT 
        cohort_month,
        COUNT(DISTINCT customer_unique_id) as num_users
    FROM first_purchase
    GROUP BY cohort_month
),

retention_table AS (
    SELECT
        fp.cohort_month,
        ua.activity_month,
        COUNT(DISTINCT fp.customer_unique_id) as num_active_users
    FROM first_purchase fp
    JOIN user_activities ua ON fp.customer_unique_id = ua.customer_unique_id
    WHERE ua.activity_month >= fp.cohort_month 
    GROUP BY fp.cohort_month, ua.activity_month
)

SELECT
    r.cohort_month, 
    r.activity_month, 
    
    (
      (strftime('%Y', r.activity_month) - strftime('%Y', r.cohort_month)) * 12 +
      (strftime('%m', r.activity_month) - strftime('%m', r.cohort_month))
    ) as month_number,
    r.num_active_users,
    cs.num_users as cohort_total_users,
    
    ROUND(CAST(r.num_active_users AS FLOAT) / cs.num_users * 100, 2) as retention_rate_percent
FROM retention_table r
JOIN cohort_size cs ON r.cohort_month = cs.cohort_month
WHERE r.cohort_month BETWEEN '2017-01' AND '2017-12' -- On se concentre sur l'année 2017
ORDER BY r.cohort_month, month_number;