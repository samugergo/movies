import 'package:flutter/material.dart';
import 'package:movies/widgets/hidable_fab.dart';
import 'package:movies/widgets/main_app_bar.dart';
import 'package:provider/provider.dart'; 
import 'package:movies/enums/order_enum.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/pages/container.dart';
import 'package:movies/services/service.dart';
import 'package:movies/utils/common_util.dart';

void main() {
  Paint.enableDithering = true;
  runApp(MainApp());
}

class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Color(0xff292A37),
    // ));

    return ChangeNotifierProvider(
      create: (context) => MainAppState(),
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.transparent,
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Color(0xff2B2B38),
            modalElevation: 0
          )
        ),
        home: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 1],
              colors: [Color(0xff292A37), Color(0xff0F1018)],
              tileMode: TileMode.mirror
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              title: MainAppBar(),
              titleSpacing: 20,
              centerTitle: true,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: Color(0xff292A37),
            ),
            body: XContainer(
              controller: scrollController,
            ),
            floatingActionButton: HidableFab(
              controller: scrollController
            ),
          ),
        ),
      )
    );
  }
}

class MainAppState extends ChangeNotifier {
  List movies = [];
  List shows = [];
  int moviePage = 0;
  int showPage = 0;

  TypeEnum type = TypeEnum.movie;
  OrderEnum order = OrderEnum.popular;

  MainAppState() {
    loadMovies(setMovies);
  }

  // --- getter functions ---
  isEmptyByType(type) {
    switch (type) {
      case TypeEnum.movie:
        return movies.isEmpty;
      case TypeEnum.show:
        return shows.isEmpty;
    }
  }
  // --- setter functions ---
  setMovies(movies) {
    this.movies = chunkList(movies);
    moviePage = 1;
    notifyListeners();
  }
  setShows(shows) {
    this.shows = chunkList(shows);
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
  // --- update functions ---
  updateMovies(movies) {
    this.movies.addAll(chunkList(movies));
    moviePage++;
    notifyListeners();
  } 
  updateShows(shows) {
    this.shows.addAll(chunkList(shows));
    showPage++;
    notifyListeners();
  }
  // --- load fuctions ---
  loadMovies(callback) async {
    final list = await fetchMovies(moviePage, order);
    callback(list);
  }
  loadShows(callback) async {
    final list = await fetchShows(showPage, order);
    callback(list);
  }
  loadByOrder(order) async {
    moviePage = 0;
    showPage = 0;
    final m = await fetchMovies(moviePage, order);
    setMovies(m);
    final s = await fetchShows(showPage, order);
    setShows(s);
  }
  loadByType(type) {
    switch (type) {
      case TypeEnum.movie: 
        loadMovies(setMovies);
        break;
      case TypeEnum.show: 
        loadShows(setShows);
        break;
    }
  }
  loadMore() async {
    switch (type) {
      case TypeEnum.movie: 
        loadMovies(updateMovies);
        break;
      case TypeEnum.show: 
        loadShows(updateShows);
        break;
    }
  }
}