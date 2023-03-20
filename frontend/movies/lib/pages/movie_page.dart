import 'package:flutter/material.dart';

class MoviePage extends StatefulWidget {

  final int id;

  MoviePage({
    super.key,
    required this.id
  });

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {

  @override
  void initState() {
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            
          ],
        ),
      ),
    );
  }
}