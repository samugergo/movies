import 'package:flutter/material.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/main.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/pages/show/show_page.dart';
import 'package:movies/widgets/image.dart';
import 'package:movies/widgets/sections/common/section.dart';
import 'package:provider/provider.dart';

class RecommendedSection extends StatelessWidget {
  final List recommendations;

  RecommendedSection({
    required this.recommendations,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MainAppState>();

    goTo(id) {
      final Widget to = appState.type == TypeEnum.movie ? MoviePage(id: id) : ShowPage(id: id);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => to),
      );
    } 
    
    return Section(
      title: 'Ajánlott', 
      children: [
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: recommendations.map((e) => 
              SizedBox(
                width: 133,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4, left: 4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => goTo(e.id),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        XImage(
                          url: e.image, 
                          width: 125, 
                          height: 180, 
                          radius: 10
                        ),
                        Text(
                          e.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12
                          ),
                        )
                      ],
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