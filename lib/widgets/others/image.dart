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

  static Widget customRadius(String url, double width, double height, BorderRadius radius) {
    return ClipRRect(
      borderRadius: radius,
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

  static Widget custom(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: url != '' 
      ? Image.network(
        url,
        // width: width,
        fit: BoxFit.cover,
      )
      : Image.asset(
        'assets/images/default.png',
        // width: width,
        fit: BoxFit.fill,
      ),
    );
  }

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
          fit: BoxFit.cover,
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