import 'package:movies/models/common/collection_model.dart';
import 'package:movies/models/common/providers_model.dart';

class MovieDetailedModel {
  final int id;
  final String title;
  final String release;
  final String percent;
  final String image;
  final String cover;
  final String description;
  final List<String> genres;
  final Providers providers;
  final Collection collection;

  MovieDetailedModel({
    required this.id,
    required this.title,
    required this.release,
    required this.percent,
    required this.image,
    required this.cover,
    required this.description,
    required this.genres,
    required this.collection,
    required this.providers
  });

  factory MovieDetailedModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailedModel(
      id: json['id'], 
      title: json['title'], 
      release: json['release'], 
      percent: json['percent'], 
      image: json['image'], 
      cover: json['cover'], 
      description: json['description'], 
      genres: json['genres'].map((g) => g).toList(), 
      providers: Providers.fromJson(json['providers']),
      collection: Collection.fromJson(json['collection']), 
    );
  }
}
