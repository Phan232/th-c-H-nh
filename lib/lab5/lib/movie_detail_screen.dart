import 'package:flutter/material.dart';
import 'movie_model.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  // Trạng thái Favorite để xử lý tính năng nâng cao (Optional Enhancement)
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa), // Màu nền sáng nhạt
      // AppBar trơn bóng với nút Quay lại tự động xuất hiện
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.movie.title,
          style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HERO BANNER: Sử dụng Stack để vẽ chữ đè lên ảnh kèm hiệu ứng Gradient đổ bóng
            Stack(
              children: [
                Image.network(
                  widget.movie.posterUrl,
                  width: double.infinity,
                  height: 230,
                  fit: BoxFit.cover,
                ),
                // Lớp Gradient màu đen mờ dần từ dưới lên trên làm nổi bật chữ
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black87, Colors.transparent],
                        stops: [0.0, 0.6],
                      ),
                    ),
                  ),
                ),
                // Tiêu đề phim chữ trắng định vị góc dưới trái banner
                Positioned(
                  left: 16,
                  bottom: 16,
                  right: 16,
                  child: Text(
                    widget.movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 2. GENRES CHIPS: Hiển thị các nhãn thể loại bo góc như ảnh mẫu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8.0,
                children: widget.movie.genres.map((genre) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xfff1f3f5),
                      borderRadius: BorderRadius.circular(8),
                      // ĐÃ SỬA: Bọc BorderSide trong Border.all để hợp lệ dữ liệu BoxBorder
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Text(
                      genre,
                      style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // 3. OVERVIEW TEXT: Đoạn văn mô tả tóm tắt nội dung phim
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.movie.overview,
                style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.black87),
              ),
            ),

            const SizedBox(height: 24),

            // 4. ACTION BUTTONS: Hàng nút Favorite, Rate, Share căn chỉnh đều nhau
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Nút Favorite tích hợp đổi trạng thái màu sắc bằng setState()
                InkWell(
                  onTap: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.grey.shade700,
                        size: 28,
                      ),
                      const SizedBox(height: 6),
                      const Text("Favorite", style: TextStyle(fontSize: 13, color: Colors.black87)),
                    ],
                  ),
                ),
                // Nút Rate
                InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Icon(Icons.star_border, color: Colors.grey.shade700, size: 28),
                      const SizedBox(height: 6),
                      const Text("Rate", style: TextStyle(fontSize: 13, color: Colors.black87)),
                    ],
                  ),
                ),
                // Nút Share
                InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Icon(Icons.share, color: Colors.grey.shade700, size: 28),
                      const SizedBox(height: 6),
                      const Text("Share", style: TextStyle(fontSize: 13, color: Colors.black87)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 5. TRAILER LIST: Tiêu đề danh sách trailer phim
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Trailers",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),

            // Dùng ListView.builder ở dạng co gọn (shrinkWrap) phối hợp SingleChildScrollView
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.movie.trailers.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    // ĐÃ SỬA: Bọc BorderSide trong Border.all để hợp lệ dữ liệu BoxBorder
                    border: Border.all(color: Colors.grey.shade200, width: 0.5),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.play_circle_filled, size: 28, color: Colors.black54),
                    title: Text(
                      widget.movie.trailers[index],
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}