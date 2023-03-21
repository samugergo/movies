import 'package:flutter/material.dart';

// ignore: must_be_immutable
class XImage extends StatelessWidget {

  final String url;
  final double width;
  final double height;

  XImage({
    super.key,
    required this.url,
    required this.width,
    required this.height
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
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