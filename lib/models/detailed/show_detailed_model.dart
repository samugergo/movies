import 'package:movies/models/common/season_model.dart';
import 'package:movies/models/detailed/detailed_model.dart';
import 'package:movies/utils/common_util.dart';

class ShowDetailedModel extends DetailedModel {
  final List seasons;

  ShowDetailedModel(
    int id,
    String title,
    String release,
    double raw,
    String image,
    String cover,
    String description,
    List genres,
    int length,
    this.seasons,
  ) : super(
        id: id, 
        title: title, 
        release: release, 
        raw: raw, 
        image: image, 
        cover: cover,
        description: description, 
        genres: genres, 
        length: length
      );

  factory ShowDetailedModel.fromJson(Map<String, dynamic> json) {
    return ShowDetailedModel(
      json['id'],
      getFirstNotNull([json['name'], json['original_name']]), 
      json['first_air_date'],
      json['vote_average'].toDouble(),
      imageLink(json['poster_path']), 
      json['backdrop_path'] ?? '',
      json['overview'],
      json['genres'].map((g) => g['name']).toList(),
      episodeLength(json['episode_run_time']),
      json['seasons'].map((s) => SeasonModel.fromJson(s)).toList()
    );
  }

  static int episodeLength(list) {
    return list.isNotEmpty ? list[0] : 0;
  }
}