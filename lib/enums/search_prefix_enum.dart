import 'package:movies/enums/type_enum.dart';

enum SearchPrefixEnum {
  movie(prefix: 'm', type: TypeEnum.movie),
  show(prefix: 's', type: TypeEnum.show),
  person(prefix: 'p', type: TypeEnum.person);

  const SearchPrefixEnum({required this.prefix, required this.type});

  final String prefix;
  final TypeEnum type;

  static TypeEnum? fromValue(String value) {
    if (SearchPrefixEnum.values.map((e) => e.prefix).contains(value)) {
      return SearchPrefixEnum.values.firstWhere((element) => element.prefix == value).type;
    }
    return null;
  }
}
