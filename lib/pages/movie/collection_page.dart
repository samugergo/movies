import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movies/models/base/display_model.dart';
import 'package:movies/models/detailed/collection_detailed_model.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/services/service.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/widgets/containers/image_gradient_container.dart';
import 'package:movies/widgets/image.dart';
import 'package:movies/widgets/my_image_app_bar.dart';
import 'package:movies/widgets/sections/common/section.dart';
import 'package:movies/widgets/states/common/image_colored_state.dart';

class CollectionPage extends StatefulWidget {
  CollectionPage({
    required this.id,
  });

  final int id; 

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

    preloadImageWithColor(lowImageLink(c.cover));
    preloadImage(originalImageLink(c.cover));
  }

  @override
  isLoading() {
    return collection == null
      || imageLoading == true
      || mainColor == null;
  }

  @override
  Widget build(BuildContext context) {
    goTo(id) {
      final Widget to = MoviePage(id: id);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => to),
      );
    } 
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
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light.copyWith(           
          statusBarColor: mainColor ?? Color(0xff292A37),
        ),
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: MyImageAppBar(
                    title: collection!.title, 
                    cover: coverImage,
                    color: mainColor,
                    onlyTitle: true,
                    child: Text(collection!.title),
                  ),
                ),
              ];
            },
            body: Container(
              color: mainColor,
              child: ListView(
                children: [
                  Section(
                    title: 'Filmek',
                    titleLeftPadding: 15,
                    children: [
                      ...chunkList(collection!.modelList).map((pair) => _ImageRow(
                        pair: pair,
                        goTo: goTo,
                      )).toList(),
                    ] 
                  ),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}

class _ImageRow extends StatelessWidget {
  final List pair; 
  final Function goTo;

  _ImageRow({
    required this.pair,
    required this.goTo
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        pair.isNotEmpty 
        ? _ImageCard(model: pair[0], goTo: goTo)
        : SizedBox(),
        pair.length > 1 
        ? _ImageCard(model: pair[1], goTo: goTo)
        : SizedBox(width: 195)
      ],
    );
  }
}

class _ImageCard extends StatelessWidget {
  final DisplayModel model;
  final Function goTo;

  _ImageCard({
    required this.model,
    required this.goTo
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => goTo(model.id),
        child: XImage(
          url: model.image,
          width: 180,
          height: 270,
          radius: 10,
        ),
      ),
    );
  }
}