import 'package:flutter/material.dart';
import 'core_widgets_demo.dart';
import 'input_controls_demo.dart';
import 'layout_demo.dart';
import 'theme_demo.dart';
import 'common_ui_fixes.dart';

void main() {
  runApp(const Lab4App());
}

// Sử dụng ValueNotifier để thay đổi ThemeMode trên toàn bộ ứng dụng
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

class Lab4App extends StatelessWidget {
  const Lab4App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Lab 4 Flutter UI',
          // Cấu hình ThemeData chuẩn hóa [cite: 11]
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: currentMode, // Nhận trạng thái thay đổi tự động [cite: 51]
          home: const HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Khung tạo nút điều hướng dạng Card bo góc như mẫu [cite: 5]
  Widget buildExerciseCard(BuildContext context, String title, Widget page) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 0.5),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f7fa), // Màu nền xám nhạt theo mẫu [cite: 5]
      appBar: AppBar(
        backgroundColor: const Color(0xfff8f7fa),
        elevation: 0,
        title: const Text(
          "Lab 4 – Flutter UI Fundament...",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            buildExerciseCard(context, "Exercise 1 – Core Widgets Demo", const CoreWidgetsDemo()),
            buildExerciseCard(context, "Exercise 2 – Input Controls Demo", const InputControlsDemo()),
            buildExerciseCard(context, "Exercise 3 – Layout Demo", const LayoutDemo()),
            buildExerciseCard(context, "Exercise 4 – App Structure & Theme", const ThemeDemo()),
            buildExerciseCard(context, "Exercise 5 – Common UI Fixes", const CommonUiFixes()),
          ],
        ),
      ),
    );
  }
}