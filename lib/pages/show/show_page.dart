import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/common/providers_model.dart';
import 'package:movies/models/detailed/show_detailed_model.dart';
import 'package:movies/services/service.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/widgets/buttons/trailer_button.dart';
import 'package:movies/widgets/containers/animated_contaner.dart';
import 'package:movies/widgets/loaders/color_loader.dart';
import 'package:movies/widgets/containers/gradient_container.dart';
import 'package:movies/widgets/loaders/loader.dart';
import 'package:movies/widgets/others/detail_card.dart';
import 'package:movies/widgets/sections/season_section.dart';
import 'package:movies/widgets/states/common/image_colored_state.dart';
import 'package:movies/widgets/appbars/my_image_app_bar.dart';
import 'package:movies/widgets/others/result_card.dart';
import 'package:movies/widgets/sections/cast_section.dart';
import 'package:movies/widgets/sections/provider_section.dart';
import 'package:movies/widgets/sections/recommended_section.dart';
import 'package:movies/widgets/sections/story_section.dart';

import '../../models/common/external_id_model.dart';
import '../../utils/navigation_util.dart';
import '../../widgets/sections/images_section.dart';
import '../../widgets/sections/social_medial_section.dart';
import '../../widgets/youtube_player.dart';

class ShowPage extends StatefulWidget {

  final int id;
  final Color color;

  ShowPage({
    super.key,
    required this.id,
    required this.color,
  });

  @override
  State<ShowPage> createState() => _ShowPageState();
}

class _ShowPageState extends ImageColoredState<ShowPage> {
  ShowDetailedModel? show;
  Providers? providers;
  ExternalIdModel? externalIds;
  String? trailer;
  List? cast;
  List? recommendations;
  List? similar;
  List? images;

  // fetch functions
  _fetchProviders() async {
    var p = await fetchProviders(widget.id, TypeEnum.show);
    setState(() {
      providers = p;
    });
  }
  _fetchCast() async {
    var c = await fetchCast(widget.id, TypeEnum.show);
    setState(() {
      cast = c;
    });
  }
  _fetchExternalIds() async {
    var e = await fetchExternalIds(widget.id, TypeEnum.show);
    setState(() {
      externalIds = e;
    });
  }
  _fetchTrailer() async {
    var t = await fetchTrailer(widget.id, TypeEnum.show);
    setState(() {
      trailer = t;
    });
  }
  _fetchImages() async {
    var i = await fetchImages(widget.id, TypeEnum.show);
    setState(() {
      images = i;
    });
  }
  _fetchRecommends() async {
    var r = await fetchRecommendations(widget.id, TypeEnum.show);
    setState(() {
      recommendations = r;
    });
  }
  _fetchSimilar() async {
    var s = await fetchSimilar(widget.id, TypeEnum.show);
    setState(() {
      similar = s;
    });
  }

  // init
  @override
  init() async {
    var s = await fetchById(widget.id, TypeEnum.show);
    setState(() {
      show = s;
    });

    _fetchProviders();
    _fetchCast();
    _fetchExternalIds();
    _fetchTrailer();
    _fetchImages();
    // _fetchRecommends();
    _fetchSimilar();

    preloadImage(originalImageLink(s.cover));
    preloadImageWithColor(lowImageLink(s.cover));
  }

  // loading
  @override
  isLoading() {
    return show == null 
      || providers == null 
      || cast == null 
      || externalIds == null
      || trailer == null
      || images == null
      // || recommendations == null 
      || mainColor == null
      || imageLoading;
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    final theme = getAppTheme(context);
    const double horizontalPadding = 15;

    return XAnimatedContainer(
      color: theme.primary!, 
      statusbar: isLoading() ? theme.primary : mainColor,
      duration: 300, 
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
                    title: show!.title, 
                    onlyTitle: false,
                    cover: coverImage,
                    color: mainColor,
                    horizontalPadding: horizontalPadding,
                    child: DetailCard(
                      model: show!,
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
                    Colors.black45,
                  ]
                ),
              ),
              child: Scaffold(
                body: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: TrailerButton(
                        id: trailer!,
                        onclick: () {
                          goTo(context, MyYoutubePlayer(
                            id: trailer!,
                          ));
                        }
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
                        description: show!.description
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: SeasonSection(
                        list: show!.seasons
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
                      child: ImagesSection(
                        images: images!,
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
                  ],
                )
              )
            )
          ),
        ),
      )
    );
  }
}