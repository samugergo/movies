import 'package:movies/converter/json_converters.dart';

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

  bool get isNotNull => facebookId != "" || instagramId != "" || twitterId != "" || imdbId !="";

  factory ExternalIdModel.fromJson(Map<String, dynamic> json) {
    return fromJsonExternalIdModel(json);
  }

  @override
  String toString() {
    return '$facebookId $instagramId $twitterId $imdbId';
  }
}