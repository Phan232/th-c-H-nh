import 'package:flutter/material.dart';

class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise 1 – Core Widge..."),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái theo ảnh mẫu [cite: 17]
          children: [
            // Headline Text [cite: 23]
            const Text(
              "Welcome to Flutter UI",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Icon Clapperboard màu xanh dương ở giữa [cite: 24]
            const Center(
              child: Icon(
                Icons.movie_creation,
                size: 90,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),

            // Image hiển thị từ internet [cite: 25]
            ClipRRect(
              child: Image.network(
                "https://picsum.photos/id/15/400/250", // Ảnh phong cảnh/đường chân trời tương tự ảnh gốc
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),

            // Card chứa ListTile [cite: 26]
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const ListTile(
                leading: Icon(Icons.star, size: 28), // Icon ngôi sao bên trái theo hình [cite: 17]
                title: Text("Movie Item"),
                subtitle: Text("This is a sample ListTile inside a Card."),
              ),
            ),
          ],
        ),
      ),
    );
  }
}