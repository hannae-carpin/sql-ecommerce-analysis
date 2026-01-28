/* ANALYSE 4 : Performance Logistique par État
Objectif : Comparer les délais de livraison réels vs estimés et le coût du fret.
Fonction clé : julianday() pour calculer la différence en jours entre deux dates.
*/

SELECT
    c.customer_state as etat,
    COUNT(DISTINCT o.order_id) as nombre_commandes,
    ROUND(AVG(julianday(o.order_delivered_customer_date) - julianday(o.order_purchase_timestamp)), 2) as delai_reel_moyen,
    ROUND(AVG(julianday(o.order_estimated_delivery_date) - julianday(o.order_delivered_customer_date)), 2) as jours_avance_moyen,
    ROUND(AVG(oi.freight_value), 2) as cout_fret_moyen
FROM
    orders o
JOIN
    customers c ON o.customer_id = c.customer_id
JOIN
    order_items oi ON o.order_id = oi.order_id
WHERE
    o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
GROUP BY
    c.customer_state
HAVING 
    nombre_commandes > 100
ORDER BY
    3 DESC;