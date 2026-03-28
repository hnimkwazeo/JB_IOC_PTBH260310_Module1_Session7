create table book (
	book_id serial primary key,
	title varchar(255),
	author varchar(100),
	genre varchar(50),
	price decimal(10,2),
	description text,
	created_at timestamp default current_timestamp
);

select * from book;
--Ý1:
CREATE EXTENSION IF NOT EXISTS pg_trgm;
create index idx_book_author on book using gin(author gin_trgm_ops);

create index idx_book_genre on book(genre);

--Ý2:
explain analyze select * from book where author ilike '%Rowling%';
explain analyze select * from book where genre = 'Fantasy';

/*Ý3: 
	Sau khi đặt chỉ mục (index) thì thời gian truy vấn được tối ưu, 
	nhanh hơn nhiều khi chưa đặt chỉ mục. Giống ảnh minh họa.
*/

--Ý4:
cluster book using idx_book_genre;
/*
	Sau khi sử dụng lệnh cluster thì thời gian truy vấn đã giảm 
	-> Hiệu suất (Performance cao)
*/

--Ý5:

/*
	- B-tree hiệu quả nhất cho các phép so sánh bằng (=) và tìm kiếm theo dải (<, >, BETWEEN).
	- GIN là lựa chọn hàng đầu cho dữ liệu mảng, JSONB và tìm kiếm toàn văn (full-text search).
	- GiST tối ưu cho dữ liệu hình học và tìm kiếm tương đồng; BRIN dành cho bảng dữ liệu khổng lồ sắp xếp theo thời gian.
	- Hash index không được khuyến khích khi truy vấn yêu cầu lọc theo dải hoặc sắp xếp dữ liệu (ORDER BY).
	- Do chỉ hỗ trợ duy nhất toán tử =, Hash index thiếu tính linh hoạt và thường bị thay thế bởi B-tree trong hầu hết ứng dụng.
*/
