import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies/enums/order_enum.dart';

import '../models/base/display_model.dart';

fetchMovies(int page, OrderEnum order) async {
  try {
    var p = page + 1;
    var o = order.value;
    var response = await http.get(Uri.parse('http://192.168.1.8:8081/movies/$o?page=$p'));
    
    var json = jsonDecode(response.body);
    var list = json['results'].map((r) => DisplayModel.fromJson(r)).toList();

    return list;
  } catch (e) {
    print(e);
  }
}

fetchShows(int page, OrderEnum order) async {
  try {
    var p = page + 1;
    var o = order.value;
    var response = await http.get(Uri.parse('http://192.168.1.8:8081/series/$o?page=$p'));

    var json = jsonDecode(response.body);
    var list = json['results'].map((r) => DisplayModel.fromJson(r)).toList();

    return list;
  } catch (e) {
    print(e);
  }
}
