import 'package:flutter/material.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/detailed/movie_detailed_model.dart';
import 'package:movies/services/service.dart';

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
  MovieDetailedModel? movie;

  init() async {
    var m = await fetchById(widget.id, TypeEnum.movie);
    setState(() {
      movie = m;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return 
      movie != null 
      ? Container(
      decoration: BoxDecoration(
        // image: DecorationImage(
        //   image: NetworkImage(movie!.cover),
        //   alignment: Alignment.topCenter
        // ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 1],
          colors: [Color(0xff292A37), Color(0xff0F1018)],
          tileMode: TileMode.mirror
        ),
      ),
      child: Scaffold(
        body: 
          Stack(
            children: [
              ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.transparent],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: Image.network(
                  movie!.cover,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  children: [
                    SizedBox(height: 180),
                    Text(
                      movie!.title,
                      style: TextStyle(
                        color:Colors.white
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    )
    : SizedBox();
  }
}