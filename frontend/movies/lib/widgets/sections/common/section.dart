import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final String title;
  final List children;

  Section({
    required this.title,
    required this.children
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: Colors.white
          )
        ),
        Divider(color: Colors.white24),
        ...children,
      ],
    );
  }

}