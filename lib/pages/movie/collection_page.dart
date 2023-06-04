import 'package:flutter/material.dart';
import 'package:movies/models/detailed/collection_detailed_model.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/services/service.dart';
import 'package:movies/utils/color_util.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/utils/navigation_util.dart';
import 'package:movies/widgets/containers/animated_contaner.dart';
import 'package:movies/widgets/loaders/color_loader.dart';
import 'package:movies/widgets/appbars/my_image_app_bar.dart';
import 'package:movies/widgets/others/image_card.dart';
import 'package:movies/widgets/sections/common/section_title.dart';
import 'package:movies/widgets/states/common/image_colored_state.dart';

class CollectionPage extends StatefulWidget {
  CollectionPage({
    required this.id,
    required this.color,
  });

  final int id; 
  final Color color;

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends ImageColoredState<CollectionPage> {
  CollectionDetailedModel? collection;

  @override
  init() async {
    var c = await fetchCollection(widget.id);
    setState(() {
      collection = c;
    });

    preloadImage(originalImageLink(c.cover));
  }

  @override
  isLoading() {
    return collection == null
      || imageLoading == true;
  }

  @override
  Widget build(BuildContext context) {
    final locale = getAppLocale(context);

    goColor(id, color) {
      final Widget to = MoviePage(id: id);
      goTo(context, to);
    }

    go(model){
      getColorFromImage(
        lowImageLink(model.cover), 
        (color) => goColor(model.id, color)
      );
    }

    final double width = MediaQuery.of(context).size.width;
    const itemCount = 3;
    const crossSpacing = 10.0;
    const mainSpacing = 10.0;
    final itemWidth = width/itemCount - itemCount * crossSpacing;
    final itemHeight = itemWidth*1.5;

    return XAnimatedContainer(
      color: widget.color, 
      statusbar: widget.color,
      duration: 300, 
      child: isLoading() 
      ? ColorLoader(color: widget.color)
      : SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverPersistentHeader(
                pinned: true,
                delegate: MyImageAppBar(
                  title: collection!.title, 
                  cover: coverImage,
                  color: widget.color,
                  onlyTitle: true,
                  horizontalPadding: 10,
                  child: Text(collection!.title),
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
                  widget.color,
                  Colors.black45,
                ]
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(
                      titleLeftPadding: 0, 
                      title: locale.movies
                    ),
                    GridView.count(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: itemCount,
                      mainAxisSpacing: mainSpacing,
                      crossAxisSpacing: crossSpacing,
                      childAspectRatio: itemWidth/itemHeight,
                      children: collection!.modelList.map((pair) => ImageCard(
                        model: pair,
                        goTo: go,
                      )).toList(),
                    ),
                  ],
                ),
              ),
            )
          )
        ),
      )
    );
  }
}