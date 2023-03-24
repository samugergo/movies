import 'package:movies/models/common/collection_model.dart';
import 'package:movies/models/common/providers_model.dart';
import 'package:movies/utils/common_util.dart';

class MovieDetailedModel {
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
  // final Collection collection;

  MovieDetailedModel({
    required this.id,
    required this.title,
    required this.release,
    required this.percent,
    required this.raw,
    required this.image,
    required this.cover,
    required this.description,
    required this.genres,
    // required this.collection,
    // required this.providers
  });

  factory MovieDetailedModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailedModel(
      id: json['id'], 
      title: getFirstNotNull([json['title'], json['original_title']]), 
      release: json['release_date'], 
      percent: percentFormat(json['vote_average']), 
      raw: json['vote_average'].toDouble(),
      image: imageLink(json['poster_path']), 
      cover: json['backdrop_path'], 
      description: json['overview'], 
      genres: json['genres'].map((g) => g['name']).toList(), 
      // providers: Providers.fromJson(json['providers']),
      // collection: Collection.fromJson(json['collection']), 
    );
  }
}
