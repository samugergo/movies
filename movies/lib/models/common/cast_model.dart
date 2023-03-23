import 'package:movies/utils/common_util.dart';

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
    return CastModel(
      id: json['id'],
      name: json['name'],
      role: json['character'],
      image: imageLink(json['profile_path']),
    );
  }
}