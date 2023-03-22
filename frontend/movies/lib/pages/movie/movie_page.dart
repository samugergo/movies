import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/common/providers_model.dart';
import 'package:movies/models/detailed/movie_detailed_model.dart';
import 'package:movies/services/service.dart';
import 'package:movies/widgets/containers/image_gradient_container.dart';
import 'package:movies/widgets/image.dart';
import 'package:movies/widgets/provider_section.dart';
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
  List? cast;
  List? recommendations;
  Image? coverImage;
  bool imageLoading = true;

  init() async {
    var m = await fetchById(widget.id, TypeEnum.movie);
    var p = await fetchProviders(widget.id, TypeEnum.movie);
    var c = await fetchCast(widget.id, TypeEnum.movie);
    var r = await fetchRecommendations(widget.id, TypeEnum.movie);

    preloadImage(m);

    setState(() {
      movie = m;
      providers = p;
      cast = c;
      recommendations = r;
    });
  }

  preloadImage(movie) {
    if(movie.cover == null || movie.cover == '') {
      setState(() {
        imageLoading = false;
      });
      return;
    }
    coverImage = Image.network(movie.cover);
    if(coverImage != null) {
      coverImage!.image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener(
          (info, call) {
            setState(() {
              imageLoading = false;
            });
          },
        ),
      );
    }
  }

  isLoading() {
    return movie == null 
      || providers == null 
      || cast == null 
      || recommendations == null 
      || imageLoading;
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
      isLoading() 
      ? ImageGradientContainer(
        image: null,
        children: [
          Center(
            child: LoadingAnimationWidget.fourRotatingDots(color: Colors.white, size: 50)
          ),
        ]
      )
      : ImageGradientContainer(
      image: coverImage,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              SizedBox(height: 150),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ResultCard(
                  image: movie!.image, 
                  title: movie!.title, 
                  release: movie!.release, 
                  percent: movie!.percent, 
                  raw: movie!.raw,
                  genres: movie!.genres,
                ),
              ),
              SizedBox(height: 10),
              ProviderSection(providers: providers),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Történet'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    Divider(color: Colors.white24),
                    Text(
                      movie!.description,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Szereplők'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    Divider(color: Colors.white24),
                    SizedBox(
                      height: 260,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: cast!.map((c) => 
                          SizedBox(
                            width: 125,
                            child: Card(
                              elevation: 0,
                              color: Colors.white10,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.white12, 
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  XImage(
                                    url: c.image, 
                                    width: 125, 
                                    height: 180, 
                                    radius: 10
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6, left: 6, right: 6),
                                    child: Text(
                                      c.name,
                                      style: TextStyle(
                                        fontSize: 12, 
                                        color: Colors.white
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: Text(
                                      c.role,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white30
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ).toList(),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ajánlott'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    Divider(color: Colors.white24),
                    SizedBox(
                      height: 180,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: recommendations!.map((e) => 
                          Padding(
                            padding: const EdgeInsets.only(right: 4, left: 4),
                            child: XImage(
                              url: e.image, 
                              width: 120, 
                              height: 180, 
                              radius: 10
                            ),
                          )
                        ).toList(),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}