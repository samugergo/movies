import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/base/display_model.dart';

fetchMovies(int page, Function callback) async {
  try {
    var p = page + 1;
    var response = await http.get(Uri.parse('http://192.168.1.8:8081/movies/popular?page=$p'));
    
    var json = jsonDecode(response.body);
    var list = json['results'].map((r) => DisplayModel.fromJson(r)).toList();

    callback(list);
  } catch (e) {
    print(e);
  }
}

fetchShows(int page, Function callback) async {
  try {
    var p = page + 1;
    var response = await http.get(Uri.parse('http://192.168.1.8:8081/series/popular?page=$p'));

    var json = jsonDecode(response.body);
    var list = json['results'].map((r) => DisplayModel.fromJson(r)).toList();

    callback(list);
  } catch (e) {
    print(e);
  }
}