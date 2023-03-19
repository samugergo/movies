import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/base/display_model.dart';

fetchMovies(int page, int order, Function callback) async {
  try {
    var p = page + 1;
    var o = _getOrder(order);
    var response = await http.get(Uri.parse('http://192.168.1.8:8081/movies/$o?page=$p'));
    
    var json = jsonDecode(response.body);
    var list = json['results'].map((r) => DisplayModel.fromJson(r)).toList();

    callback(list);
  } catch (e) {
    print(e);
  }
}

fetchShows(int page, int order, Function callback) async {
  try {
    var p = page + 1;
    var o = _getOrder(order);
    var response = await http.get(Uri.parse('http://192.168.1.8:8081/series/$o?page=$p'));

    var json = jsonDecode(response.body);
    var list = json['results'].map((r) => DisplayModel.fromJson(r)).toList();

    callback(list);
  } catch (e) {
    print(e);
  }
}

_getOrder(order) {
  return order == 0 ? 'popular' : 'top-rated';
}