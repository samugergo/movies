import 'package:flutter/material.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/main.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/pages/show/show_page.dart';
import 'package:movies/widgets/button_switch.dart';
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

    return ListView(
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
        ...list.map((pair) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            pair[0] != null 
            ? Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => goTo(pair[0].id),
                child: XImage(
                  url: pair[0].image,
                  width: 180,
                  height: 270,
                  radius: 10,
                ),
              ),
            )
            : SizedBox(),
            pair[1] != null 
            ? Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => goTo(pair[1].id),
                child: XImage(
                  url: pair[1].image,
                  width: 180,
                  height: 270,
                  radius: 10,
                )
              ),
            )
            : SizedBox(),
          ]
        )).toList(),
        LoadButton(load: appState.loadMore),
      ]
    );
  }
}