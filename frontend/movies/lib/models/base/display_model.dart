import 'package:movies/utils/common_util.dart';

class DisplayModel {
  final int id;
  final String title;
  final String release;
  final String percent;
  final double raw;
  final String image;
  final String cover;

  DisplayModel({
    required this.id,
    required this.title,
    required this.release,
    required this.raw,
    required this.percent,
    required this.image,
    required this.cover
  });

  factory DisplayModel.fromJson(Map<String, dynamic> json) {
    return DisplayModel(
      id: json['id'], 
      title: getFirstNotNull([json['title'], json['name'], json['original_title'], json['original_name']]), 
      release: getFirstNotNull([json['release_date'], json['first_air_date']]), 
      raw: json['vote_average'].toDouble(),
      percent: percentFormat(json['vote_average']), 
      image: imageLink(json['poster_path']), 
      cover: imageLink(json['cover']),
    );
  }

  @override
  String toString() {
    return '$id $title $release';
  }
}