// TODO(Use only one key do not need both of them)
enum TypeEnum {
  movie(value: 'movie', localeKey: 'movies'),
  show(value: 'tv', localeKey: 'shows'),
  person(value: 'person', localeKey: 'person');

  final String value;
  final String localeKey;

  const TypeEnum({
    required this.value,
    required this.localeKey,
  });

  static bool isMovie(TypeEnum value) {
    return value == movie;
  }

  static TypeEnum fromValue(String value) {
    return TypeEnum.values.firstWhere((element) => element.value == value);
  }

  static List<TypeEnum> catalogTypes() {
    return [TypeEnum.movie, TypeEnum.show];
  }
}