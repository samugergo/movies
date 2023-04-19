import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movies/api/parameter/path_parameter.dart';
import 'package:movies/api/resource/moviedb_resource.dart';
import 'package:movies/enums/order_enum.dart';
import 'package:movies/enums/resource/param_enum.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/base/list_response.dart';
import 'package:movies/models/common/cast_model.dart';
import 'package:movies/models/common/person_model.dart';
import 'package:movies/models/common/providers_model.dart';
import 'package:movies/models/detailed/collection_detailed_model.dart';
import 'package:movies/models/detailed/movie_detailed_model.dart';
import 'package:movies/models/detailed/show_detailed_model.dart';

import '../models/base/display_model.dart';

final apiKey = dotenv.env['API_KEY'];
final baseUrl = dotenv.env['BASE_URL'];
final lang = dotenv.env['LANG'];
final region = dotenv.env['REGION'];

final params = 'language=$lang&region=$region&api_key=$apiKey';

final resource = MovieDBResource();

fetch(int page, TypeEnum type, OrderEnum order) async {
  var result = await resource.doApiCall('${type.value}/${order.value}', [
    PathParameter(key: ParamEnum.PAGE, value: page + 1),
  ]);
  return result['results'].map((r) => DisplayModel.fromJson(r)).toList();
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
    return result['cast'].map((c) => CastModel.fromJson(c)).toList(); 
  }
  return [];
}

fetchRecommendations(int id, TypeEnum type) async {
  var result = await resource.doApiCall('${type.value}/$id/recommendations', []);
  if(result["results"] != null) {
    return result['results'].map((c) => DisplayModel.fromJson(c)).toList(); 
  }
  return [];
}

fetchSimilar(int id, TypeEnum type) async {
  var result = await resource.doApiCall('${type.value}/$id/similar', []);
  if(result["results"] != null) {
    return result['results'].map((c) => DisplayModel.fromJson(c)).toList(); 
  }
  return [];
}

fetchCollection(int id) async {
  var result = await resource.doApiCall('collection/$id', []);
  return CollectionDetailedModel.fromJson(result);
}

fetchPersonById(int id) async {
  var result = await resource.doApiCall('person/$id', []);
  return PersonModel.fromJson(result);
}

fetchPerform(int id, String type) async {
  var result = await resource.doApiCall('person/$id/${type}_credits', []);
  return result['cast'].map((r) => DisplayModel.fromJson(r)).toList();
}

search(int page, TypeEnum type, String query) async {
  var result = await resource.doApiCall('search/${type.value}', [
    PathParameter(key: ParamEnum.QUERY, value: query),
    PathParameter(key: ParamEnum.PAGE, value: page + 1),
  ]);
  return ListResponse(
    list: result['results'].map((r) => DisplayModel.fromJson(r)).toList(),
    page: result['page'],
    total: result['total_results'],
    pages: result['total_pages'],
  );
}
