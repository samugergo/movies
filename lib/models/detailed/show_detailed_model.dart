import 'package:movies/models/others/season_model.dart';
import 'package:movies/models/common/detailed/detailed_model.dart';

import '../../utils/common_util.dart';
import '../../utils/json_util.dart';
import '../../enums/property_enum.dart';
import '../others/cast_model.dart';
import '../others/external_id_model.dart';

class ShowDetailedModel extends DetailedModel {
  final List seasons;

  ShowDetailedModel(
      {required int id,
      required String title,
      required String release,
      required double raw,
      required String image,
      required String cover,
      required String description,
      required int length,
      required List genres,
      required ExternalIdModel externalIds,
      required List cast,
      required String trailer,
      required List images,
      required CastModel? director,
      required this.seasons})
      : super(
            id: id,
            title: title,
            release: release,
            raw: raw,
            image: image,
            cover: cover,
            description: description,
            genres: genres,
            length: length,
            externalIds: externalIds,
            cast: cast,
            director: director,
            trailer: trailer,
            images: images);

  factory ShowDetailedModel.fromJson(Map<String, dynamic> json) {
    return ShowDetailedModel(
        id: getField(json, PropertyEnum.id),
        title: getFieldList(json, PropertyEnum.titleProperties),
        release: getField(json, PropertyEnum.releaseDate),
        raw: getFieldDouble(json, PropertyEnum.percent),
        image: getImage(json, PropertyEnum.poster),
        cover: getField(json, PropertyEnum.cover),
        description: getField(json, PropertyEnum.description),
        length: getField(json, PropertyEnum.length),
        externalIds: ExternalIdModel.fromJson(json[PropertyEnum.externalIds.key]),
        cast: getCast(json),
        director: getDirector(json),
        genres: getGenres(json),
        trailer: getTrailer(json[PropertyEnum.videos.key]),
        images: getImages(json),
        seasons: getSeasons(json));
  }
}
