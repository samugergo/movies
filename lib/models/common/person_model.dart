import 'package:movies/converter/json_converters.dart';

class PersonModel {
  final int id;
  final String name;
  final String biography;
  final String birthday;
  final String birthPlace;
  final String image;

  PersonModel({
    required this.id,
    required this.name,
    required this.biography,
    required this.birthday,
    required this.birthPlace,
    required this.image,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return fromJsonPersonModel(json);
  }
}