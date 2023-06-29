import 'package:movies/utils/json_util.dart';
import 'package:movies/enums/property_enum.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/base/display_model.dart';

class CollectionDetailedModel {
  final int id;
  final String title;
  final String description;
  final String image;
  final String cover;
  final List modelList;

  CollectionDetailedModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.image,
      required this.cover,
      required this.modelList});

  factory CollectionDetailedModel.fromJson(Map<String, dynamic> json) {
    return CollectionDetailedModel(
        id: getField(json, PropertyEnum.id),
        title: getField(json, PropertyEnum.name),
        description: getField(json, PropertyEnum.description),
        image: getImage(json, PropertyEnum.poster),
        cover: getImage(json, PropertyEnum.cover),
        modelList: json[PropertyEnum.parts.key]
            ?.map((p) => DisplayModel.fromJson(p, TypeEnum.movie))
            .toList());
  }
}
