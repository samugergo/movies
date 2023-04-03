import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/widgets/buttons/hidable_fab.dart';
import 'package:movies/widgets/appbars/main_app_bar.dart';
import 'package:movies/widgets/containers/gradient_container.dart';
import 'package:provider/provider.dart'; 
import 'package:movies/enums/order_enum.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/pages/home/home_page.dart';
import 'package:movies/services/service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  Paint.enableDithering = true;

  await dotenv.load(fileName: ".env");

  runApp(MainApp());
}

class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return ChangeNotifierProvider(
      create: (context) => MainAppState(),
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.transparent,
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Color(0xff2B2B38),
            modalElevation: 0
          ),
        ),
        home: GradientContainer(
          child: Scaffold(
            appBar: AppBar(
              title: MainAppBar(),
              titleSpacing: 20,
              centerTitle: true,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: Color(0xff292A37),
            ),
            body: HomePage(
              controller: scrollController,
            ),
            floatingActionButton: HidableFab(
              controller: scrollController
            ),
          ),
        ),
      ),
    );
  }
}

class MainAppState extends ChangeNotifier {
  List movies = [];
  List shows = [];
  int moviePage = 0;
  int showPage = 0;
  int itemCount = 3;

  TypeEnum type = TypeEnum.movie;
  OrderEnum order = OrderEnum.popular;

  MainAppState() {
    loadMovies(setMovies);
    loadPreferences();
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
    this.movies = movies;
    moviePage = 2;
    notifyListeners();
  }
  setShows(shows) {
    this.shows = shows;
    showPage = 2;
    notifyListeners();
  }
  setType(type) {
    this.type = type;
    var list = type == TypeEnum.movie ? movies : shows;
    if(list.isNotEmpty) {
      if(type == TypeEnum.movie) {
        setMovies(list.sublist(0, 40));
      } else {
        setShows(list.sublist(0, 40));
      }
    }
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
  // --- load fuctions ---
  loadMovies(callback) async {
    final list1 = await fetch(moviePage, type, order);
    final list2 = await fetch(++moviePage, type, order);
    moviePage++;
    list1.addAll(list2);
    callback(list1);
  }
  loadShows(callback) async {
    final list1 = await fetch(showPage, type, order);
    final list2 = await fetch(++showPage, type, order);
    showPage++;
    list1.addAll(list2);
    callback(list1);
  }
  loadByOrder(order) async {
    moviePage = 0;
    showPage = 0;
    final m = await fetch(moviePage, TypeEnum.movie, order);
    final m2 = await fetch(++moviePage, TypeEnum.movie, order);
    m.addAll(m2);
    setMovies(m);
    final s = await fetch(showPage, TypeEnum.show, order);
    final s2 = await fetch(++showPage, TypeEnum.show, order);
    s.addAll(s2);
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
  loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final ic = prefs.get('itemCount');
    setItemCount(ic ?? 3);
  }
}