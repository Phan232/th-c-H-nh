import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double _sliderValue = 50;
  bool _isActive = false;
  String _selectedGenre = "None";
  DateTime? _selectedDate;

  // Xử lý gọi DatePicker từ BuildContext hợp lệ [cite: 33, 58]
  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // Cập nhật state UI [cite: 34, 57]
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise 2 – Input Contr..."),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề Slider
            const Text("Rating (Slider)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Slider(
              min: 0,
              max: 100,
              value: _sliderValue,
              onChanged: (val) => setState(() => _sliderValue = val),
            ),
            Text("Current value: ${_sliderValue.toStringAsFixed(0)}"),
            const SizedBox(height: 16),

            // Tiêu đề Switch
            const Text("Active (Switch)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Is movie active?"),
                Switch(
                  value: _isActive,
                  onChanged: (val) => setState(() => _isActive = val),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tiêu đề RadioListTile
            const Text("Genre (RadioListTile)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RadioListTile<String>(
              title: const Text("Action"),
              value: "Action",
              groupValue: _selectedGenre,
              onChanged: (val) => setState(() => _selectedGenre = val!),
            ),
            RadioListTile<String>(
              title: const Text("Comedy"),
              value: "Comedy",
              groupValue: _selectedGenre,
              onChanged: (val) => setState(() => _selectedGenre = val!),
            ),
            Text("Selected genre: $_selectedGenre"),
            const SizedBox(height: 24),

            // Button mở DatePicker bo tròn thanh mảnh chuẩn ảnh mẫu
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: _showDatePicker,
                child: const Text("Open Date Picker"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}