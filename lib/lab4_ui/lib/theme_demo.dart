import 'package:flutter/material.dart';
import 'main.dart'; // Import để sử dụng themeNotifier toàn cục

class ThemeDemo extends StatelessWidget {
  const ThemeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy trạng thái hiện tại xem hệ thống đang là Dark Mode hay không
    bool isDark = themeNotifier.value == ThemeMode.dark;

    return Scaffold(
      // Scaffold cấu trúc chuẩn gồm AppBar, Body, FAB [cite: 45]
      appBar: AppBar(
        title: const Text("Exercise 4 – App Str..."),
        actions: [
          // Nút toggle chuyển chế độ trên thanh AppBar giống hình mẫu [cite: 41]
          Row(
            children: [
              const Text("Dark"),
              Switch(
                value: isDark,
                onChanged: (value) {
                  // Cập nhật giá trị thông báo thay đổi Theme trên toàn ứng dụng [cite: 51]
                  themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            ],
          )
        ],
      ),
      body: const Center(
        child: Text(
          "This is a simple screen with theme toggle.",
          style: TextStyle(fontSize: 16),
        ),
      ),
      // Bổ sung FloatingActionButton [cite: 49]
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("FloatingActionButton Pressed!")),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}