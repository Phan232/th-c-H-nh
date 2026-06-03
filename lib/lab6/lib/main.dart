import 'package:flutter/material.dart';

void main() {
  runApp(const MovieBrowseApp());
}

class MovieBrowseApp extends StatelessWidget {
  const MovieBrowseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Responsive Movie Browser',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xfff8f9fa),
      ),
      home: const MovieBrowseScreen(),
    );
  }
}

// 1. ĐỊNH NGHĨA DATA MODEL & DỮ LIỆU TĨNH (Step 2 & Step 5)
class Movie {
  final String title;
  final String genre;
  final String year;
  final double rating;
  final String imageUrl;

  const Movie({
    required this.title,
    required this.genre,
    required this.year,
    required this.rating,
    required this.imageUrl,
  });
}

// Bộ dữ liệu mẫu phong phú đầy đủ thông tin để kiểm tra bộ lọc và sắp xếp
const List<Movie> sampleMovies = [
  Movie(
    title: "Dune: Part Two",
    genre: "Sci-Fi",
    year: "2024",
    rating: 8.6,
    imageUrl: "https://picsum.photos/id/42/300/200",
  ),
  Movie(
    title: "Deadpool & Wolverine",
    genre: "Action",
    year: "2024",
    rating: 8.3,
    imageUrl: "https://picsum.photos/id/116/300/200",
  ),
  Movie(
    title: "Inception",
    genre: "Sci-Fi",
    year: "2010",
    rating: 8.8,
    imageUrl: "https://picsum.photos/id/201/300/200",
  ),
  Movie(
    title: "The Hangover",
    genre: "Comedy",
    year: "2009",
    rating: 7.7,
    imageUrl: "https://picsum.photos/id/324/300/200",
  ),
  Movie(
    title: "Interstellar",
    genre: "Sci-Fi",
    year: "2014",
    rating: 8.7,
    imageUrl: "https://picsum.photos/id/364/300/200",
  ),
  Movie(
    title: "The Dark Knight",
    genre: "Action",
    year: "2008",
    rating: 9.0,
    imageUrl: "https://picsum.photos/id/443/300/200",
  ),
];

// 2. MÀN HÌNH CHÍNH (QUẢN LÝ STATE LỌC & SẮP XẾP)
class MovieBrowseScreen extends StatefulWidget {
  const MovieBrowseScreen({super.key});

  @override
  State<MovieBrowseScreen> createState() => _MovieBrowseScreenState();
}

class _MovieBrowseScreenState extends State<MovieBrowseScreen> {
  // Trạng thái tìm kiếm và bộ lọc
  String _searchQuery = "";
  String _selectedGenre = "All";
  String _sortBy = "A–Z";

  final List<String> _genres = ["All", "Action", "Sci-Fi", "Comedy"];
  final List<String> _sortOptions = ["A–Z", "Z–A", "Year", "Rating"];

  @override
  Widget build(BuildContext context) {
    // Logic tiến hành Lọc (Filtering) danh sách phim
    List<Movie> filteredMovies = sampleMovies.where((movie) {
      final matchesSearch = movie.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesGenre = _selectedGenre == "All" || movie.genre == _selectedGenre;
      return matchesSearch && matchesGenre;
    }).toList();

    // Logic tiến hành Sắp xếp (Sorting) danh sách phim đã lọc
    if (_sortBy == "A–Z") {
      filteredMovies.sort((a, b) => a.title.compareTo(b.title));
    } else if (_sortBy == "Z–A") {
      filteredMovies.sort((a, b) => b.title.compareTo(a.title));
    } else if (_sortBy == "Year") {
      filteredMovies.sort((a, b) => b.year.compareTo(a.year)); // Năm mới nhất lên đầu
    } else if (_sortBy == "Rating") {
      filteredMovies.sort((a, b) => b.rating.compareTo(a.rating)); // Điểm cao nhất lên đầu
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Find a Movie", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // THANH TÌM KIẾM (Lab 6.2)
            TextField(
              decoration: InputDecoration(
                hintText: "Search movies...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // BỘ LỌC THỂ LOẠI DẠNG CHIPS (Lab 6.2)
            const Text("Genres", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _genres.map((genre) {
                final isSelected = _selectedGenre == genre;
                return ChoiceChip(
                  label: Text(genre),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedGenre = genre;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // THANH CHỌN KIỂU SẮP XẾP DROPDOWN (Lab 6.2)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Results (${filteredMovies.length})",
                  style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    const Text("Sort by: ", style: TextStyle(fontWeight: FontWeight.w500)),
                    DropdownButton<String>(
                      value: _sortBy,
                      underline: const SizedBox(), // Ẩn gạch chân mặc định
                      items: _sortOptions.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() {
                            _sortBy = newValue;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // PHẦN DANH SÁCH ĐÁP ỨNG RESPONSIVE THEO KÍCH THƯỚC MÀN HÌNH (Lab 6.3)
            Expanded(
              child: filteredMovies.isEmpty
                  ? const Center(child: Text("No movies found."))
                  : LayoutBuilder(
                builder: (context, constraints) {
                  // Xác định Breakpoint: chiều rộng màn hình lớn hơn hoặc bằng 800px là Tablet/Web
                  if (constraints.maxWidth >= 800) {
                    // BỐ CỤC TABLET / WEB: Lưới GridView 2 cột
                    return GridView.builder(
                      itemCount: filteredMovies.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 130, // Chiều cao cố định cho card nằm ngang
                      ),
                      itemBuilder: (context, index) {
                        return MovieCard(movie: filteredMovies[index]);
                      },
                    );
                  } else {
                    // BỐ CỤC ĐIỆN THOẠI: Danh sách cuộn đứng đơn cột
                    return ListView.builder(
                      itemCount: filteredMovies.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: MovieCard(movie: filteredMovies[index]),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. WIDGET THẺ HIỂN THỊ PHIM (MOVIE CARD WIDGET)
class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Ảnh Poster phim bo viền tròn góc
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                movie.imageUrl,
                width: 100,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 80,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),

            // Thông tin chi tiết văn bản bên phải
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${movie.genre} • ${movie.year}",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  // Điểm số Rating hiển thị kèm ngôi sao vàng
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        movie.rating.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}