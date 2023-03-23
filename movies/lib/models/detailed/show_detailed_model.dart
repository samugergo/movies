import 'package:movies/models/common/providers_model.dart';
import 'package:movies/models/common/season_model.dart';
import 'package:movies/utils/common_util.dart';

class ShowDetailedModel {
  final int id;
  final String title;
  final String release;
  final String percent;
  final double raw;
  final String image;
  final String cover;
  final String description;
  final List genres;
  // final Providers providers;
  // final List<SeasonModel> seasons;

  ShowDetailedModel({
    required this.id,
    required this.title,
    required this.release,
    required this.percent,
    required this.raw,
    required this.image,
    required this.cover,
    required this.description,
    required this.genres,
    // required this.providers,
    // required this.seasons
  });

  factory ShowDetailedModel.fromJson(Map<String, dynamic> json) {
    return ShowDetailedModel(
      id: json['id'],
      title: getFirstNotNull([json['name'], json['original_name']]), 
      release: json['first_air_date'],
      percent: percentFormat(json['vote_average']), 
      raw: json['vote_average'].toDouble(),
      image: imageLink(json['poster_path']), 
      cover: originalImageLink(json['backdrop_path']),
      description: json['overview'],
      genres: json['genres'].map((g) => g['name']).toList(), 
      // providers: Providers.fromJson(json['providers']),
      // seasons: json['seasons'].map((s) => SeasonModel.fromJson(s)).toList()
    );
  }
}