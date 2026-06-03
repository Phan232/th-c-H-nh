import 'package:flutter/material.dart';

class CommonUiFixes extends StatelessWidget {
  const CommonUiFixes({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> errorMovies = const ["Movie A", "Movie B", "Movie C", "Movie D"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise 5 – Common U..."),
      ),
      // Sử dụng SingleChildScrollView ngăn chặn triệt để lỗi tràn màn hình (Overflow)
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Correct ListView inside Column using Expanded",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Khắc phục lỗi: Sử dụng shrinkWrap và physics khi đặt ListView trong SingleChildScrollView
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Để ScrollView bên ngoài xử lý thao tác cuộn chính
              itemCount: errorMovies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  // ĐÃ SỬA: Thay Colors.slateBlue bằng Colors.blueGray (hoặc Colors.blue)
                  leading:  Icon(Icons.movie, color: Color(0xFF607D8B)),
                  title: Text(errorMovies[index], style: const TextStyle(fontSize: 16)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}