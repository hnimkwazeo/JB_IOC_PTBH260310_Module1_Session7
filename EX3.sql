create table Customer (
	id serial primary key,
	name varchar(100),
	email varchar(100),
	phone varchar(20),
	points int
);

insert into customer(name,email,phone,points) values 
('Vũ Nhật Minh', 'minh@gmail.com', '0365247139', 20),
('Vũ Quang Dương', 'duong@gmail.com', '0345679866', 30),
('Vũ Huy Chuộng', 'chuong@gmail.com', '0312345678', 120),
('Dương Thị Tám', 'tam@gmail.com', '0904339998', 200),
('Vũ Huy Toàn', 'toan@gmail.com', '0587780683', 330),
('Vũ Thị Huyền', 'huyen@gmail.com', '0226578789', 550),
('Vũ Thị Huyền', null , '0365247139', 10);

--Y1
select distinct name
from customer;

--Y2:
select * from customer
where email is null;

--Y3:
select * from customer
order by points desc
offset 1 limit 3;

--Y4:
select * from customer
order by name desc;