import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/common/providers_model.dart';
import 'package:movies/models/detailed/movie_detailed_model.dart';
import 'package:movies/services/service.dart';
import 'package:movies/widgets/containers/image_gradient_container.dart';
import 'package:movies/widgets/image.dart';
import 'package:movies/widgets/result_card.dart';

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
  Providers? providers;

  init() async {
    var m = await fetchById(widget.id, TypeEnum.movie);
    var p = await fetchProviders(widget.id, TypeEnum.movie);
    setState(() {
      movie = m;
      providers = p;
    });
  }

  getProvider() {
    if (providers == null || providers!.streaming == null) {
      return [];
    }
    return providers!.streaming?.map((e) => 
      Column(
        children: [
          XImage(
            url: e.image, 
            width: 50, 
            height: 50
          ),
          Text(
            e.title,
            style: TextStyle(
              color: Colors.white
            ),
          )
        ],
      )
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));

    return 
      movie != null 
      ? ImageGradientContainer(
      image: movie!.cover,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: ListView(
              children: [
                SizedBox(height: 150),
                ResultCard(
                  image: movie!.image, 
                  title: movie!.title, 
                  release: movie!.release, 
                  percent: movie!.percent, 
                  raw: movie!.raw
                ),
                ...getProvider(),
              ],
            ),
          ),
        ),
      ],
    )
    : SizedBox();
  }
}