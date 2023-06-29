import 'package:movies/utils/json_util.dart';
import 'package:movies/enums/property_enum.dart';
import 'package:movies/models/others/collection_model.dart';
import 'package:movies/models/common/detailed/detailed_model.dart';

class MovieDetailedModel extends DetailedModel {
  final CollectionModel? collection;

  MovieDetailedModel(int id, String title, String release, double raw, String image, String cover,
      String description, int length, List genres, this.collection)
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

  factory MovieDetailedModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailedModel(
      getField(json, PropertyEnum.id),
      getFieldList(json, PropertyEnum.titleProperties),
      getField(json, PropertyEnum.releaseDate),
      getFieldDouble(json, PropertyEnum.percent),
      getImage(json, PropertyEnum.poster),
      getField(json, PropertyEnum.cover),
      getField(json, PropertyEnum.description),
      getField(json, PropertyEnum.length),
      json[PropertyEnum.genres.key].map((g) => g[PropertyEnum.name.key]).toList(),
      json[PropertyEnum.belongsToCollection.key] != null
          ? CollectionModel.fromJson(json[PropertyEnum.belongsToCollection.key])
          : null,
    );
  }
}
