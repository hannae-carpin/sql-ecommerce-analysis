/* ANALYSE 2 : Identification des Clients VIP
Objectif : Trouver les clients qui génèrent le plus de chiffre d'affaires.
*/

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) as frequence_commandes,
    ROUND(SUM(p.payment_value), 2) as montant_total,
    MAX(o.order_purchase_timestamp) as date_derniere_commande,
    MAX(c.customer_city) as ville
FROM
    customers c
JOIN
    orders o ON c.customer_id = o.customer_id
JOIN
    order_payments p ON o.order_id = p.order_id
WHERE
    o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY
    c.customer_unique_id
ORDER BY
    montant_total DESC
LIMIT 10;