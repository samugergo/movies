import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movies/models/base/display_model.dart';
import 'package:movies/models/detailed/collection_detailed_model.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/services/service.dart';
import 'package:movies/utils/color_util.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/widgets/containers/image_gradient_container.dart';
import 'package:movies/widgets/image.dart';
import 'package:movies/widgets/my_image_app_bar.dart';
import 'package:movies/widgets/sections/common/section.dart';

class CollectionPage extends StatefulWidget {
  CollectionPage({
    required this.id,
  });

  final int id; 

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  CollectionDetailedModel? collection;
  Image? coverImage;
  Color? mainColor;
  bool imageLoading = true;

  init() async {
    var c = await fetchCollection(widget.id);
    print(c.cover);
    if(c.cover != null && c.cover != '') {
      _preloadImage(lowImageLink(c.cover), null, (loaded) => {
        _calcMainColor(loaded)
      });
      _preloadImage(originalImageLink(c.cover), () => setState(() => {
        imageLoading = false
      }), (loaded) => setState(() => {
        coverImage = loaded
      }));
    } 
    setState(() {
      collection = c;
    });
  }

  _preloadImage(image, Function? setLoading, Function callback) {
    if(image == null || image == '') {
      if(setLoading != null) {
        setLoading();
      }
      return;
    }
    var loadedImage = Image.network(image);
    loadedImage.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, call) {
          if(setLoading != null) {
            setLoading();
          }
          callback(loadedImage);
        },
      ),
    );
  }

  _calcMainColor(image) async {
    if(image != null && image != '') {
      var color = await getImagePalette(image.image);
      setState(() {
        mainColor = color;
      });
      _checkColor(mainColor);
    }
  }

  _checkColor(image) async {
    bool isLight = ThemeData.estimateBrightnessForColor(mainColor!) == Brightness.light;
    if(isLight) {
      updateMainColor(color) => {
        setState(() => {
          mainColor = color
        })
      };
      darken(mainColor!, updateMainColor);
    }
  }

  
  isLoading() {
    return collection == null
      || imageLoading == true
      || mainColor == null;
  }

  @override
  void initState() {
    init();
    super.initState();
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