import 'package:movies/utils/json_util.dart';
import 'package:movies/enums/type_enum.dart';

import '../../enums/property_enum.dart';

class DisplayModel implements Comparable<DisplayModel> {
  final int id;
  final String title;
  final String release;
  final double percent;
  final String image;
  final String cover;
  final String tagline;
  final TypeEnum type;

  DisplayModel(
      {required this.id,
      required this.title,
      required this.release,
      required this.percent,
      required this.image,
      required this.cover,
      required this.tagline,
      required this.type});

  factory DisplayModel.fromJson(Map<String, dynamic> json, TypeEnum type) {
    return DisplayModel(
        id: getField(json, PropertyEnum.id),
        percent: getFieldDouble(json, PropertyEnum.percent),
        title: getFieldList(json, PropertyEnum.titleProperties),
        release: getFieldList(json, PropertyEnum.dateProperties),
        image: getImage(json, PropertyEnum.poster),
        cover: getField(json, PropertyEnum.cover),
        tagline: getField(json, PropertyEnum.tagline),
        type: type);
  }

  @override
  String toString() {
    return '$id $title $release';
  }

  @override
  int compareTo(DisplayModel other) {
    return release.compareTo(other.release);
  }
}
