import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/services/service.dart';
import 'package:movies/states/movie_state.dart';
import 'package:movies/utils/color_util.dart';
import 'package:movies/utils/common_util.dart';

class MovieCubit extends Cubit<MovieState>{
  MovieCubit(this.id) : super(MovieState()) {
    initModel();
    initProviders();
    // initCast();
    // initRecommendations();
  }

  final int id;

  initModel() async {
    final movie = await fetchById(id, TypeEnum.movie);
    state.model = movie;

    getColorFromImage(lowImageLink(movie.cover), setColor);
  }

  initProviders() async {
    final providers = await fetchProviders(id, TypeEnum.movie);
    state.providers = providers;
    // emit(state);
  }

  initCast() async {
    final cast = await fetchCast(id, TypeEnum.movie);
    state.cast = cast;
    emit(state);
  }

  initRecommendations() async {
    final recommendations = await fetchRecommendations(id, TypeEnum.movie);
    state.recommendations = recommendations;
    emit(state);
  }

  init() async {
    initModel();
    initProviders();
    initCast();
    initRecommendations();
  }

  setColor(color) {
    state.color = color;
    print(color);
    emit(state);
  }

  bool get isLoading => state.isLoadingf();
}