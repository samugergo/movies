class DisplayModel {
  final int id;
  final String title;
  final String release;
  final String percent;
  final String image;
  final String cover;

  DisplayModel({
    required this.id,
    required this.title,
    required this.release,
    required this.percent,
    required this.image,
    required this.cover
  });

  factory DisplayModel.fromJson(Map<String, dynamic> json) {
    return DisplayModel(
      id: json['id'], 
      title: json['title'], 
      release: json['release'], 
      percent: json['percent'], 
      image: json['image'] ?? '', 
      cover: json['cover'] ?? '',
    );
  }

  @override
  String toString() {
    return '$id $title $release';
  }
}