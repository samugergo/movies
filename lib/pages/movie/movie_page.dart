import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/common/providers_model.dart';
import 'package:movies/models/detailed/movie_detailed_model.dart';
import 'package:movies/services/service.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/widgets/loaders/color_loader.dart';
import 'package:movies/widgets/containers/gradient_container.dart';
import 'package:movies/widgets/loaders/loader.dart';
import 'package:movies/widgets/appbars/my_image_app_bar.dart';
import 'package:movies/widgets/others/result_card.dart';
import 'package:movies/widgets/sections/collection_section.dart';
import 'package:movies/widgets/sections/provider_section.dart';
import 'package:movies/widgets/sections/cast_section.dart';
import 'package:movies/widgets/sections/recommended_section.dart';
import 'package:movies/widgets/sections/story_section.dart';
import 'package:movies/widgets/states/common/image_colored_state.dart';

class MoviePage extends StatefulWidget {

  final int id;
  final Color color;

  MoviePage({
    super.key,
    required this.id,
    required this.color,
  });

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends ImageColoredState<MoviePage> {
  MovieDetailedModel? movie;
  Providers? providers;
  List? cast;
  List? recommendations;

  // fecth functions
  _fetchProviders() async {
    var p = await fetchProviders(widget.id, TypeEnum.movie);
    setState(() {
      providers = p;
    });
  }
  _fetchCast() async {
    var c = await fetchCast(widget.id, TypeEnum.movie);
    setState(() {
      cast = c;
    });
  }
  _fetchRecommends() async {
    var r = await fetchRecommendations(widget.id, TypeEnum.movie);
    setState(() {
      recommendations = r;
    });
  }

  // init
  @override
  init() async {
    var m = await fetchById(widget.id, TypeEnum.movie);
    setState(() {
      movie = m;
    });

    _fetchProviders();
    _fetchCast();
    _fetchRecommends();

    // preloadImageWithColor(lowImageLink(m.cover));
    preloadImage(originalImageLink(m.cover));
  }

  // loading
  @override
  isLoading() {
    return movie == null 
      || providers == null 
      || cast == null 
      || recommendations == null 
      || imageLoading;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading() 
      ? ColorLoader(color: widget.color)
      : Material(
        child: AnnotatedRegion(
          value: SystemUiOverlayStyle.light.copyWith(           
            statusBarColor: widget.color,
          ),
          child: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: MyImageAppBar(
                      title: movie!.title, 
                      cover: coverImage,
                      color: widget.color,
                      onlyTitle: false,
                      child: ResultCard(
                        image: movie!.image, 
                        title: movie!.title, 
                        release: movie!.release, 
                        percent: movie!.percent, 
                        raw: movie!.raw,
                        genres: movie!.genres,
                      ),
                    ),
                  ),
                ];
              },
              body: Container(
                color: widget.color,
                child: Scaffold(
                  body: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ProviderSection(
                          providers: providers
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: StorySection(
                          description: movie!.description
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: CastSection(
                          cast: cast!
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: CollectionSection(
                          model: movie!.collection,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: RecommendedSection(
                          recommendations: recommendations!
                        )
                      ),
                      SizedBox(height: 10),
                    ],
                  )
                )
              )
            ),
          ),
        ),
      );
  }
}