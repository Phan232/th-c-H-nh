import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // Lab 8.1 & 8.4: Hàm lấy danh sách bài viết (GET)
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/posts')).timeout(
        const Duration(seconds: 10), // Đề phòng mạng quá yếu
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        return data
            .map((item) => Post.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Không thể tải dữ liệu từ server (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối mạng: Mời bạn thử lại.');
    }
  }

  // Optional: Hàm tạo bài viết mới (POST)
  Future<Post> createPost(String title, String body) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/posts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(<String, dynamic>{
          'title': title,
          'body': body,
          'userId': 1, // Mặc định userId giả lập
        }),
      );

      if (response.statusCode == 201) {
        return Post.fromJson(json.decode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception('Không thể tạo bài viết mới.');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi gửi dữ liệu.');
    }
  }
}
