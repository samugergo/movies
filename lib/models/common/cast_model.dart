import 'package:movies/converter/json_converters.dart';

class CastModel {
  final int id;
  final String name;
  final String role;
  final String image;

  CastModel({
    required this.id,
    required this.name,
    required this.role,
    required this.image
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return fromJsonCastModel(json);
  }
}