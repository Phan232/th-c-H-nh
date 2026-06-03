import 'package:flutter/material.dart';
import 'movie_model.dart';
import 'movie_detail_screen.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Detail App',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xfff8f9fa),
      ),
      home: const HomeScreen(),
    );
  }
}

// HOME SCREEN – HIỂN THỊ DANH SÁCH PHIM CUỘN TRƠN TRU
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff8f9fa),
        elevation: 0,
        title: const Text(
          "Movies",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemCount: sampleMovies.length,
          itemBuilder: (context, index) {
            final movie = sampleMovies[index];
            return Card(
              elevation: 1,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                // Ảnh thu nhỏ (Thumbnail/Poster) bo góc tròn bên trái
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    movie.posterUrl,
                    width: 90,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                // Phần thân chứa Tiêu đề, Điểm số và Thể loại gộp thành một chuỗi
                title: Text(
                  movie.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Padding(
                  // ĐÃ SỬA: Thay thế EdgeInsets.top bằng EdgeInsets.only(top: 4.0)
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "⭐ ${movie.rating} • ${movie.genres.join(', ')}",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Icon mũi tên điều hướng sang phải
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
                // LOGIC CHUYỂN MÀN HÌNH: Navigator.push truyền nguyên đối tượng 'movie' được chọn
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: movie),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}