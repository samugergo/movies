import 'package:movies/utils/json_util.dart';
import 'package:movies/utils/common_util.dart';

import '../../enums/property_enum.dart';

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
        id: getField(json, PropertyEnum.id),
        title: getField(json, PropertyEnum.name),
        image: getImage(json, PropertyEnum.poster),
        seasonNumber: getField(json, PropertyEnum.seasonNumber));
  }
}