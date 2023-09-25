import 'package:movies/api/parameter/path_parameter.dart';
import 'package:movies/api/resource/moviedb_resource.dart';
import 'package:movies/enums/order_enum.dart';
import 'package:movies/enums/resource/param_enum.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/base/list_response.dart';
import 'package:movies/models/detailed/person_detailed_model.dart';
import 'package:movies/models/others/cast_model.dart';
import 'package:movies/models/others/external_id_model.dart';
import 'package:movies/models/others/providers_model.dart';
import 'package:movies/models/detailed/collection_detailed_model.dart';
import 'package:movies/models/detailed/movie_detailed_model.dart';
import 'package:movies/models/detailed/show_detailed_model.dart';

import '../models/base/display_model.dart';
import '../models/base/display_person_model.dart';
import '../utils/common_util.dart';

final resource = MovieDBResource();

get(int page, TypeEnum type, OrderEnum order) async {
  var result = await resource.doApiCall(
      '${type.value}/${order.value}', [PathParameter(key: ParamEnum.PAGE, value: page + 1)]);
  return result['results'].map((r) => DisplayModel.fromJson(r, type)).toList();
}

getById(int id, TypeEnum type) async {
  var result = await resource.doApiCall('${type.value}/$id', [
    PathParameter(key: ParamEnum.APPEND, value: 'images,external_ids,videos,credits'),
    PathParameter(key: ParamEnum.IMAGE_LANG, value: 'en,hu')
  ]);
  return TypeEnum.isMovie(type)
      ? MovieDetailedModel.fromJson(result)
      : ShowDetailedModel.fromJson(result);
}

getProviders(int id, TypeEnum type) async {
  var result = await resource.doApiCall('${type.value}/$id/watch/providers', []);
  if (result["results"]["HU"] != null) {
    return Providers.fromJson(result["results"]["HU"]);
  }
  return Providers();
}

getRecommendations(int id, TypeEnum type) async {
  var result = await resource.doApiCall('${type.value}/$id/recommendations', []);
  if (result["results"] != null) {
    return result['results'].map((c) => DisplayModel.fromJson(c, type)).toList();
  }
  return [];
}

getSimilar(int id, TypeEnum type) async {
  var result = await resource.doApiCall('${type.value}/$id/similar', []);
  if (result["results"] != null) {
    return result['results'].map((c) => DisplayModel.fromJson(c, type)).toList();
  }
  return [];
}

getCollection(int id) async {
  var result = await resource.doApiCall('collection/$id', []);
  return CollectionDetailedModel.fromJson(result);
}

getPerform(int id, TypeEnum type) async {
  var result = await resource.doApiCall('person/$id/${type.value}_credits', []);
  return result['cast'].map((r) => DisplayModel.fromJson(r, type)).toList();
}

getPerson(int id) async {
  var result = await resource
      .doApiCall('/person/$id', [PathParameter(key: ParamEnum.APPEND, value: 'external_ids')]);
  return PersonDetailedModel.fromJson(result);
}

search(int page, TypeEnum type, String query) async {
  if (type == TypeEnum.person) {
    return searchPerson(page, query);
  }

  var result = await resource.doApiCall('search/${type.value}', [
    PathParameter(key: ParamEnum.QUERY, value: query),
    PathParameter(key: ParamEnum.PAGE, value: page + 1)
  ]);
  return ListResponse(
      list: result['results'].map((r) => DisplayModel.fromJson(r, type)).toList(),
      page: result['page'],
      total: result['total_results'],
      pages: result['total_pages']);
}

searchPerson(int page, String query) async {
  var result = await resource.doApiCall('search/person', [
    PathParameter(key: ParamEnum.QUERY, value: query),
    PathParameter(key: ParamEnum.PAGE, value: page + 1)
  ]);
  return ListResponse(
      list: result['results'].map((r) => DisplayPersonModel.fromJson(r)).toList(),
      page: result['page'],
      total: result['total_results'],
      pages: result['total_pages']);
}
