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
import 'package:movies/widgets/sections/collection_section.dart';
import 'package:movies/widgets/sections/images_section.dart';
import 'package:movies/widgets/sections/provider_section.dart';
import 'package:movies/widgets/sections/cast_section.dart';
import 'package:movies/widgets/sections/social_medial_section.dart';
import 'package:movies/widgets/sections/story_section.dart';

import '../../widgets/containers/detail_container.dart';
import '../../widgets/sections/director_section.dart';

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
    MovieDetailedModel m = await getById(widget.id, widget.type);
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
            : DetailContainer(
                mainColor: mainColor!,
                coverImage: coverImage,
                horizontalPadding: horizontalPadding,
                model: movie!,
                children: [
                    TrailerButton(id: movie!.trailer, onclick: launchTrailer),
                    ProviderSection(providers: providers),
                    StorySection(description: movie!.description),
                    CollectionSection(model: movie!.collection),
                    DirectorSection(model: movie!.director),
                    CastSection(cast: movie!.cast),
                    ImagesSection(images: movie!.images),
                    SocialMediaSection(externalIds: movie!.externalIds, padding: 25)
                  ]));
  }
}
