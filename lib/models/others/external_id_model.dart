import 'package:movies/utils/json_util.dart';

import '../../enums/property_enum.dart';

class ExternalIdModel {
  final String facebookId;
  final String instagramId;
  final String twitterId;
  final String imdbId;

  ExternalIdModel({
    required this.facebookId,
    required this.instagramId,
    required this.twitterId,
    required this.imdbId,
  });

  bool get isNotNull => facebookId != "" || instagramId != "" || twitterId != "" || imdbId != "";

  factory ExternalIdModel.fromJson(Map<String, dynamic> json) {
    return ExternalIdModel(
        facebookId: getField(json, PropertyEnum.facebookId),
        instagramId: getField(json, PropertyEnum.instagramId),
        twitterId: getField(json, PropertyEnum.twitterId),
        imdbId: getField(json, PropertyEnum.imdbId));
  }

  @override
  String toString() {
    return '$facebookId $instagramId $twitterId $imdbId';
  }
}
