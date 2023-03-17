class MovieModel {
  final int id;
  final String title;
  final String release;
  final String percent;
  final String image;
  final String cover;

  MovieModel({
    required this.id,
    required this.title,
    required this.release,
    required this.percent,
    required this.image,
    required this.cover
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'], 
      title: json['title'], 
      release: json['release'], 
      percent: json['percent'], 
      image: json['image'], 
      cover: json['cover']
    );
  }
}