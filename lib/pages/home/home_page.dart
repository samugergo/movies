import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/base/display_model.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/pages/show/show_page.dart';
import 'package:movies/theme/app_colors.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/utils/navigation_util.dart';
import 'package:movies/widgets/loaders/loader.dart';
import 'package:movies/widgets/others/image_card.dart';
import 'package:movies/widgets/sections/common/section.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  HomePage({
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppColors>()!;
    final appState = getAppState(context);
    return appState.isLoading() 
    ? Loader()
    : Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 1],
          colors: [
            theme.primary!, 
            theme.secondary!
          ],
          tileMode: TileMode.mirror
        ),
      ),
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light.copyWith(           
          statusBarColor: Colors.black
          .withOpacity(0.6),
        ),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          body: ListView(
            controller: widget.scrollController,
            padding: EdgeInsets.zero,
            children: [
              _CarouselSlider(
                onPageChanged: (index, reason) {
                  setState(() {
                    _activeIndex = index;
                  });
                }
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: AnimatedSmoothIndicator(
                    activeIndex: _activeIndex, 
                    count: 5,
                    effect: SlideEffect(  
                        spacing: 10,
                        dotWidth: 7,  
                        dotHeight: 7,
                        dotColor: Colors.white24,  
                        activeDotColor: Colors.white  
                    ),  
                  ),
                ),
              ),
              _ListSection(
                key: ValueKey(4),
                title: 'Popular Movies',
                list: appState.popularMovies,
              ),
              SizedBox(height: 6),
              _ListSection(
                key: ValueKey(4),
                title: 'Upcoming Movies',
                list: appState.upcomingMovies,
              ),
              SizedBox(height: 6),
              _ListSection(
                key: ValueKey(1),
                title: 'Popular Series',
                list: appState.popularShows,
              ),
              SizedBox(height: 6),
              _ListSection(
                key: ValueKey(4),
                title: 'Top rated Series',
                list: appState.upcomingShows,
              ),
              SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListSection extends StatelessWidget {
  const _ListSection({
    super.key,
    required this.title,
    required this.list,
  });

  final String title;
  final List list;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Section(
        title: title,
        children: [
          SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: list.map<Widget>((m) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ImageCard(
                  model: m,
                  goTo: (model) {
                    final Widget to = TypeEnum.isMovie(model.type)
                      ? MoviePage(id: model.id, color: Colors.black) 
                      : ShowPage(id: model.id, color: Colors.black);
                    goTo(context, to);
                  },
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CarouselSlider extends StatelessWidget {
  _CarouselSlider({
    required this.onPageChanged,
  });

  final Function(int, dynamic) onPageChanged;

  _goto(BuildContext context, DisplayModel model) {
    Widget to = TypeEnum.isMovie(model.type) 
      ? MoviePage(id: model.id, color: Colors.black)
      : ShowPage(id: model.id, color: Colors.black);
    goTo(context, to);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppColors>()!;
    final appState = getAppState(context);

    return CarouselSlider(
      options: CarouselOptions(
        height: 300,
        enlargeCenterPage: true,
        viewportFraction: 1,
        enlargeFactor: 0,
        autoPlay: false,
        onPageChanged: onPageChanged,
      ),
      items: appState.popularMovies.sublist(0, 5).map<Widget>((i) {
        return Builder(
          builder: (BuildContext context) {
            return Stack(
              children: [
                InkWell(
                  onTap: () => _goto(context, i),
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.primary!,
                          Colors.transparent, 
                        ],
                        stops: [0.5, 1]
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstIn,
                    child: CachedNetworkImage(
                      imageUrl: originalImageLink(i.cover),
                      height: 350,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    i.title,
                    style: GoogleFonts.bebasNeue(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 22
                      )
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }).toList(),
    );
  }

}