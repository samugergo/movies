import 'package:flutter/material.dart';
import 'package:movies/models/common/providers_model.dart';
import 'package:movies/models/detailed/movie_detailed_model.dart';

class MovieState {
  MovieDetailedModel? model;
  Providers? providers;
  List? cast;
  List? recommendations;
  Color? color;
  Image? cover;
  
  bool get isLoading => model == null 
    || providers == null
    // || cast == null 
    // || recommendations == null
    || color == null;

  bool isLoadingf() {
    print(model);
    print(providers);
    print(color);
    return model == null 
    || providers == null
    // || cast == null 
    // || recommendations == null
    || color == null;
  }
}