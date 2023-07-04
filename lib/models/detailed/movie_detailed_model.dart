import 'package:movies/models/others/cast_model.dart';
import 'package:movies/models/others/external_id_model.dart';
import 'package:movies/utils/json_util.dart';
import 'package:movies/enums/property_enum.dart';
import 'package:movies/models/others/collection_model.dart';
import 'package:movies/models/common/detailed/detailed_model.dart';

import '../../utils/common_util.dart';

class MovieDetailedModel extends DetailedModel {
  final CollectionModel? collection;

  MovieDetailedModel(
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
      required this.collection})
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
            trailer: trailer,
            images: images);

  factory MovieDetailedModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailedModel(
        id: getField(json, PropertyEnum.id),
        title: getFieldList(json, PropertyEnum.titleProperties),
        release: getField(json, PropertyEnum.releaseDate),
        raw: getFieldDouble(json, PropertyEnum.percent),
        image: getImage(json, PropertyEnum.poster),
        cover: getField(json, PropertyEnum.cover),
        description: getField(json, PropertyEnum.description),
        length: getField(json, PropertyEnum.length),
        genres: json[PropertyEnum.genres.key].map((g) => g[PropertyEnum.name.key]).toList(),
        collection: json[PropertyEnum.belongsToCollection.key] != null
            ? CollectionModel.fromJson(json[PropertyEnum.belongsToCollection.key])
            : null,
        externalIds: ExternalIdModel.fromJson(json[PropertyEnum.externalIds.key]),
        cast: json['credits'] != null && json['credits']['cast'] != null
            ? sublist(json['credits']['cast'].map((c) => CastModel.fromJson(c)).toList(), 10)
            : [],
        trailer: getTrailer(json['videos']),
        images: json['images']['backdrops'] != null && json['images']['backdrops'].isNotEmpty
            ? sublist(json['images']['backdrops'], 5).map((e) => e['file_path']).toList()
            : []);
  }
}
