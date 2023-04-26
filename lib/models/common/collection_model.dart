import 'package:movies/converter/json_converters.dart';

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
    return fromJsonCollectionModel(json);
  }
}