import 'package:movies/converter/json_converters.dart';

class DisplayModel {
  final int id;
  final String title;
  final String release;
  final double percent;
  final String image;
  final String cover;
  final String tagline;

  DisplayModel({
    required this.id,
    required this.title,
    required this.release,
    required this.percent,
    required this.image,
    required this.cover,
    required this.tagline,
  });

  factory DisplayModel.fromJson(Map<String, dynamic> json) {
    return fromJsonDisplayModel(json);
  }

  @override
  String toString() {
    return '$id $title $release';
  }
}