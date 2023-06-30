import 'package:movies/enums/gender_enum.dart';

import '../../enums/property_enum.dart';
import '../../utils/json_util.dart';

class DisplayPersonModel {
  DisplayPersonModel(
      {required this.id,
      required this.name,
      required this.knownFor,
      required this.image,
      required this.gender});

  final int id;
  final String name;
  final String knownFor;
  final String image;
  final GenderEnum gender;

  factory DisplayPersonModel.fromJson(Map<String, dynamic> json) {
    return DisplayPersonModel(
        id: getField(json, PropertyEnum.id),
        name: getField(json, PropertyEnum.name),
        knownFor: getField(json, PropertyEnum.knownFor),
        image: getImage(json, PropertyEnum.profile),
        gender: GenderEnum.fromValue(getField(json, PropertyEnum.gender)));
  }
}
