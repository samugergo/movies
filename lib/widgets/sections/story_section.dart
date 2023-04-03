import 'package:flutter/material.dart';
import 'package:movies/widgets/sections/common/section.dart';

class StorySection extends StatelessWidget {
  final String description;

  StorySection({
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return description == '' 
    ? SizedBox()
    : Section(
      title: 'Történet', 
      children: [
        Text(
          description,
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        )
      ]
    );
  }

}