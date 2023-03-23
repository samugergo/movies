import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/common/providers_model.dart';
import 'package:movies/models/detailed/movie_detailed_model.dart';
import 'package:movies/services/service.dart';
import 'package:movies/widgets/containers/image_gradient_container.dart';
import 'package:movies/widgets/sections/provider_section.dart';
import 'package:movies/widgets/result_card.dart';
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
                child: StorySection(
                  description: movie!.description
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: CastSection(
                  cast: cast!
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: RecommendedSection(
                  recommendations: recommendations!
                )
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}