import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/common/providers_model.dart';
import 'package:movies/models/detailed/movie_detailed_model.dart';
import 'package:movies/services/service.dart';
import 'package:movies/utils/color_util.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/widgets/containers/image_gradient_container.dart';
import 'package:movies/widgets/my_image_app_bar.dart';
import 'package:movies/widgets/sections/collection_section.dart';
import 'package:movies/widgets/sections/provider_section.dart';
import 'package:movies/widgets/sections/cast_section.dart';
import 'package:movies/widgets/sections/recommended_section.dart';
import 'package:movies/widgets/sections/story_section.dart';
import 'package:palette_generator/palette_generator.dart';

class MoviePage extends StatefulWidget {

  final int id;

  MoviePage({
    super.key,
    required this.id
  });

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  MovieDetailedModel? movie;
  Providers? providers;
  List? cast;
  List? recommendations;
  Image? coverImage;
  bool imageLoading = true;
  Color? mainColor;

  init() async {
    var m = await fetchById(widget.id, TypeEnum.movie);
    setState(() {
      movie = m;
    });

    _fetchProviders();
    _fetchCast();
    _fetchRecommends();
    if(m.cover != null && m.cover != '') {
      _preloadImage(lowImageLink(m.cover), null, (loaded) => {
        _calcMainColor(loaded)
      });
      _preloadImage(originalImageLink(m.cover), () => setState(() => {
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
    var p = await fetchProviders(widget.id, TypeEnum.movie);
    setState(() {
      providers = p;
    });
  }
  _fetchCast() async {
    var c = await fetchCast(widget.id, TypeEnum.movie);
    setState(() {
      cast = c;
    });
  }
  _fetchRecommends() async {
    var r = await fetchRecommendations(widget.id, TypeEnum.movie);
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
    return movie == null 
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
                      poster: movie!.image, 
                      title: movie!.title, 
                      release: movie!.release, 
                      percent: movie!.percent, 
                      raw: movie!.raw,
                      genres: movie!.genres, 
                      cover: coverImage,
                      color: mainColor,
                    ),
                  ),
                ];
              },
              body: Container(
                color: mainColor,
                child: Scaffold(
                  body: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ProviderSection(
                          providers: providers
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: StorySection(
                          description: movie!.description
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: CastSection(
                          cast: cast!
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: CollectionSection(
                          model: movie!.collection,
                        ),
                      ),
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