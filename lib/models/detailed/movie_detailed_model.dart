import 'package:movies/models/common/collection_model.dart';
import 'package:movies/models/detailed/detailed_model.dart';
import 'package:movies/utils/common_util.dart';

class MovieDetailedModel extends DetailedModel {
  final CollectionModel? collection;

  MovieDetailedModel(
    int id,
    String title,
    String release,
    double raw,
    String image,
    String cover,
    String description,
    List genres,
    int length,
    this.collection,
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
  

  factory MovieDetailedModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailedModel(
      json['id'], 
      getFirstNotNull([json['title'], json['original_title']]), 
      json['release_date'], 
      json['vote_average'].toDouble(),
      imageLink(json['poster_path']), 
      json['backdrop_path'] ?? '', 
      json['overview'], 
      json['genres'].map((g) => g['name']).toList(), 
      json['runtime'],
      json['belongs_to_collection'] != null 
        ? CollectionModel.fromJson(json['belongs_to_collection']) 
        : null, 
    );
  }
}
