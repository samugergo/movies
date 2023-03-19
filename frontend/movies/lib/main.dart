import 'package:flutter/material.dart';
import 'package:movies/pages/container.dart';
import 'package:movies/services/service.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  var movies = [];
  var shows = [];
  var moviePage = 0;
  var showPage = 0;
  // filters
  var order = 0;
  var type = 0;

  fetch(type) {
    if (type == 0) {
      if(movies.isEmpty) {
        fetchMovies(moviePage, updateMovies);
        moviePage++;
      }
    } else {
      if(shows.isEmpty) {
        fetchShows(showPage, updateShows);
        showPage++;
      }
    }
  }

  fetchMore(type) {
    if(type == 0) {
      fetchMovies(moviePage, updateMovies);
      moviePage++;
    } else {
      fetchShows(showPage, updateShows);
      showPage++;
    }
  }

  chunkList(list) {
    var chunks = [];
    int chunkSize = 2;
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(i, i+chunkSize > list.length ? list.length : i + chunkSize)); 
    }
    return chunks;
  }

  updateMovies(list) {
    setState(() {
      movies.addAll(chunkList(list));
    });
  }
  updateShows(list) {
    setState(() {
      shows.addAll(chunkList(list));
    });
  }
  updateType(type) {
    setState(() {
      if (type != this.type) {
        fetch(type);
      }
      this.type = type;
    });
  }
  updateOrder(order) {
    setState(() {
      this.order = order;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMovies(moviePage, updateMovies);
    moviePage++;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            stops: [0, 1],
            colors: [Color(0xff292A37), Color(0xff0F1018)],
          ),
        ),
        child: Scaffold(
          body: XContainer(
            type: type,
            order: order,
            updateOrder: updateOrder,
            updateType: updateType,
            loadMore: fetchMore,
            list: type == 0 ? movies : shows,
          ),
        ),
      ),
    );
  }
}