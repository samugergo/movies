import 'package:flutter/material.dart';
import 'package:movies/widgets/sections/common/section_title.dart';

class Section extends StatelessWidget {
  final String title;
  final List children;
  final double titleLeftPadding;

  Section({
    required this.title,
    required this.children,
    this.titleLeftPadding = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          titleLeftPadding: titleLeftPadding, 
          title: title
        ),
        ...children,
      ],
    );
  }

}