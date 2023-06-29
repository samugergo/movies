import 'dart:convert';

import 'package:movies/api/parameter/path_parameter.dart';
import 'package:http/http.dart' as http;

class Resource {
  const Resource({
    required this.baseUrl,
    required this.apiKey,
  });

  final String baseUrl;
  final String apiKey;

  doApiCall(String endpoint, List<PathParameter> params) async {
    final url = _createUrl(endpoint, params);
    try {
      final response = await http.get(url);
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
    }
  }

  _createUrl(String endpoint, List<PathParameter> params) {
    if (params.isNotEmpty) {
      final paramsString =
          params.map((p) => p.toString()).reduce((value, element) => '$value&$element');
      return Uri.parse("$baseUrl/$endpoint?$paramsString&api_key=$apiKey");
    }
    return Uri.parse("$baseUrl/$endpoint?api_key=$apiKey");
  }
}
