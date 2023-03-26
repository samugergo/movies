import 'package:flutter/material.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/main.dart';
import 'package:movies/models/base/display_model.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/pages/show/show_page.dart';
import 'package:movies/widgets/button_switch.dart';
import 'package:movies/widgets/loader.dart';
import 'package:movies/widgets/filter_section.dart';
import 'package:movies/widgets/load_button.dart';
import 'package:provider/provider.dart';

import '../../widgets/image.dart';

class XContainer extends StatelessWidget {

  final ScrollController controller;

  XContainer({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MainAppState>();

    List list = appState.type == TypeEnum.movie ? appState.movies : appState.shows;    

    goTo(id) {
      final Widget to = appState.type == TypeEnum.movie ? MoviePage(id: id) : ShowPage(id: id);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => to),
      );
    } 

    return appState.isEmptyByType(appState.type) 
    ? Loader()
    : ListView(
      controller: controller,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14.0, right: 14, top: 10),
          child: Column(
            children: [
              ButtonSwitch(),
              FilterSection(),
            ],
          ),
        ),
        ...list.map((pair) => _ImageRow(
          pair: pair,
          goTo: goTo,
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
        : SizedBox()
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