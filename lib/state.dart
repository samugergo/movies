import 'package:flutter/material.dart';
import 'package:movies/enums/order_enum.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/services/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  List movies = [];
  List shows = [];
  
  List popularMovies = [];
  List upcomingMovies = [];
  List popularShows = [];
  List upcomingShows = [];
  List catalogList = [];

  int catalogPage = 0;
  int moviePage = 0;
  int showPage = 0;
  int itemCount = 3;
  int currentPage = 0;

  TypeEnum type = TypeEnum.movie;
  OrderEnum order = OrderEnum.popular;

  AppState() {
    init();
    loadPreferences();
  }

  init() async {
    // load popular movies
    await loadMovies(
      order: OrderEnum.popular,
      callback: setPopularMovies
    );
    // load upcoming movies
    loadMovies(
      order: OrderEnum.upcoming,
      callback: setUpcomingMovies
    );
    // load popular series
    loadShows(
      order: OrderEnum.popular,
      callback: setPopularShows
    );
    // load upcoming series
    loadShows(
      order: OrderEnum.topRated,
      callback: setUpcomingShows
    );
    loadCatalog(TypeEnum.movie, OrderEnum.popular);
    // setCatalogList(popularMovies);
  }

  /// Check if the home page finished loading
  /// 
  isLoading() {
    return popularMovies.isEmpty
      || upcomingMovies.isEmpty
      || popularShows.isEmpty;
  }

  void setCurrentPage(int index) {
    currentPage = index;
    notifyListeners();
  }

  /// Set a list of movies to movies list
  /// [movies] the list to set
  /// 
  setMovies(movies) {
    this.movies = movies;
    moviePage = 1;
    notifyListeners();
  }

  setPopularMovies(List popularMovies) {
    this.popularMovies = popularMovies;
    notifyListeners();
  }

  setUpcomingMovies(List upcomingMovies) {
    this.upcomingMovies = upcomingMovies;
    notifyListeners();
  }

  setPopularShows(List popularShows) {
    this.popularShows = popularShows;
    notifyListeners();
  }

  setUpcomingShows(List upcomingShows) {
    this.upcomingShows = upcomingShows;
    notifyListeners();
  }

  setCatalogList(List catalogList) {
    this.catalogList = catalogList;
    catalogPage = 1;
    notifyListeners();
  }

  setShows(shows) {
    this.shows = shows;
    showPage = 1;
    notifyListeners();
  }
  setType(type) {
    this.type = type;
    notifyListeners();
  }
  setOrder(order) {
    this.order = order;
    notifyListeners();
  }
  setItemCount(itemCount) async {
    this.itemCount = itemCount;
    
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('itemCount', itemCount);

    notifyListeners();
  }
  // --- update functions ---
  updateMovies(movies) {
    this.movies.addAll(movies);
    moviePage++;
    notifyListeners();
  } 
  updateShows(shows) {
    this.shows.addAll(shows);
    showPage++;
    notifyListeners();
  }
  updateCatalog(catalog) {
    catalogList.addAll(catalog);
    catalogPage++;
    notifyListeners();
  }

  // --- load fuctions ---

  /// Load movies from the api
  /// 
  /// [order] is the order of the movies
  /// [callback] is a function to call when the movies are loaded
  /// 
  @protected
  loadMovies({
    order,
    callback,
    page = 0,
  }) async {
    final list = await fetch(page, TypeEnum.movie, order);
    callback(list);
  }

  /// Load series from the api
  /// 
  /// [order] is the order of the series
  /// [callback] is a function to call when the series are loaded
  /// 
  @protected
  loadShows({
    order,
    callback,
  }) async {
    final list = await fetch(0, TypeEnum.show, order);
    callback(list);
  }

  /// Load the preferences from disk
  /// 
  loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final ic = prefs.get('itemCount');
    setItemCount(ic ?? 3);
  }

  loadCatalog2(OrderEnum order) async {
    loadMovies(
      order: OrderEnum.popular,
      callback: setCatalogList
    );
    // switch (order) {
    //   case OrderEnum.popular: 
    //     // TODO: Handle this case.
    //     break;
    //   case OrderEnum.topRated:
    //     // TODO: Handle this case.
    //     break;
    //   case OrderEnum.upcoming:
    //     // TODO: Handle this case.
    //     break;
    //   case OrderEnum.onTheAir:
    //     // TODO: Handle this case.
    //     break;
    // }
  }

  loadCatalogMore() async {
    loadMovies(
      order: OrderEnum.popular,
      callback: updateCatalog,
      page: catalogPage,
    );
  }

  loadCatalog(TypeEnum type, OrderEnum order) async {
    final list = await fetch(catalogPage, type, order);
    updateCatalog(list);
  }

  resetCatalog() {
    catalogList.clear();
    catalogPage = 0;
    notifyListeners();
  }

  // loadByOrder(order) async {
  //   moviePage = 0;
  //   showPage = 0;
  //   final m = await fetch(moviePage, TypeEnum.movie, order);
  //   setMovies(m);
  //   final s = await fetch(showPage, TypeEnum.show, order);
  //   setShows(s);
  // }
  // loadByType(type) {
  //   switch (type) {
  //     case TypeEnum.movie: 
  //       loadMovies(setMovies);
  //       break;
  //     case TypeEnum.show: 
  //       loadShows(setShows);
  //       break;
  //   }
  // }
  // loadMore() async {
  //   switch (type) {
  //     case TypeEnum.movie: 
  //       loadMovies(updateMovies);
  //       break;
  //     case TypeEnum.show: 
  //       loadShows(updateShows);
  //       break;
  //   }
  // }
}