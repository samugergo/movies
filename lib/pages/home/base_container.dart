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
        Padding(
          key: widget.key,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            controller: widget.controller,
            child: Column(
              children: [
                ButtonSwitch(),
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
        ),
        if(calculating) ModalBarrier()
        
      ],
    );
  }
}