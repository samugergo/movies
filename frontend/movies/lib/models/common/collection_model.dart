class Collection {
  final int id;
  final String title;
  final String image;
  final String cover;

  Collection({
    required this.id,
    required this.title,
    required this.image,
    required this.cover,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'], 
      title: json['title'], 
      image: json['image'], 
      cover: json['cover'],
    );
  }
}