create table Course (
	id serial primary key,
	title varchar(100),
	instructor varchar(50),
	price numeric(10,2),
	duration int 
);

--Y1:
insert into course(title,instructor,price,duration) values
('Cơ sở dữ liệu', 'Nguyễn Trọng Khánh', 4000000.00, 75),
('Cấu trúc dữ liệu và giải thuật', 'Nguyễn Duy Phương', 4500000.00, 80),
('Kĩ năng tạo lập văn bản bằng Tiếng Việt', 'Trần Ngọc Mai', 850000.00, 15),
('Tư tưởng Hồ Chí Minh', 'Trần Thị Hồng Hạnh', 1600000.00, 30),
('SQL injection', 'Nguyện Ngọc Hà', 2100000.00, 75),
('T-Sql', 'Nguyễn Trọng Khánh', 3000000.00, 75),
('Demo lập trình web', 'Dương Trần Đức', 2100000.00, 45);

--Y2:
update course set price = price + price * 0.15 where duration > 30;

--Y3:
delete from course
where title like '%Demo%';

--Y4:
select * from course 
where title ilike '%sql&';

--Y5:
select * from course 
where price between 500000 and 2000000
order by price desc;