create table OrderInfo (
	id serial primary key,
	customer_id int,
	order_date date,
	total numeric(10,2),
	status varchar(20)
);

--Y1:
insert into orderinfo(customer_id,order_date,total,status) values
(2, '2005-03-05', 10000.56, 'Completed'),
(1, '2006-05-05', 20000000.00, 'Completed'),
(101, '2026-03-23', 50000.54, 'Pending'),
(3, '2026-03-22', 55000.00, 'Cancel'),
(110, '2025-12-07', 345000.89, 'Completed');

--Y2:
select * from orderinfo
where total > 500000;

--Y3:
select * from orderinfo
where order_date between '2024-10-01' and '2024-10-31';

--Y4:
select * from orderinfo
where status <> 'Completed';

--Y5:
select * from orderinfo
order by order_date desc limit 2;