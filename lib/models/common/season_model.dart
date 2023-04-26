import 'package:movies/converter/json_converters.dart';
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
    return fromJsonSeasonModel(json);
  }
}