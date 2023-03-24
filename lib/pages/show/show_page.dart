import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/common/providers_model.dart';
import 'package:movies/models/detailed/show_detailed_model.dart';
import 'package:movies/services/service.dart';
import 'package:movies/widgets/containers/image_gradient_container.dart';
import 'package:movies/widgets/display_app_bar.dart';
import 'package:movies/widgets/my_image_app_bar.dart';
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
  
  init() async {
    var s = await fetchById(widget.id, TypeEnum.show);
    var p = await fetchProviders(widget.id, TypeEnum.show);
    var c = await fetchCast(widget.id, TypeEnum.show);
    var r = await fetchRecommendations(widget.id, TypeEnum.show);

    preloadImage(s);

    setState(() {
      show = s;
      providers = p;
      cast = c;
      recommendations = r;
    });
  }

  preloadImage(show) {
    if(show.cover == null || show.cover == '') {
      setState(() {
        imageLoading = false;
      });
      return;
    }
    coverImage = Image.network(show.cover);
    if(coverImage != null) {
      coverImage!.image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener(
          (info, call) {
            setState(() {
              imageLoading = false;
            });
          },
        ),
      );
    }
  }

  isLoading() {
    return show == null 
      || providers == null 
      || cast == null 
      || recommendations == null 
      || imageLoading;
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff292A37),
    ));
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
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: MyImageAppBar(
                    poster: show!.image, 
                    title: show!.title, 
                    release: show!.release, 
                    percent: show!.percent, 
                    raw: show!.raw,
                    genres: show!.genres, 
                    cover: coverImage!
                  ),
                ),
              ];
            },
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.5, 1],
                  colors: [
                    Color(0xff292A37), 
                    Color(0xff0F1018)
                  ],
                  tileMode: TileMode.mirror
                ),
              ),
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
      );
  }
}