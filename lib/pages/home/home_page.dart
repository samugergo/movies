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
 
    return appState.isEmptyByType(appState.type) 
    ? Loader()
    : ListView(
      controller: controller,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            children: [
              ButtonSwitch(),
              FilterSection(),
            ],
          ),
        ),
        ...list.map((pair) => _ImageRow(
          pair: pair,
          goTo: go,
        )).toList(),
        LoadButton(load: appState.loadMore),
      ]
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

  final double _padding = 20;

  @override
  Widget build(BuildContext context) {    
    double width = MediaQuery.of(context).size.width/2 - _padding;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => goTo(model),
        child: XImage.custom(
          model.image,
          width
        ),
      ),
    );
  }
}