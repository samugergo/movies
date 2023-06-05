import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/base/display_model.dart';
import 'package:movies/models/common/cast_model.dart';
import 'package:movies/models/common/collection_model.dart';
import 'package:movies/models/common/external_id_model.dart';
import 'package:movies/models/common/providers_model.dart';
import 'package:movies/models/common/season_model.dart';
import 'package:movies/utils/common_util.dart';

T getField<T>(Map<String, dynamic> json, PropertyEnum prop) {
  return json[prop.key] ?? '';
}

T getFieldList<T>(Map<String, dynamic> json, List<PropertyEnum> props) {
  final args = props.map((e) => json[e.key]).toList();
  return getFirstNotNull(args);
}

String getImage(Map<String, dynamic> json, PropertyEnum prop) {
  final image = json[prop.key];
  if(image != null) {
    return imageLink(image);
  }
  return '';
}

double getDoubleField(Map<String, dynamic> json, PropertyEnum prop) {
  return json[prop.key].toDouble();
}

DisplayModel fromJsonDisplayModel(Map<String, dynamic> json, TypeEnum type) {
  return DisplayModel(
    id: getField(json, PropertyEnum.id), 
    percent: getDoubleField(json, PropertyEnum.percent), 
    title: getFieldList(json, PropertyEnum.titleProperties), 
    release: getFieldList(json, PropertyEnum.dateProperties), 
    image: getImage(json, PropertyEnum.image), 
    cover: getField(json, PropertyEnum.cover),
    tagline: getField(json, PropertyEnum.tagline),
    type: type
  );
}

CastModel fromJsonCastModel(Map<String, dynamic> json) {
  return CastModel(
    id: getField(json, PropertyEnum.id),
    name: getField(json, PropertyEnum.name),
    role: getField(json, PropertyEnum.role),
    image: getImage(json, PropertyEnum.profile),
  );
}

CollectionModel fromJsonCollectionModel(Map<String, dynamic> json) {
  return CollectionModel(
    id: getField(json, PropertyEnum.id), 
    title: getField(json, PropertyEnum.name), 
    image: getImage(json, PropertyEnum.image), 
    cover: getField(json, PropertyEnum.cover),
  );
}

Providers fromJsonProvidersModel(Map<String, dynamic> json) {
  providerFromJson(p) => Provider(
    id: getField(p, PropertyEnum.providerId), 
    title: getField(p, PropertyEnum.providerName), 
    image: getImage(p, PropertyEnum.logo)
  );

  return Providers(
    rent: json[PropertyEnum.rent.key]?.map((e) => providerFromJson(e)).toList(),
    buy: json[PropertyEnum.buy.key]?.map((e) => providerFromJson(e)).toList(),
    streaming: json[PropertyEnum.streaming.key]?.map((e) => providerFromJson(e)).toList(),
  );
}

SeasonModel fromJsonSeasonModel(Map<String, dynamic> json) {
  return SeasonModel(
    id: getField(json, PropertyEnum.id), 
    title: getField(json, PropertyEnum.name), 
    image: getImage(json, PropertyEnum.image), 
    seasonNumber: getField(json, PropertyEnum.seasonNumber),
  );
}

ExternalIdModel fromJsonExternalIdModel(Map<String, dynamic> json) {
  return ExternalIdModel(
    facebookId: getField(json, PropertyEnum.facebookId),
    instagramId: getField(json, PropertyEnum.instagramId),
    twitterId: getField(json, PropertyEnum.twitterId),
    imdbId: getField(json, PropertyEnum.imdbId),
  );
}

enum PropertyEnum {
  id(key: 'id'), 
  title(key: 'title'), 
  name(key: 'name'), 
  originalTitle(key: 'original_title'), 
  originalName(key: 'original_name'),
  releaseDate(key: 'release_date'),
  firstAirDate(key: 'first_air_date'),
  percent(key: 'vote_average'),
  image(key: 'poster_path'),
  cover(key: 'backdrop_path'),
  profile(key: 'profile_path'),
  role(key: 'character'),
  biography(key: 'biography'),
  birthday(key: 'birthday'),
  placeOfBirth(key: 'place_of_birth'),
  providerId(key: 'provider_id'),
  providerName(key: 'provider_name'),
  logo(key: 'logo_path'),
  rent(key: 'rent'),
  buy(key: 'buy'),
  streaming(key: 'flatrate'),
  seasonNumber(key: 'season_number'),
  tagline(key: 'tagline'),
  facebookId(key: 'facebook_id'),
  instagramId(key: 'instagram_id'),
  twitterId(key: 'twitter_id'),
  imdbId(key: 'imdb_id'),
  ;
  
  const PropertyEnum({
    required this.key,
  });

  final String key;

  static List<PropertyEnum> titleProperties = [title, name, originalTitle, originalName];
  static List<PropertyEnum> dateProperties = [releaseDate, firstAirDate];
}