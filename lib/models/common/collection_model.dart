import 'package:movies/utils/common_util.dart';

class CollectionModel {
  final int id;
  final String title;
  final String image;
  final String cover;

  CollectionModel({
    required this.id,
    required this.title,
    required this.image,
    required this.cover,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      id: json['id'], 
      title: json['name'], 
      image: imageLink(json['poster_path']), 
      cover: json['backdrop_path'] ?? '',
    );
  }
}