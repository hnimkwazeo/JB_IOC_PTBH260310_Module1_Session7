create table orders(
	id serial primary key,
	customer_id int,
	order_date date,
	total_amount numeric(10,2)
);

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2022-12-20', 200.00),
(2, '2023-01-10', 1200.50),
(1, '2023-03-15', 3200.00),
(3, '2023-07-01', 5000.00),
(4, '2024-01-10', 750.75),
(5, '2024-02-15', 9800.00),
(2, '2024-03-01', 450.00),
(6, '2024-03-05', 50.00),
(7, '2025-02-02', 25.00);

--Y1:
select sum(total_amount) as "total_revenue", count(id) as "total_orders", avg(total_amount) as "average_order_value"
from orders;

--Y2:
select extract(year from order_date) as "Year", sum(total_amount) as "total_revenue"
from orders
group by extract(year from order_date)
order by extract(year from order_date) asc;

--Y3:
select extract(year from order_date) as "Year", sum(total_amount) as "total_revenue"
from orders
group by extract(year from order_date)
having  sum(total_amount) > 50
order by extract(year from order_date) asc;

--Y4:
select * 
from orders
order by total_amount desc limit 5;