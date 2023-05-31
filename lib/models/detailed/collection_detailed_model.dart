import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/base/display_model.dart';
import 'package:movies/utils/common_util.dart';

class CollectionDetailedModel {
  final int id;
  final String title;
  final String description;
  final String image;
  final String cover;
  final List modelList;

  CollectionDetailedModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.cover,
    required this.modelList
  });

  factory CollectionDetailedModel.fromJson(Map<String, dynamic> json) {
    return CollectionDetailedModel(
      id: json['id'], 
      title: json['name'], 
      description: json['overview'] ?? '',
      image: imageLink(json['poster_path']) ?? '', 
      cover: json['backdrop_path'] ?? '', 
      modelList: json['parts'].map((p) => DisplayModel.fromJson(p, TypeEnum.movie)).toList(),
    );
  }
}