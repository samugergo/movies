enum PropertyEnum {
  id(key: 'id'),
  title(key: 'title'),
  name(key: 'name'),
  originalTitle(key: 'original_title'),
  originalName(key: 'original_name'),
  releaseDate(key: 'release_date'),
  firstAirDate(key: 'first_air_date'),
  percent(key: 'vote_average'),
  poster(key: 'poster_path'),
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
  description(key: 'overview'),
  parts(key: 'parts'),
  genres(key: 'genres'),
  length(key: 'runtime', defaultVal: 0),
  belongsToCollection(key: 'belongs_to_collection'),
  seasons(key: 'seasons'),
  knownFor(key: 'known_for_department'),
  gender(key: 'gender', defaultVal: 2),
  externalIds(key: 'external_ids'),
  results(key: 'results'),
  type(key: 'type'),
  site(key: 'site'),
  official(key: 'official'),
  trailerKey(key: 'key'),
  images(key: 'images'),
  credits(key: 'credits'),
  cast(key: 'cast'),
  backdrops(key: 'backdrops'),
  filePath(key: 'file_path'),
  videos(key: 'videos'),
  crew(key: 'crew'),
  ;

  const PropertyEnum({
    required this.key,
    this.defaultVal = ''
  });

  final String key;
  final dynamic defaultVal;

  static List<PropertyEnum> titleProperties = [title, name, originalTitle, originalName];
  static List<PropertyEnum> dateProperties = [releaseDate, firstAirDate];
}