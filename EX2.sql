create table Employee (
	id serial primary key,
	full_name varchar(100),
	department varchar(50),
	salary numeric(10,2),
	hire_date date
);

--Y1:
insert into employee(full_name,department,salary,hire_date) values
('Vũ Nhật Minh', 'IT', 10000000.00, '2026-03-10'),
('Dương Thị Tám', 'Khoa học tự nhiên', 30000000.00, '1997-03-20'),
('Vũ Huy Chuộng', 'Khoa học xã hội', 50000000.00, '1990-09-01'),
('Vũ Quang Dương', 'IT', 40000000.00, '2021-09-03'),
('Vũ Huy Toàn', 'Kinh tế', 80000000.00, '2013-11-25'),
('Điều Thị Thanh Huyền', 'Khoa học tự nhiên', 50000000.00, '2018-09-20'),
('Trần Thị Hải An', 'Kinh tế', 5000000.22, '2026-03-23'),
('NguyỄn qUốc aN', 'IT', 50000000.00, '2026-03-10');

--Y2:
update employee set salary = salary + 0.1 * salary where department = 'IT';

--Y3:
delete from employee
where salary < 6000000;

--Y4:
select * from employee
where full_name ilike '%an';

--Y5: 
select full_name
from employee
where hire_date between '2023-01-01' and '2023-12-31';

