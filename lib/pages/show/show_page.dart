import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/common/providers_model.dart';
import 'package:movies/models/detailed/show_detailed_model.dart';
import 'package:movies/services/service.dart';
import 'package:movies/utils/color_util.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/widgets/containers/image_gradient_container.dart';
import 'package:movies/widgets/display_app_bar.dart';
import 'package:movies/widgets/my_image_app_bar.dart';
import 'package:movies/widgets/result_card.dart';
import 'package:movies/widgets/sections/cast_section.dart';
import 'package:movies/widgets/sections/provider_section.dart';
import 'package:movies/widgets/sections/recommended_section.dart';
import 'package:movies/widgets/sections/story_section.dart';

class ShowPage extends StatefulWidget {

  final int id;

  ShowPage({
    super.key,
    required this.id
  });

  @override
  State<ShowPage> createState() => _ShowPageState();
}

class _ShowPageState extends State<ShowPage> {
  ShowDetailedModel? show;
  Providers? providers;
  List? cast;
  List? recommendations;
  Image? coverImage;
  bool imageLoading = true;
  Color? mainColor;
  
  init() async {
    var s = await fetchById(widget.id, TypeEnum.show);
    setState(() {
      show = s;
    });

    _fetchProviders();
    _fetchCast();
    _fetchRecommends();
    if(s.cover != null && s.cover != '') {
      _preloadImage(lowImageLink(s.cover), null, (loaded) => {
        _calcMainColor(loaded)
      });
      _preloadImage(originalImageLink(s.cover), () => setState(() => {
        imageLoading = false
      }), (loaded) => setState(() => {
        coverImage = loaded
      }));
    } else {
      setState(() {
        imageLoading = false;
        mainColor = Color(0xff292A37);
      });
    }
  }

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
  _fetchRecommends() async {
    var r = await fetchRecommendations(widget.id, TypeEnum.show);
    setState(() {
      recommendations = r;
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

  _calcMainColor(image) async {
    if(image != null) {
      var color = await getImagePalette(image.image);
      setState(() {
        mainColor = color;
      });
      _checkColor(mainColor);
    }
  }

  isLoading() {
    return show == null 
      || providers == null 
      || cast == null 
      || recommendations == null 
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
    // if(is)
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: mainColor ?? Color(0xff292A37),
    // ));
    return 
      isLoading()
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
                      title: show!.title, 
                      onlyTitle: false,
                      cover: coverImage,
                      color: mainColor,
                      child: ResultCard(
                        image: show!.image, 
                        title: show!.title, 
                        release: show!.release, 
                        percent: show!.percent, 
                        raw: show!.raw,
                        genres: show!.genres,
                      ),
                    ),
                  ),
                ];
              },
              body: Container(
                color: mainColor,
                child: Scaffold(
                  body: ListView(
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: ProviderSection(
                          providers: providers
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: StorySection(
                          description: show!.description
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: CastSection(
                          cast: cast!
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: RecommendedSection(
                          recommendations: recommendations!
                        )
                      ),
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