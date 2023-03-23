import 'package:flutter/material.dart';
import 'package:movies/widgets/sections/common/section.dart';

class StorySection extends StatelessWidget {
  final String description;

  StorySection({
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Történet', 
      children: [
        Text(
          description,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        )
      ]
    );
  }

}