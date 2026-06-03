import 'package:flutter/material.dart';

class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  // Danh sách tên phim chính xác theo ảnh mẫu của đề bài
  final List<String> movies = const ["Avatar", "Inception", "Interstellar", "Joker"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise 3 – Layout De..."),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Spacing đều 16px [cite: 41]
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Tiêu đề lớn căn giữa
            const Center(
              child: Text(
                "Now Playing",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16), // Khoảng cách cố định [cite: 39]

            // Sử dụng Expanded bao bọc ListView để không bị lỗi vô hạn chiều cao trong Column [cite: 35, 40]
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  String item = movies[index];
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      // Avatar dạng hình tròn chứa ký tự đầu tiên
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: Text(
                          item.substring(0, 1),
                          style: TextStyle(color: Colors.blue.shade900),
                        ),
                      ),
                      title: Text(item, style: const TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: const Text("Sample description"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}