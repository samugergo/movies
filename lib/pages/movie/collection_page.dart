import 'package:flutter/material.dart';
import 'package:movies/models/base/display_model.dart';
import 'package:movies/models/detailed/collection_detailed_model.dart';
import 'package:movies/models/detailed/movie_detailed_model.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/services/service.dart';
import 'package:movies/utils/color_util.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/utils/navigation_util.dart';
import 'package:movies/widgets/containers/animated_contaner.dart';
import 'package:movies/widgets/loaders/color_loader.dart';
import 'package:movies/widgets/appbars/image_app_bar.dart';
import 'package:movies/widgets/others/image_card.dart';
import 'package:movies/widgets/sections/common/section_title.dart';
import 'package:movies/states/image_state.dart';

class CollectionPage extends StatefulWidget {
  CollectionPage({
    required this.id,
  });

  final int id;

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends ImageState<CollectionPage> {
  CollectionDetailedModel? collection;

  @override
  init() async {
    var c = await fetchCollection(widget.id);
    setState(() {
      collection = c;
    });

    preloadImage(originalImageLink(c.cover));
    preloadImageWithColor(lowImageLink(c.cover));
  }

  @override
  isLoading() {
    return collection == null || super.isLoading();
  }

  @override
  Widget build(BuildContext context) {
    final theme = getAppTheme(context);
    final locale = getAppLocale(context);
    final gridModel = getGridViewModel(context, 3);

    go(DisplayModel model) {
      final Widget to = MoviePage(id: model.id);
      goTo(context, to);
    }

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
                                    title: collection!.title,
                                    cover: coverImage,
                                    color: mainColor,
                                    onlyTitle: true,
                                    horizontalPadding: 10,
                                    child: Text(collection!.title)))
                          ];
                        },
                        body: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.1, 1],
                                    colors: [mainColor!, Colors.black45])),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: SingleChildScrollView(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                      SectionTitle(titleLeftPadding: 0, title: locale.movies),
                                      GridView.count(
                                        physics: BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        crossAxisCount: gridModel.itemCount,
                                        mainAxisSpacing: gridModel.mainSpacing,
                                        crossAxisSpacing: gridModel.crossSpacing,
                                        childAspectRatio: gridModel.aspectRatio!,
                                        children: collection!.modelList
                                            .map((pair) => ImageCard(model: pair, goTo: go))
                                            .toList(),
                                      )
                                    ])))))),
              ));
  }
}
