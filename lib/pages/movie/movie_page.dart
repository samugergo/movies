import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/common/providers_model.dart';
import 'package:movies/models/detailed/movie_detailed_model.dart';
import 'package:movies/services/service.dart';
import 'package:movies/widgets/containers/image_gradient_container.dart';
import 'package:movies/widgets/my_image_app_bar.dart';
import 'package:movies/widgets/sections/provider_section.dart';
import 'package:movies/widgets/sections/cast_section.dart';
import 'package:movies/widgets/sections/recommended_section.dart';
import 'package:movies/widgets/sections/story_section.dart';

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
      statusBarColor: Color(0xff292A37),
    ));

    return isLoading() 
      ? ImageGradientContainer(
        image: null,
        children: [
          Center(
            child: LoadingAnimationWidget.fourRotatingDots(color: Colors.white, size: 50)
          ),
        ]
      )
      : Material(
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: MyImageAppBar(
                    poster: movie!.image, 
                    title: movie!.title, 
                    release: movie!.release, 
                    percent: movie!.percent, 
                    raw: movie!.raw,
                    genres: movie!.genres, 
                    cover: coverImage!
                  ),
                ),
              ];
            },
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.5, 1],
                  colors: [
                    Color(0xff292A37), 
                    Color(0xff0F1018)
                  ],
                  tileMode: TileMode.mirror
                ),
              ),
              child: Scaffold(
                body: SafeArea(
                  child: ListView(
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: ProviderSection(
                          providers: providers
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: StorySection(
                          description: movie!.description
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: CastSection(
                          cast: cast!
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: RecommendedSection(
                          recommendations: recommendations!
                        )
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                )
              )
            )
          ),
        ),
      );
  }
}