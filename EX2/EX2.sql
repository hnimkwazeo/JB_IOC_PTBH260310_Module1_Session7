create table customer (
	customer_id serial primary key,
	full_name varchar(100),
	email varchar(100),
	phone varchar(15)
);

create table orders (
	order_id serial primary key,
	customer_id int references customer(customer_id),
	total_amount decimal(10,2),
	order_date date
);

insert into customer (full_name, email, phone) values
('Nguyen Van An', 'an.nguyen@gmail.com', '0912345678'),
('Tran Thi Bich', 'bich.tran@yahoo.com', '0987654321'),
('Le Hoang Nam', 'nam.le@outlook.com', '0909123456'),
('Pham Thi Hoa', 'hoa.pham@gmail.com', '0933555777'),
('Do Minh Tuan', 'tuan.do@gmail.com', '0977888999'),
('Hoang Lan Anh', 'lananh.hoang@yahoo.com', '0922333444'),
('Vu Quang Huy', 'huy.vu@gmail.com', '0966667777'),
('Dang Thi Mai', 'mai.dang@outlook.com', '0944445555'),
('Bui Thanh Son', 'son.bui@gmail.com', '0955556666'),
('Phan Ngoc Linh', 'linh.phan@yahoo.com', '0911222333');


insert into orders (customer_id, total_amount, order_date) values
(1, 250000.00, '2024-01-10'),
(2, 1250000.50, '2024-02-15'),
(1, 780000.00, '2024-03-05'),
(3, 320000.75, '2024-01-20'),
(4, 150000.00, '2024-04-01'),
(5, 2200000.00, '2024-02-28'),
(6, 99000.99, '2024-03-18'),
(7, 450000.00, '2024-01-25'),
(8, 870000.00, '2024-04-10'),
(2, 660000.00, '2024-03-30');

--Y1:
create materialized view v_order_summary as
select 
	c.full_name,
	o.total_amount,
	o.order_date
from 
	customer as c
join 
	orders as o
on 
	c.customer_id = o.customer_id;

--Y2:
select * from v_order_summary;

--Y3:
create view v_order_total_amount_larger_than_one_million as
select 
	order_id,
	total_amount
from
	orders
where
	total_amount >= 1000000;

--Y4:
create view v_monthly_sales as 
select
	extract (month from order_date) as month,
	sum(total_amount)
from 
	orders
group by extract (month from order_date)
order by sum(total_amount) asc;

--Y5
drop view v_order_summary;

drop materialized view v_order_summary;