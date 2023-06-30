import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../image.dart';

class BaseCard extends StatelessWidget {
  BaseCard(
      {required this.image,
      required this.title,
      required this.children,
      this.space = 0,
      this.titleBottom = 0,
      this.horizontalPadding = 0});

  final String image;
  final String title;
  final List<Widget> children;
  final double space;
  final double titleBottom;
  final double horizontalPadding;

  final List<Widget> _children = [];

  @override
  Widget build(BuildContext context) {
    _children.add(SizedBox(height: titleBottom));
    for (var element in children) {
      final isNotLast = children.indexOf(element) < children.length - 1;
      _children.add(
          Padding(padding: EdgeInsets.symmetric(horizontal: horizontalPadding), child: element));
      if (isNotLast && space > 0) {
        _children.add(SizedBox(height: space));
      }
    }

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      XImage(url: image, width: 100, height: 150, radius: 10),
      Flexible(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(title,
                    style: GoogleFonts.bebasNeue(
                        textStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16)))),
            ..._children,
          ]))
    ]);
  }
}
