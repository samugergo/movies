import 'package:movies/utils/json_util.dart';

import '../../enums/property_enum.dart';

class CastModel {
  final int id;
  final String name;
  final String role;
  final String image;

  CastModel({required this.id, required this.name, required this.role, required this.image});

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
        id: getField(json, PropertyEnum.id),
        name: getField(json, PropertyEnum.name),
        role: getField(json, PropertyEnum.role),
        image: getImage(json, PropertyEnum.profile));
  }
}
