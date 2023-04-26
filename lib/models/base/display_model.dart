import 'package:movies/converter/json_converters.dart';
import 'package:movies/enums/type_enum.dart';

class DisplayModel {
  final int id;
  final String title;
  final String release;
  final double percent;
  final String image;
  final String cover;
  final String tagline;
  final TypeEnum type;

  DisplayModel({
    required this.id,
    required this.title,
    required this.release,
    required this.percent,
    required this.image,
    required this.cover,
    required this.tagline,
    required this.type,
  });

  factory DisplayModel.fromJson(Map<String, dynamic> json, TypeEnum type) {
    return fromJsonDisplayModel(json, type);
  }

  @override
  String toString() {
    return '$id $title $release';
  }
}