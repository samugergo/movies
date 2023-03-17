import 'package:movies/models/common/providers_model.dart';
import 'package:movies/models/common/season_model.dart';

class ShowDetailedModel {
  final int id;
  final String title;
  final String release;
  final String percent;
  final String image;
  final String cover;
  final String description;
  final List<String> genres;
  final Providers providers;
  final List<SeasonModel> seasons;

  ShowDetailedModel({
    required this.id,
    required this.title,
    required this.release,
    required this.percent,
    required this.image,
    required this.cover,
    required this.description,
    required this.genres,
    required this.providers,
    required this.seasons
  });

  factory ShowDetailedModel.fromJson(Map<String, dynamic> json) {
    return ShowDetailedModel(
      id: json['id'],
      title: json['title'],
      release: json['release'],
      percent: json['percent'],
      image: json['image'],
      cover: json['cover'],
      description: json['description'],
      genres: json['genres'],
      providers: Providers.fromJson(json['providers']),
      seasons: json['seasons'].map((s) => SeasonModel.fromJson(s)).toList()
    );
  }
}