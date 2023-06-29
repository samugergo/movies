import 'package:movies/utils/json_util.dart';

import '../../enums/property_enum.dart';

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
        id: getField(json, PropertyEnum.id),
        title: getField(json, PropertyEnum.name),
        image: getImage(json, PropertyEnum.poster),
        cover: getField(json, PropertyEnum.cover));
  }
}
