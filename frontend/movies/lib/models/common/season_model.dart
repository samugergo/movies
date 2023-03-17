class SeasonModel {
  final int id;
  final String title;
  final String release;
  final int episodes;
  final String image;

  SeasonModel({
    required this.id,
    required this.title,
    required this.release,
    required this.episodes,
    required this.image
  });

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    return SeasonModel(
      id: json['id'], 
      title: json['title'], 
      release: json['release'], 
      episodes: json['episodes'], 
      image: json['image']
    );
  }
}