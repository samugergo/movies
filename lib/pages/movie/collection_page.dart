import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/models/base/display_model.dart';
import 'package:movies/models/detailed/collection_detailed_model.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/services/service.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/widgets/loader.dart';
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
    ? Loader()
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

  final double _padding = 20;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width/2 - _padding;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 5),
          child: pair.isNotEmpty 
          ? _ImageCard(model: pair[0], goTo: goTo, width: width)
          : SizedBox(),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: pair.length > 1 
          ? _ImageCard(model: pair[1], goTo: goTo, width: width)
          : SizedBox(width: width),
        ),
      ],
    );
  }
}

class _ImageCard extends StatelessWidget {
  final DisplayModel model;
  final Function goTo;
  final double width;

  _ImageCard({
    required this.model,
    required this.goTo,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => goTo(model.id),
        child: XImage.custom(
          model.image,
          width
        ),
      ),
    );
  }
}