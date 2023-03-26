import 'package:flutter/material.dart';

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
        Padding(
          padding: EdgeInsets.only(left: titleLeftPadding, bottom: 8.0, top: 16),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16
            )
          ),
        ),
        ...children,
      ],
    );
  }

}