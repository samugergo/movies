import 'package:movies/models/others/season_model.dart';
import 'package:movies/models/common/detailed/detailed_model.dart';

import '../../utils/json_util.dart';
import '../../enums/property_enum.dart';

class ShowDetailedModel extends DetailedModel {
  final List seasons;

  ShowDetailedModel(int id, String title, String release, double raw, String image, String cover,
      String description, int length, List genres, this.seasons)
      : super(
            id: id,
            title: title,
            release: release,
            raw: raw,
            image: image,
            cover: cover,
            description: description,
            genres: genres,
            length: length);

  factory ShowDetailedModel.fromJson(Map<String, dynamic> json) {
    return ShowDetailedModel(
        getField(json, PropertyEnum.id),
        getFieldList(json, PropertyEnum.titleProperties),
        getField(json, PropertyEnum.firstAirDate),
        getFieldDouble(json, PropertyEnum.percent),
        getImage(json, PropertyEnum.poster),
        getField(json, PropertyEnum.cover),
        getField(json, PropertyEnum.description),
        getField(json, PropertyEnum.length),
        json[PropertyEnum.genres.key].map((g) => g[PropertyEnum.name.key]).toList(),
        json[PropertyEnum.seasons.key].map((s) => SeasonModel.fromJson(s)).toList());
  }
}
