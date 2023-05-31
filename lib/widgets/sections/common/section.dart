import 'package:flutter/material.dart';
import 'package:movies/widgets/sections/common/section_title.dart';

class Section extends StatelessWidget {
  final String title;
  final List children;
  final double titleLeftPadding;
  final bool centerTitle;

  Section({
    required this.title,
    required this.children,
    this.titleLeftPadding = 0.0,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          titleLeftPadding: titleLeftPadding, 
          title: title,
          centerTitle: centerTitle,
        ),
        ...children,
      ],
    );
  }

}