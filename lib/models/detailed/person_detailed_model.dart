import 'package:movies/models/others/external_id_model.dart';

import '../../enums/property_enum.dart';
import '../../utils/json_util.dart';

class PersonDetailedModel {
  PersonDetailedModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.birthday,
      required this.biography,
      required this.externalIds});

  final int id;
  final String name;
  final String image;
  final String birthday;
  final String biography;
  final ExternalIdModel externalIds;

  factory PersonDetailedModel.fromJson(Map<String, dynamic> json) {
    return PersonDetailedModel(
        id: getField(json, PropertyEnum.id),
        name: getField(json, PropertyEnum.name),
        image: getImage(json, PropertyEnum.profile),
        birthday: getField(json, PropertyEnum.birthday),
        biography: getField(json, PropertyEnum.biography),
        externalIds: ExternalIdModel.fromJson(json[PropertyEnum.externalIds.key]));
  }
}
