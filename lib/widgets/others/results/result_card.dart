import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/widgets/others/image.dart';
import 'package:movies/widgets/others/results/base_card.dart';

class ResultCard extends StatelessWidget {
  final String image;
  final String title;
  final String release;
  final double percent;

  ResultCard({
    required this.image,
    required this.title,
    required this.release,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(image: image, title: title, space: 10, horizontalPadding: 8, children: [
      Text(dateFormat(release), style: TextStyle(color: Colors.white38, fontSize: 12)),
      Row(children: [
        Icon(Icons.star_rate, color: Colors.yellow, size: 15),
        SizedBox(width: 5),
        Text(percent.toStringAsFixed(1), style: TextStyle(color: Colors.white, fontSize: 12))
      ])
    ]);
  }
}
