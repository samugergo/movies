import 'package:flutter/material.dart';

// ignore: must_be_immutable
class XImage extends StatelessWidget {

  final String url;
  final double width;
  final double height;
  final double radius;

  XImage({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    required this.radius
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: url != '' 
        ? Image.network(
          url,
          height: height,
          fit: BoxFit.fill,
        )
        : Image.asset(
          'assets/images/default.png',
          height: height,
          fit: BoxFit.fill,
        )
      )
    );
  }
}