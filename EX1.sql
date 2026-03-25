create table Product (
	id serial primary key,
	name varchar(100),
	category varchar(50),
	price numeric(10,2),
	stock int
);

--Y1:
insert into product(name,category,price,stock) values
('Kim Cương', 'Trang sức', 32000000.00, 30),
('Iphone 17', 'Điện tử', 30000000.00, 10),
('Laptop', 'Điện tử', 9000000.86, 100),
('Thùng rác', 'Đồ gia dụng', 50000.60, 70),
('Cánh gà', 'Thực phẩm', 25000.75, 200);

--Y2:
select * from product;

--Y3:
select * from product
order by price desc
limit 3;

--Y4:
select * from product
where category = 'Điện tử' and price < 10000000;

--Y5:
select * from product
order by stock;