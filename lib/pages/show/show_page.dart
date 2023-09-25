import 'package:flutter/material.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/detailed/show_detailed_model.dart';
import 'package:movies/pages/common/detail_page.dart';
import 'package:movies/services/service.dart';
import 'package:movies/states/detail_state.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/widgets/buttons/trailer_button.dart';
import 'package:movies/widgets/containers/animated_contaner.dart';
import 'package:movies/widgets/containers/detail_container.dart';
import 'package:movies/widgets/loaders/color_loader.dart';
import 'package:movies/widgets/others/results/detail_card.dart';
import 'package:movies/widgets/sections/director_section.dart';
import 'package:movies/widgets/sections/season_section.dart';
import 'package:movies/widgets/appbars/image_app_bar.dart';
import 'package:movies/widgets/sections/cast_section.dart';
import 'package:movies/widgets/sections/provider_section.dart';
import 'package:movies/widgets/sections/story_section.dart';
import '../../widgets/sections/images_section.dart';
import '../../widgets/sections/social_medial_section.dart';

class ShowPage extends DetailPage {
  ShowPage({required super.id}) : super(type: TypeEnum.show);

  @override
  State<ShowPage> createState() => _ShowPageState();
}

class _ShowPageState extends DetailState<ShowPage> {
  ShowDetailedModel? show;

  // init
  @override
  void init() async {
    var s = await getById(widget.id, widget.type);
    setState(() {
      show = s;
    });

    super.fetchCommonData();

    preloadImage(originalImageLink(s.cover));
    preloadImageWithColor(lowImageLink(s.cover));
  }

  // loading
  @override
  bool isLoading() {
    return show == null || super.isLoading();
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
                model: show!,
                children: [
                    TrailerButton(id: show!.trailer, onclick: launchTrailer),
                    ProviderSection(providers: providers),
                    StorySection(description: show!.description),
                    SeasonSection(list: show!.seasons),
                    DirectorSection(model: show!.director),
                    CastSection(cast: show!.cast),
                    ImagesSection(images: show!.images),
                    SocialMediaSection(externalIds: show!.externalIds, padding: 25)
                  ]));
  }
}
