import 'package:flutter/material.dart';

void main() {
  runApp(const SignupApp());
}

class SignupApp extends StatelessWidget {
  const SignupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Valid Sign Up Form',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        scaffoldBackgroundColor: const Color(0xfff8f9fa),
      ),
      home: const SignupScreen(),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // GlobalKey dùng để quản lý trạng thái của Form và kích hoạt validate()
  final _formKey = GlobalKey<FormState>();

  // Bộ điều khiển Controller để lấy dữ liệu văn bản từ các ô nhập
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Bộ quản lý FocusNode để xử lý luồng di chuyển của bàn phím (UX)
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  // Trạng thái ẩn/hiển thị mật khẩu
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Trạng thái xử lý bất đồng bộ (Loading)
  bool _isLoading = false;

  @override
  void dispose() {
    // Giải phóng bộ nhớ của các Controller và FocusNode khi widget bị hủy
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  // BIỆN PHÁP XỬ LÝ SUBMIT FORM & ASYNC VALIDATION (Lab 7.4)
  Future<void> _submitForm() async {
    // 1. Kiểm tra validation đồng bộ trước
    if (_formKey.currentState!.validate()) {
      // Ẩn bàn phím ngay khi bấm nút gửi thông tin hợp lệ
      FocusScope.of(context).unfocus();

      setState(() {
        _isLoading = true;
      });

      // Giả lập độ trễ mạng gọi API bất đồng bộ trong 1.5 giây
      await Future.delayed(const Duration(milliseconds: 1500));

      setState(() {
        _isLoading = false;
      });

      // Kiểm tra tình huống Email giả lập đã tồn tại (Giống yêu cầu Lab 7.4)
      if (_emailController.text.trim().toLowerCase() == "test@gmail.com") {
        // Hiển thị thông báo lỗi cụ thể qua SnackBar hoặc xử lý lỗi trên Form
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error: Email 'test@gmail.com' is already taken!"),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else {
        // Tình huống đăng ký thành công hoàn toàn
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Account created successfully for ${_nameController.text}!"),
            backgroundColor: Colors.green,
          ),
        );
        // Reset form về trạng thái trống ban đầu
        _formKey.currentState!.reset();
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // GestureDetector bọc toàn màn hình để khi người dùng nhấn ra ngoài, bàn phím tự ẩn (Lab 7.3)
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create Account", style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey, // Gắn key quản lý form vào hệ thống
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.lock_outline, size: 80, color: Colors.teal),
                  const SizedBox(height: 12),
                  const Text(
                    "Join Us Today!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),

                  // 1. Ô NHẬP TÊN (FULL NAME FIELD)
                  TextFormField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    textInputAction: TextInputAction.next, // Nhấn Next để chuyển ô dưới
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    // Di chuyển focus thủ công sang ô Email khi hoàn thành (Lab 7.3)
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_emailFocus),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Full name is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 2. Ô NHẬP EMAIL (EMAIL FIELD)
                  TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      prefixIcon: const Icon(Icons.mail_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocus),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email is required";
                      }
                      // Regex đơn giản để check định dạng email hợp lệ chứa @ và .
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return "Please enter a valid email format (e.g. user@example.com)";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 3. Ô NHẬP MẬT KHẨU (PASSWORD FIELD)
                  TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    obscureText: _obscurePassword, // Ẩn văn bản ký tự dạng chấm tròn
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock_open_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_confirmPasswordFocus),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      if (value.length < 8) {
                        return "Password must be at least 8 characters long";
                      }
                      // Kiểm tra xem chuỗi có chứa ít nhất 1 chữ số hay không
                      if (!value.contains(RegExp(r'[0-9]'))) {
                        return "Password must contain at least 1 digit";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 4. Ô NHẬP LẠI MẬT KHẨU (CONFIRM PASSWORD FIELD)
                  TextFormField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocus,
                    obscureText: _obscureConfirmPassword,
                    textInputAction: TextInputAction.done, // Nút Done biểu thị kết thúc form
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    // Khi nhấn Done thì tự động gọi hàm submit luôn (Tối ưu UX)
                    onFieldSubmitted: (_) => _submitForm(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your password";
                      }
                      // Đối chiếu văn bản trùng khớp với ô mật khẩu chính ở trên
                      if (value != _passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),

                  // 5. NÚT ĐĂNG KÝ (SUBMIT BUTTON) ĐƯỢC QUẢN LÝ LOADING STATE
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 1,
                      ),
                      onPressed: _isLoading ? null : _submitForm, // Vô hiệu hóa nút khi đang load bài
                      child: _isLoading
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                          : const Text("Sign Up", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}