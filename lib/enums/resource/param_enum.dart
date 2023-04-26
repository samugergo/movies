// ignore_for_file: constant_identifier_names
enum ParamEnum {
  BASE_URL(value: 'baseUrl'), 
  API_KEY(value: 'apiKey'), 
  LANG(value: 'language'), 
  REGION(value: 'region'), 
  PAGE(value: 'page'),  
  QUERY(value: 'query');

  const ParamEnum({
    required this.value,
  });

  final String value;
}