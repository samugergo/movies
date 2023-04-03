import 'package:movies/utils/common_util.dart';

class SeasonModel {
  final int id;
  final String title;
  final String image;
  final int seasonNumber;

  SeasonModel({
    required this.id,
    required this.title,
    required this.image,
    required this.seasonNumber,
  });

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    return SeasonModel(
      id: json['id'], 
      title: json['name'], 
      seasonNumber: json['season_number'],
      image: imageLink(json['poster_path']),
    );
  }
}