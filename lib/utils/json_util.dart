import 'package:movies/models/others/season_model.dart';
import 'package:movies/utils/common_util.dart';

import '../enums/property_enum.dart';
import '../models/others/cast_model.dart';
import '../models/others/collection_model.dart';

T getField<T>(Map<String, dynamic> json, PropertyEnum prop) {
  return json[prop.key] ?? prop.defaultVal;
}

T? getFieldNullable<T>(Map<String, dynamic> json, PropertyEnum prop) {
  return json[prop.key];
}

T getFieldList<T>(Map<String, dynamic> json, List<PropertyEnum> props) {
  final args = props.map((e) => json[e.key]).toList();
  return getFirstNotNull(args);
}

bool isNotNull(Map<String, dynamic> json, PropertyEnum prop) {
  return getFieldNullable(json, prop) != null;
}

String getImage(Map<String, dynamic> json, PropertyEnum prop) {
  final image = json[prop.key];
  if (image != null) {
    return imageLink(image);
  }
  return '';
}

double getFieldDouble(Map<String, dynamic> json, PropertyEnum prop) {
  return json[prop.key].toDouble();
}

String getTrailer(Map<String, dynamic> json) {
  final results = json[PropertyEnum.results.key];
  isTrailer(t) => t[PropertyEnum.type.key] == 'Trailer' && t[PropertyEnum.site.key] == 'YouTube';

  if (results.isNotEmpty) {
    var trailer = results.firstWhere((t) => isTrailer(t) && t[PropertyEnum.official.key],
        orElse: () => results.firstWhere((t) => isTrailer(t), orElse: () => null));
    return trailer != null ? trailer[PropertyEnum.trailerKey.key] : '';
  }
  return '';
}

CastModel? getDirector(Map<String, dynamic> json) {
  final credits = getField(json, PropertyEnum.credits);
  if (isNotNull(json, PropertyEnum.credits) && isNotNull(credits, PropertyEnum.crew)) {
    final director = getField(credits, PropertyEnum.crew)
        .firstWhere((c) => c['job'] == 'Director', orElse: () => null);
    if (director != null) {
      return CastModel.fromJson(director);
    }
  }
  return null;
}

List getCast(Map<String, dynamic> json) {
  final credits = getFieldNullable(json, PropertyEnum.credits);
  return credits != null && isNotNull(credits, PropertyEnum.cast)
      ? sublist(getField(credits, PropertyEnum.cast).map((c) => CastModel.fromJson(c)).toList(), 10)
      : [];
}

List getImages(Map<String, dynamic> json) {
  final images = getField(json, PropertyEnum.images);
  final backdrops = getFieldNullable(images, PropertyEnum.backdrops);
  return isNotNull(json, PropertyEnum.images) && images.isNotEmpty
      ? sublist(backdrops, 5).map((image) => getField(image, PropertyEnum.filePath)).toList()
      : [];
}

CollectionModel? getCollection(Map<String, dynamic> json) {
  return isNotNull(json, PropertyEnum.belongsToCollection)
      ? CollectionModel.fromJson(getField(json, PropertyEnum.belongsToCollection))
      : null;
}

List getSeasons(Map<String, dynamic> json) {
  return getField(json, PropertyEnum.seasons).map((s) => SeasonModel.fromJson(s)).toList();
}

List getGenres(Map<String, dynamic> json) {
  return getField(json, PropertyEnum.genres).map((g) => getField(g, PropertyEnum.name)).toList();
}
