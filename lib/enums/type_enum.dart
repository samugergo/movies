enum TypeEnum {
  movie(title: 'Filmek', value: 'movie'),
  show(title: 'Sorozatok', value: 'tv');

  final String title; 
  final String value;

  const TypeEnum({
    required this.title,
    required this.value,
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