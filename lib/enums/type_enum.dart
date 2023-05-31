enum TypeEnum {
  movie(title: 'Filmek', value: 'movie', localeKey: 'movies'),
  show(title: 'Sorozatok', value: 'tv', localeKey: 'shows');

  final String title; 
  final String value;
  final String localeKey;

  const TypeEnum({
    required this.title,
    required this.value,
    required this.localeKey,
  });

  static bool isMovie(TypeEnum value) {
    return value == movie;
  }

  static TypeEnum fromValue(String value) {
    return TypeEnum.values.firstWhere((element) => element.value == value);
  }

  static List<String> titles() {
    return TypeEnum.values.map((e) => e.title).toList();
  }
}