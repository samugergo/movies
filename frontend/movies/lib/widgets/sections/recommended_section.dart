import 'package:flutter/material.dart';
import 'package:movies/widgets/image.dart';
import 'package:movies/widgets/sections/common/section.dart';

class RecommendedSection extends StatelessWidget {
  final List recommendations;

  RecommendedSection({
    required this.recommendations,
  });

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Ajánlott', 
      children: [
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: recommendations.map((e) => 
              Padding(
                padding: const EdgeInsets.only(right: 4, left: 4),
                child: XImage(
                  url: e.image, 
                  width: 120, 
                  height: 180, 
                  radius: 10
                ),
              )
            ).toList(),
          ),
        )
      ],
    );
  }
}