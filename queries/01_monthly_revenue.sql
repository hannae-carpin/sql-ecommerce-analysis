/* ANALYSE 1 : Évolution du CA mensuel (Monthly Revenue)
Objectif : Identifier la saisonnalité et la tendance de croissance.
Tables : orders (o), order_payments (p)
*/

SELECT
    strftime('%Y-%m', o.order_purchase_timestamp) as mois,
    COUNT(DISTINCT o.order_id) as nombre_commandes,
    ROUND(SUM(p.payment_value), 2) as chiffre_affaires
FROM
    orders o
JOIN
    order_payments p ON o.order_id = p.order_id
WHERE
    o.order_status NOT IN ('canceled', 'unavailable')
    AND o.order_purchase_timestamp IS NOT NULL
GROUP BY
    mois
ORDER BY
    mois;