
create table post (
	post_id serial primary key,
	user_id int not null,
	content text,
	tags text[],
	created_at timestamp default current_timestamp,
	is_public boolean default true
);

create table post_like (
	user_id int not null,
	post_id int not null,
	liked_at timestamp default current_timestamp,
	primary key (user_id, post_id)
);

--Y1: Tối ưu hóa truy vấn tìm kiếm bài đăng công khai theo từ khóa:
/*
	Tạo Expression Index sử dụng LOWER(content) để tăng tốc tìm kiếm
	So sánh hiệu suất trước và sau khi tạo chỉ mục
*/
CREATE EXTENSION IF NOT EXISTS pg_trgm;
create index idx_post_lower_content_trgm_public 
on post 
using gin (content gin_trgm_ops)
where is_public = true;

explain analyze select * from post
where is_public = true and content ilike '%du lịch%';

-- [Trước khi tạo Index]:
-- Với điều kiện lọc chứa mẫu '%...%' ở cả hai đầu, PostgreSQL bắt buộc phải 
-- thực hiện "Seq Scan" (Quét toàn bộ bảng) và dùng hàm LOWER() trên từng dòng 
-- dữ liệu để so khớp. Chi phí (Cost) tăng tuyến tính theo số lượng bản ghi.

-- [Sau khi tạo Index (idx_post_lower_content_trgm_public)]:
-- Hệ thống đã chuyển sang "Bitmap Index Scan" kết hợp với "Bitmap Heap Scan".
-- GIN Index phân rã chuỗi text thành các cụm 3 ký tự (Trigram), giúp định vị 
-- chính xác vị trí các dòng có chứa từ 'du lịch' mà không cần quét toàn bộ bảng, 
-- giúp tốc độ tìm kiếm văn bản tăng lên gấp nhiều lần.

--Y2: Tối ưu hóa truy vấn lọc bài đăng theo thẻ (tags):
/*
	Tạo GIN Index cho cột tags
	Phân tích hiệu suất bằng EXPLAIN ANALYZE
*/
CREATE INDEX idx_post_tags_gin ON post USING GIN(tags);

EXPLAIN ANALYZE SELECT * FROM post WHERE tags @> ARRAY['travel'];

-- [Trước khi tạo Index]:
-- Để tìm kiếm một phần tử nằm bên trong cột mảng (Array), hệ thống phải quét 
-- tuần tự ("Seq Scan") từng dòng rồi rà soát nội dung bên trong mảng đó.

-- [Sau khi tạo Index (idx_post_tags_gin)]:
-- Kế hoạch thực thi (Query Plan) chuyển sang dùng "Bitmap Index Scan". 
-- Chỉ mục GIN hoạt động như một mục lục sách, nó lưu trữ danh sách các hàng 
-- chứa từ khóa 'travel'. Cơ sở dữ liệu chỉ cần bốc chính xác các hàng đó ra 
-- mà không mất công kiểm tra từng dòng một.

--Y3: Tối ưu hóa truy vấn tìm bài đăng mới trong 7 ngày gần nhất:
/*
	Tạo Partial Index cho bài viết công khai gần đây:
	Kiểm tra hiệu suất với truy vấn:
*/

CREATE INDEX idx_post_recent_public
ON post(created_at DESC)
WHERE is_public = TRUE;

EXPLAIN ANALYZE SELECT * FROM post
WHERE is_public = TRUE AND created_at >= NOW() - INTERVAL '7 days';

-- [Trước khi tạo Index]:
-- Hệ thống thực hiện "Seq Scan" để kiểm tra điều kiện thời gian và trạng thái 
-- 'is_public' của toàn bộ các hàng dữ liệu.

-- [Sau khi tạo Index (idx_post_recent_public)]:
-- PostgreSQL sẽ áp dụng "Index Scan" hoặc "Index Only Scan" (nếu có). 
-- Vì index được sắp xếp sẵn theo chiều giảm dần (created_at DESC), công cụ 
-- tối ưu truy vấn chỉ cần quét từ đầu Index và dừng lại ngay khi chạm mốc 
-- vượt quá '7 ngày trước' (vì dữ liệu sau mốc đó chắc chắn cũ hơn). 
-- Việc kết hợp Partial Index (WHERE is_public = TRUE) cũng giúp loại bỏ hoàn toàn 
-- các bài viết riêng tư ra khỏi index, tiết kiệm dung lượng RAM và bộ nhớ đệm.

--Y4: Phân tích chỉ mục tổng hợp (Composite Index):
/*
	Tạo chỉ mục (user_id, created_at DESC)
	Kiểm tra hiệu suất khi người dùng xem “bài đăng gần đây của bạn bè”
*/
EXPLAIN ANALYZE SELECT * FROM post 
WHERE user_id = 42
ORDER BY created_at DESC;

CREATE INDEX idx_post_user_created 
ON post (user_id, created_at DESC);
-- [Nhận xét của bạn sau khi chạy thực tế]: 
-- Hệ thống đã chuyển sang sử dụng Index Scan trên 'idx_post_user_created'. 
-- Bước 'Sort' đã bị loại bỏ vì dữ liệu trong index đã được sắp xếp sẵn, 
-- giúp chi phí (cost) và thời gian thực thi (execution time) giảm đi đáng kể.
