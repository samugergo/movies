import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movies/enums/order_enum.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/base/list_response.dart';

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

search(int page, TypeEnum type, String query) async {
  try {
    var response = await http.get(
      Uri.parse(
        '$baseUrl/search/${type.value}?query=$query&page=${page + 1}&$params'
      )
    );

    var json = jsonDecode(response.body);
    print(json);
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

fetchMovieById(id) async {
  try {
    var response = await http.get(Uri.parse('http://192.168.1.8:8081/movies/details/$id'));

    var json = jsonDecode(response.body);
    var list = json['results'].map((r) => DisplayModel.fromJson(r)).toList();

    return ListResponse(
      list: list,
      page: json['page'],
      total: json['total_results'],
      pages: json['total_pages'],
    );
  } catch (e) {
    print(e);
  }
}
