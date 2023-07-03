// ignore_for_file: constant_identifier_names
enum ParamEnum {
  BASE_URL(value: 'baseUrl'), 
  API_KEY(value: 'apiKey'), 
  LANG(value: 'language'), 
  REGION(value: 'region'), 
  PAGE(value: 'page'),  
  QUERY(value: 'query'),
  FACEBOOK_URL(value: 'FACEBOOK_URL'),
  INSTAGRAM_URL(value: 'INSTAGRAM_URL'),
  TWITTER_URL(value: 'TWITTER_URL'),
  IMDB_URL(value: 'IMDB_URL'),
  APPEND(value: 'append_to_response'),
  ;

  const ParamEnum({
    required this.value,
  });

  final String value;
}