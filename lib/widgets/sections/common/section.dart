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
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 16),
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