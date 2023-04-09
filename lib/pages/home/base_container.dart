import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/main.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/pages/show/show_page.dart';
import 'package:movies/utils/color_util.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/utils/navigation_util.dart';
import 'package:movies/widgets/buttons/button_switch.dart';
import 'package:movies/widgets/loaders/loader.dart';
import 'package:movies/widgets/others/image_card.dart';
import 'package:movies/widgets/sections/filter/filter_section.dart';
import 'package:movies/widgets/buttons/load_button.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transparent_image/transparent_image.dart';

class BaseConainer extends StatelessWidget {

  final ScrollController controller;

  BaseConainer({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MainAppState>();

    if(appState.isEmptyByType(appState.type)) {
      return Loader();
    } else {
      return AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: appState.type == TypeEnum.movie 
        ? _ListView(
          key: ValueKey(1),
          list: appState.movies, 
          controller: controller
        )
        : _ListView(
          key: ValueKey(2),
          list: appState.shows, 
          controller: controller
        ),
      );
    }
  }
}

class _ListView extends StatefulWidget {
  _ListView({
    required this.key,
    required this.list,
    required this.controller,
  });
  
  final ValueKey key;
  final List list;
  final ScrollController controller; 

  @override
  State<_ListView> createState() => _ListViewState();
}

class _ListViewState extends State<_ListView> {
  bool calculating = false;
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MainAppState>();
    final itemCount = appState.itemCount;

    goColor(id, color) {
      setState(() {
        calculating = false;
      });
      final Widget to = appState.type == TypeEnum.movie 
        ? MoviePage(id: id, color: color) 
        : ShowPage(id: id, color: color);
      goTo(context, to);
    }
    go(model){
      setState(() {
        calculating = true;
      });
      getColorFromImage(
        lowImageLink(model.cover), 
        (color) => goColor(model.id, color)
      );
    } 

    final double width = MediaQuery.of(context).size.width;
    const crossSpacing = 10.0;
    const mainSpacing = 10.0;
    final itemWidth = width/itemCount - itemCount * crossSpacing;
    final itemHeight = itemWidth*1.5;

    return Stack(
      children: [
        SingleChildScrollView(
          controller: widget.controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ButtonSwitch(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Filmek'.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 160.0,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.2,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  },
                ),
                items: appState.movies.sublist(0, 5).map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              fadeInDuration: Duration(milliseconds: 100),
                              image: imageLink(i.cover),
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          Positioned(
                            left: 10,
                            right: 10,
                            bottom: 5,
                            child: Text(
                              i.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }).toList(),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AnimatedSmoothIndicator(
                    activeIndex: activeIndex, 
                    count: 5,
                    effect: SlideEffect(  
                        spacing: 4.0,
                        dotWidth: 5,  
                        dotHeight: 5,
                        dotColor: Colors.grey,  
                        activeDotColor: Colors.indigo  
                    ),  
                  ),
                ),
              ),
              FilterSection(),
              GridView.count(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: itemCount,
                mainAxisSpacing: mainSpacing,
                crossAxisSpacing: crossSpacing,
                childAspectRatio: itemWidth/itemHeight,
                children: widget.list.map((pair) => ImageCard(
                  model: pair,
                  goTo: go,
                )).toList(),
              ),
              SizedBox(height: 10),
              LoadButton(load: appState.loadMore),
            ],
          ),
        ),
        if(calculating) ModalBarrier()
        
      ],
    );
  }
}