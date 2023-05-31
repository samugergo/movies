import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/common/external_id_model.dart';
import 'package:movies/models/common/providers_model.dart';
import 'package:movies/models/detailed/movie_detailed_model.dart';
import 'package:movies/services/service.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/widgets/buttons/trailer_button.dart';
import 'package:movies/widgets/containers/animated_contaner.dart';
import 'package:movies/widgets/loaders/color_loader.dart';
import 'package:movies/widgets/containers/gradient_container.dart';
import 'package:movies/widgets/loaders/loader.dart';
import 'package:movies/widgets/appbars/my_image_app_bar.dart';
import 'package:movies/widgets/others/detail_card.dart';
import 'package:movies/widgets/sections/collection_section.dart';
import 'package:movies/widgets/sections/provider_section.dart';
import 'package:movies/widgets/sections/cast_section.dart';
import 'package:movies/widgets/sections/recommended_section.dart';
import 'package:movies/widgets/sections/social_medial_section.dart';
import 'package:movies/widgets/sections/story_section.dart';
import 'package:movies/widgets/states/common/image_colored_state.dart';
import 'package:movies/widgets/youtube_player.dart';

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
  ExternalIdModel? externalIds;
  List? cast;
  List? recommendations;
  List? similar;

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
  _fetchExternalIds() async {
    var e = await fetchExternalIds(widget.id, TypeEnum.movie);
    setState(() {
      externalIds = e;
      print(e);
    });
  }
  _fetchRecommends() async {
    var r = await fetchRecommendations(widget.id, TypeEnum.movie);
    setState(() {
      recommendations = r;
    });
  }
  _fetchSimilar() async {
    var s = await fetchSimilar(widget.id, TypeEnum.movie);
    setState(() {
      similar = s;
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
    _fetchExternalIds();
    // _fetchRecommends();
    // _fetchSimilar();

    preloadImage(originalImageLink(m.cover));
    preloadImageWithColor(lowImageLink(m.cover));
  }

  // loading
  @override
  isLoading() {
    return movie == null 
      || providers == null 
      || cast == null 
      || externalIds == null
      // || recommendations == null
      // || similar == null
      || mainColor == null
      || imageLoading;
  }

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 15;
    final theme = getAppTheme(context);

    return XAnimatedContainer(
      duration: 300,
      color: theme.primary!,
      statusbar: isLoading() ? theme.primary : mainColor,
      child: isLoading() 
      ? ColorLoader(color: theme.primary!)
      : Container(
        color: mainColor,
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: MyImageAppBar(
                    title: movie!.title, 
                    cover: coverImage,
                    color: mainColor,
                    onlyTitle: false,
                    horizontalPadding: horizontalPadding,
                    child: DetailCard(
                      model: movie!,
                    ),
                  ),
                ),
              ];
            },
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 1],
                  colors: [
                    mainColor!,
                    Colors.black54,
                  ]
                ),
              ),
              child: Scaffold(
                body: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: TrailerButton(
                        onclick: () {}
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: ProviderSection(
                        providers: providers
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: StorySection(
                        description: movie!.description
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: CollectionSection(
                        model: movie!.collection,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: CastSection(
                        cast: cast!
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: SocialMediaSection(
                        externalIds: externalIds!
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    //   child: OtherMoviesSection(
                    //     title: 'Ajánlott',
                    //     recommendations: recommendations!
                    //   )
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    //   child: OtherMoviesSection(
                    //     title: 'Hasonlóak',
                    //     recommendations: similar!
                    //   )
                    // ),
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