import 'package:movies/api/parameter/path_parameter.dart';
import 'package:movies/api/resource/moviedb_resource.dart';
import 'package:movies/enums/order_enum.dart';
import 'package:movies/enums/resource/param_enum.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/base/list_response.dart';
import 'package:movies/models/common/cast_model.dart';
import 'package:movies/models/common/external_id_model.dart';
import 'package:movies/models/common/providers_model.dart';
import 'package:movies/models/detailed/collection_detailed_model.dart';
import 'package:movies/models/detailed/movie_detailed_model.dart';
import 'package:movies/models/detailed/show_detailed_model.dart';

import '../models/base/display_model.dart';
import '../utils/common_util.dart';

final resource = MovieDBResource();

fetch(int page, TypeEnum type, OrderEnum order) async {
  var result = await resource.doApiCall('${type.value}/${order.value}', [
    PathParameter(key: ParamEnum.PAGE, value: page + 1),
  ]);
  return result['results'].map((r) => DisplayModel.fromJson(r, type)).toList();
}

fetchById(int id, TypeEnum type) async {
  var result = await resource.doApiCall('${type.value}/$id', []);
  return TypeEnum.isMovie(type) ? MovieDetailedModel.fromJson(result) : ShowDetailedModel.fromJson(result);
}

fetchProviders(int id, TypeEnum type) async {
  var result = await resource.doApiCall('${type.value}/$id/watch/providers', []);
  if(result["results"]["HU"] != null) {
    return Providers.fromJson(result["results"]["HU"]);
  }
  return Providers();
}

fetchCast(int id, TypeEnum type) async {
  var result = await resource.doApiCall('${type.value}/$id/credits', []);
  if(result["cast"] != null) {
    return sublist(result['cast'].map((c) => CastModel.fromJson(c)).toList(), 10); 
  }
  return [];
}

fetchRecommendations(int id, TypeEnum type) async {
  var result = await resource.doApiCall('${type.value}/$id/recommendations', []);
  if(result["results"] != null) {
    return result['results'].map((c) => DisplayModel.fromJson(c, type)).toList(); 
  }
  return [];
}

fetchSimilar(int id, TypeEnum type) async {
  var result = await resource.doApiCall('${type.value}/$id/similar', []);
  if(result["results"] != null) {
    return result['results'].map((c) => DisplayModel.fromJson(c, type)).toList(); 
  }
  return [];
}

fetchCollection(int id) async {
  var result = await resource.doApiCall('collection/$id', []);
  return CollectionDetailedModel.fromJson(result);
}

fetchPerform(int id, String type) async {
  var result = await resource.doApiCall('person/$id/${type}_credits', []);
  return result['cast'].map((r) => DisplayModel.fromJson(r, TypeEnum.fromValue(type))).toList();
}

fetchExternalIds(int id, TypeEnum type) async {
  var result = await resource.doApiCall('${type.value}/$id/external_ids', []);
  return ExternalIdModel.fromJson(result);
}

fetchImages(int id, TypeEnum type) async {
  var result = await resource.doApiCallOnlyApiKey('${type.value}/$id/images', []);
  if (result['backdrops'] != null && result['backdrops'].isNotEmpty) {
    return sublist(result['backdrops'], 5).map((e) => e['file_path']).toList();
  }
  return [];
}

fetchTrailer(int id, TypeEnum type) async {
  var result = await resource.doApiCall('${type.value}/$id/videos', []);
  if (result['results'].isNotEmpty) {
    var trailer = result['results'].firstWhere((t) => t['type'] == 'Trailer' && t['official'] && t['site'] == 'YouTube', orElse: () => null);
    if (trailer == null) {
      trailer = result['results'].firstWhere((t) => t['type'] == 'Trailer' && t['site'] == 'YouTube', orElse: () => null);
      return trailer != null ? trailer['key'] : '';
    }
    return trailer['key'];
  }
  return '';
}

search(int page, TypeEnum type, String query) async {
  var result = await resource.doApiCall('search/${type.value}', [
    PathParameter(key: ParamEnum.QUERY, value: query),
    PathParameter(key: ParamEnum.PAGE, value: page + 1),
  ]);
  return ListResponse(
    list: result['results'].map((r) => DisplayModel.fromJson(r, type)).toList(),
    page: result['page'],
    total: result['total_results'],
    pages: result['total_pages'],
  );
}
