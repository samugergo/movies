import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movies/enums/order_enum.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/base/list_response.dart';
import 'package:movies/models/common/cast_model.dart';
import 'package:movies/models/common/providers_model.dart';
import 'package:movies/models/detailed/movie_detailed_model.dart';
import 'package:movies/models/detailed/show_detailed_model.dart';

import '../models/base/display_model.dart';

final apiKey = dotenv.env['API_KEY'];
final baseUrl = dotenv.env['BASE_URL'];
final lang = dotenv.env['LANG'];
final region = dotenv.env['REGION'];

final params = 'language=$lang&region=$region&api_key=$apiKey';

fetch(int page, TypeEnum type, OrderEnum order) async {
  try {
    var response = await http.get(
      Uri.parse(
        '$baseUrl/${type.value}/${order.value}?page=${page + 1}&$params'
      )
    );
    var json = jsonDecode(response.body);
    return json['results'].map((r) => DisplayModel.fromJson(r)).toList();
  } catch (e) {
    print(e);
  }
}

fetchById(int id, TypeEnum type) async {
  try {
    var response = await http.get(
      Uri.parse(
        '$baseUrl/${type.value}/$id?$params'
      )
    );
    var json = jsonDecode(response.body);
    return type == TypeEnum.movie ? MovieDetailedModel.fromJson(json) : ShowDetailedModel.fromJson(json);
  } catch (e) {
    print(e);
  }
}

fetchProviders(int id, TypeEnum type) async {
  try {
    var response = await http.get(
      Uri.parse(
        '$baseUrl/${type.value}/$id/watch/providers?$params'
      )
    );
    var json = jsonDecode(response.body);
    if(json["results"]["HU"] != null) {
      return Providers.fromJson(json["results"]["HU"]);
    }
    return Providers();
  } catch(e) {
    print(e);
  }
}

fetchCast(int id, TypeEnum type) async {
  try {
    var response = await http.get(
      Uri.parse(
        '$baseUrl/${type.value}/$id/credits?$params'
      )
    );
    var json = jsonDecode(response.body);
    if(json["cast"] != null) {
      return json['cast'].map((c) => CastModel.fromJson(c)).toList(); 
    }
    return [];
  } catch(e) {
    print(e);
  }
}

fetchRecommendations(int id, TypeEnum type) async {
  try {
    var response = await http.get(
      Uri.parse(
        '$baseUrl/${type.value}/$id/recommendations?$params'
      )
    );
    var json = jsonDecode(response.body);
    if(json["results"] != null) {
      return json['results'].map((c) => DisplayModel.fromJson(c)).toList(); 
    }
    return [];
  } catch(e) {
    print(e);
  }
}

search(int page, TypeEnum type, String query) async {
  try {
    var response = await http.get(
      Uri.parse(
        '$baseUrl/search/${type.value}?query=$query&page=${page + 1}&$params'
      )
    );

    var json = jsonDecode(response.body);
    return ListResponse(
      list: json['results'].map((r) => DisplayModel.fromJson(r)).toList(),
      page: json['page'],
      total: json['total_results'],
      pages: json['total_pages'],
    );
  } catch (e) {
    print(e);
  }
}
