import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidable/hidable.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/pages/home/base_container.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/pages/show/show_page.dart';
import 'package:movies/theme/app_colors.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/utils/navigation_util.dart';
import 'package:movies/widgets/loaders/loader.dart';
import 'package:movies/widgets/others/image_card.dart';
import 'package:movies/widgets/sections/common/section.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  HomePage({
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late ScrollController _scrollController;
  double _scrollControllerOffset = 0.0;
  int _activeIndex = 0;

  _scrollListener() {
    setState(() {
      _scrollControllerOffset = widget.scrollController.offset;
    });
  }

  @override
  void initState() {
    // _scrollController = ScrollController();
    widget.scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
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
          // appBar: PreferredSize(
          //   preferredSize: Size(MediaQuery.of(context).size.width, kToolbarHeight),
          //   child: _AppBar(
          //     scrollOffset: _scrollControllerOffset,
          //     scrollController: _scrollController,
          //   ),
          // ),
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
                title: 'Upcoming Series',
                list: appState.popularMovies,
              ),
              SizedBox(height: 6),
            ],
          ),
          // bottomNavigationBar: _BotttomNavigationBar(
          //   scrollController: _scrollController
          // ),
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

class _BotttomNavigationBar extends StatelessWidget {
  const _BotttomNavigationBar({
    super.key,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Hidable(
      controller: _scrollController,
      child: Wrap(
        children: [
          BottomNavigationBar(
            backgroundColor: Colors.black54,
            unselectedItemColor: Colors.grey[600],
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.house),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.film),
                label: 'Business',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.user),
                label: 'School',
              ),
            ],
            currentIndex: 0,
            selectedItemColor: Colors.white,
            onTap: (i) {}
          ),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final double scrollOffset;
  final ScrollController scrollController;
  const _AppBar({
    Key? key, 
    required this.scrollOffset,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hidable(
      controller: scrollController,
      child: Wrap(
        children: [
          SafeArea(
            child: AppBar(
              backgroundColor: Colors.black
                  .withOpacity((scrollOffset / 100).clamp(0, 0.6).toDouble()),
              scrolledUnderElevation: 0,
              elevation: 0,
              title: Text(
                  'Főoldal',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
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
        autoPlay: true,
        onPageChanged: onPageChanged,
      ),
      items: appState.popularMovies.sublist(0, 5).map<Widget>((i) {
        return Builder(
          builder: (BuildContext context) {
            return Stack(
              children: [
                ShaderMask(
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
                  // child: FadeInImage.memoryNetwork(
                  //   placeholder: kTransparentImage,
                  //   fadeInDuration: Duration(milliseconds: 1),
                  //   image: originalImageLink(i.cover),
                  //   fit: BoxFit.cover,
                  //   height: 300,
                  // ),
                  child: CachedNetworkImage(
                    imageUrl: originalImageLink(i.cover),
                    height: 350,
                    fit: BoxFit.cover,
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