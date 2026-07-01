import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';
import 'post_detail_screen.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _postsFuture = _apiService.fetchPosts();
    });

    try {
      await _postsFuture;
    } catch (_) {
      // FutureBuilder displays the error state.
    }
  }

  // Hàm xử lý hiển thị Dialog để tạo bài viết mới (POST)
  void _showCreatePostDialog() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạo bài viết mới (POST)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Tiêu đề'),
            ),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(labelText: 'Nội dung'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isEmpty || bodyController.text.isEmpty) return;
              Navigator.pop(context);

              // Hiển thị loading nhanh bằng SnackBar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đang gửi dữ liệu...')),
              );

              try {
                Post newPost = await _apiService.createPost(
                  titleController.text,
                  bodyController.text,
                );

                // Thông báo thành công
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Thành công! Thêm bài viết ID: ${newPost.id}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Gửi đi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Posts List'),
        elevation: 2,
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadPosts(), // Tính năng Pull-to-refresh (Bonus)
        child: FutureBuilder<List<Post>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            // 1. Trạng thái Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // 2. Trạng thái Lỗi (Có nút Retry)
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 60),
                      const SizedBox(height: 16),
                      Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _loadPosts,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Thử lại'),
                      )
                    ],
                  ),
                ),
              );
            }

            // 3. Trạng thái hiển thị dữ liệu thành công
            if (snapshot.hasData) {
              final posts = snapshot.data!;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${post.id}'),
                      ),
                      title: Text(
                        post.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        post.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Chuyển sang màn hình Chi tiết (Bonus)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailScreen(post: post),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }

            return const Center(child: Text('Không có dữ liệu hiển thị.'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePostDialog,
        tooltip: 'Thêm bài viết',
        child: const Icon(Icons.add),
      ),
    );
  }
}
