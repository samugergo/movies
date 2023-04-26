import 'package:flutter/material.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/main.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/pages/show/show_page.dart';
import 'package:movies/utils/color_util.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/utils/navigation_util.dart';
import 'package:movies/widgets/others/image.dart';
import 'package:movies/widgets/sections/common/section.dart';
import 'package:provider/provider.dart';

class OtherMoviesSection extends StatelessWidget {
  final List recommendations;
  final String title;

  OtherMoviesSection({
    required this.recommendations,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MainAppState>();

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
    
    return recommendations.isEmpty 
    ? SizedBox()
    : Section(
      title: title, 
      children: [
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: recommendations.map((e) => 
              SizedBox(
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => go(e),
                    child: XImage(
                      url: e.image, 
                      width: 125, 
                      height: 180, 
                      radius: 10
                    ),
                  ),
                ),
              )
            ).toList(),
          ),
        )
      ],
    );
  }
}