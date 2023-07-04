import 'package:flutter/material.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/detailed/movie_detailed_model.dart';
import 'package:movies/pages/common/detail_page.dart';
import 'package:movies/services/service.dart';
import 'package:movies/states/detail_state.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/widgets/buttons/trailer_button.dart';
import 'package:movies/widgets/containers/animated_contaner.dart';
import 'package:movies/widgets/loaders/color_loader.dart';
import 'package:movies/widgets/appbars/image_app_bar.dart';
import 'package:movies/widgets/others/results/detail_card.dart';
import 'package:movies/widgets/sections/collection_section.dart';
import 'package:movies/widgets/sections/images_section.dart';
import 'package:movies/widgets/sections/provider_section.dart';
import 'package:movies/widgets/sections/cast_section.dart';
import 'package:movies/widgets/sections/social_medial_section.dart';
import 'package:movies/widgets/sections/story_section.dart';

class MoviePage extends DetailPage {
  MoviePage({required super.id}) : super(type: TypeEnum.movie);

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends DetailState<MoviePage> {
  MovieDetailedModel? movie;

  // init
  @override
  void init() async {
    var m = await fetchById(widget.id, widget.type);
    setState(() {
      movie = m;
    });

    super.fetchCommonData();

    preloadImage(originalImageLink(m.cover));
    preloadImageWithColor(lowImageLink(m.cover));
  }

  // loading
  @override
  bool isLoading() {
    return movie == null || super.isLoading();
  }

  @override
  Widget build(BuildContext context) {
    final theme = getAppTheme(context);
    const double horizontalPadding = 15;

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
                                delegate: ImageAppBar(
                                    title: movie!.title,
                                    cover: coverImage,
                                    color: mainColor,
                                    onlyTitle: false,
                                    horizontalPadding: horizontalPadding,
                                    child: DetailCard(model: movie!)))
                          ];
                        },
                        body: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.1, 1],
                                    colors: [mainColor!, Colors.black54])),
                            child: Scaffold(
                                body: ListView(children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: horizontalPadding),
                                  child: TrailerButton(id: movie!.trailer, onclick: launchTrailer)),
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: horizontalPadding),
                                  child: ProviderSection(providers: providers)),
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: horizontalPadding),
                                  child: StorySection(description: movie!.description)),
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: horizontalPadding),
                                  child: CollectionSection(model: movie!.collection)),
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: horizontalPadding),
                                  child: CastSection(cast: movie!.cast)),
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: horizontalPadding),
                                  child: ImagesSection(images: movie!.images)),
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: horizontalPadding),
                                  child: SocialMediaSection(externalIds: movie!.externalIds, padding: 25))
                            ])))))));
  }
}
