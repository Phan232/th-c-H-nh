// Định nghĩa lớp Movie làm Data Model cho ứng dụng
class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<String> trailers;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
  });
}

// BỘ DỮ LIỆU TĨNH CHUẨN XÁC THEO HÌNH ẢNH MẪU TRONG ĐỀ BÀI LAB 5
final List<Movie> sampleMovies = [
  Movie(
    id: "1",
    title: "Dune: Part Two",
    posterUrl: "https://picsum.photos/id/42/400/250",
    overview: "Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.",
    genres: ["Sci-Fi", "Adventure", "Drama"],
    rating: 8.6,
    trailers: ["Official Trailer #1", "IMAX Sneak Peek"],
  ),
  Movie(
    id: "2",
    title: "Deadpool & Wolverine",
    posterUrl: "https://picsum.photos/id/116/400/250",
    overview: "The multiverse gets messy when Wade Wilson teams up with Wolverine for a not-so-family-friendly mission.",
    genres: ["Action", "Comedy"],
    rating: 8.3,
    trailers: ["Red Band Trailer", "Behind the Scenes"],
  ),
];