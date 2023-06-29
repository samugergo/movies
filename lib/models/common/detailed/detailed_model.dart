class DetailedModel {
  final int id;
  final String title;
  final String release;
  final double raw;
  final String image;
  final String cover;
  final String description;
  final List genres;
  final int length;

  DetailedModel({
    required this.id,
    required this.title,
    required this.release,
    required this.raw,
    required this.image,
    required this.cover,
    required this.description,
    required this.genres,
    required this.length,
  });
}