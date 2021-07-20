
-- 0. Get all the users
SELECT * FROM customers;


--## Tasks
--1. Get all customers and their addresses.
SELECT CONCAT(customers.first_name, ' ', customers.last_name) AS customer_name,
	   CONCAT(addresses.street, ', ', addresses.city, ', ', addresses.state, ' ', addresses.zip) AS customer_address
FROM customers
JOIN addresses ON addresses.customer_id = customers.id
ORDER BY customer_name;
--2. Get all orders and their line items (orders, quantity and product).
SELECT orders.id, orders.order_date, line_items.quantity, products.description, products.unit_price FROM line_items
JOIN orders ON line_items.order_id = orders.id
JOIN products ON products.id = line_items.product_id
ORDER BY orders.id;
--3. Which warehouses have cheetos?
SELECT products.description, warehouse.warehouse FROM products
JOIN warehouse_product ON warehouse_product.product_id = products.id
JOIN warehouse ON warehouse.id = warehouse_product.warehouse_id
WHERE products.description = 'cheetos';
--4. Which warehouses have diet pepsi?
SELECT products.description, warehouse.warehouse FROM products
JOIN warehouse_product ON warehouse_product.product_id = products.id
JOIN warehouse ON warehouse.id = warehouse_product.warehouse_id
WHERE products.description = 'diet pepsi';
--5. Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.
SELECT CONCAT(customers.first_name, ' ', customers.last_name) AS customer_name, count(orders) FROM customers
JOIN addresses ON addresses.customer_id = customers.id
JOIN orders ON addresses.id = orders.address_id
GROUP BY customer_name;
--6. How many customers do we have?
SELECT count(*) FROM customers;
--7. How many products do we carry?
SELECT count(*) FROM products;
--8. What is the total available on-hand quantity of diet pepsi?
SELECT sum(on_hand) AS diet_pepsi_count FROM warehouse_product
JOIN products ON products.id = warehouse_product.product_id
WHERE products.description = 'diet pepsi';


--## Stretch
--9. How much was the total cost for each order?
SELECT SUM(products.unit_price*line_items.quantity) AS total_cost, orders.id FROM line_items
JOIN products ON products.id = line_items.product_id
JOIN orders ON orders.id = line_items.order_id
GROUP BY orders.id
ORDER BY orders.id;
--10. How much has each customer spent in total?
SELECT SUM(products.unit_price*line_items.quantity) AS total_cost, customers.last_name, customers.first_name
FROM line_items
JOIN products ON products.id = line_items.product_id
JOIN orders ON orders.id = line_items.order_id
JOIN addresses ON addresses.id = orders.address_id
JOIN customers ON customers.id = addresses.customer_id
GROUP BY customers.last_name, customers.first_name;
--11. How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).


