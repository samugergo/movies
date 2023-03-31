import 'package:flutter/material.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/main.dart';
import 'package:movies/models/base/display_model.dart';
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
import 'package:page_transition/page_transition.dart';

import '../../widgets/others/image.dart';

class XContainer extends StatelessWidget {

  final ScrollController controller;

  XContainer({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MainAppState>();
    final double width = MediaQuery.of(context).size.width;

    List list = appState.type == TypeEnum.movie ? appState.movies : appState.shows;    

    goColor(id, color) {
      final Widget to = appState.type == TypeEnum.movie 
        ? MoviePage(id: id, color: color) 
        : ShowPage(id: id, color: color);
      goTo(context, to);
    }
    go(model){
      getColorFromImage(
        lowImageLink(model.cover), 
        (color) => goColor(model.id, color)
      );
    } 

    const itemCount = 3;
    const crossSpacing = 10.0;
    const mainSpacing = 10.0;
    final itemWidth = width/itemCount - itemCount * crossSpacing;
    final itemHeight = itemWidth*1.5;

    return appState.isEmptyByType(appState.type) 
    ? Loader()
    : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        controller: controller,
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
              children: list.map((pair) => ImageCard(
                model: pair,
                goTo: go,
              )).toList(),
            ),
            SizedBox(height: 10),
            LoadButton(load: appState.loadMore),
          ],
        ),
      ),
    );
  }
}