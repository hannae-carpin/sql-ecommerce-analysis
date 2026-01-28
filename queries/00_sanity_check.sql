/* SANITY CHECK
Objectif : Vérifier que les tables principales contiennent bien des données et observer la plage temporelle des commandes.
*/

SELECT 'Orders' as table_name, COUNT(*) as total FROM orders
UNION ALL
SELECT 'Customers', COUNT(*) FROM customers
UNION ALL
SELECT 'Products', COUNT(*) FROM products;

SELECT 
    MIN(order_purchase_timestamp) as premiere_commande,
    MAX(order_purchase_timestamp) as derniere_commande
FROM orders;

SELECT 
    order_status, 
    COUNT(*) as nombre
FROM orders
GROUP BY order_status
ORDER BY nombre DESC;