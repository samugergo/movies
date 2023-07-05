import '../../others/cast_model.dart';
import '../../others/external_id_model.dart';

class DetailedModel {
  final int id;
  final String title;
  final String release;
  final double raw;
  final String image;
  final String cover;
  final String description;
  final String trailer;
  final int length;
  final List cast;
  final List genres;
  final List images;
  final CastModel? director;
  final ExternalIdModel externalIds;

  DetailedModel(
      {required this.id,
      required this.title,
      required this.release,
      required this.raw,
      required this.image,
      required this.cover,
      required this.description,
      required this.genres,
      required this.length,
      required this.externalIds,
      required this.cast,
      required this.director,
      required this.trailer,
      required this.images});
}
