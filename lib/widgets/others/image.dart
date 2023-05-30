import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

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
         ? FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: url,
          height: height,
          fadeInDuration: Duration(milliseconds: 200),
          // width: width,
          fit: BoxFit.cover,
        )
        : Image.asset(
          'assets/images/default.png',
          height: height,
          // width: width,
          fit: BoxFit.fill,
        ),
      )
    );
  }

  static Widget custom(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: url != '' 
      ? CachedNetworkImage(
        imageUrl: url,
        // fadeInDuration: Duration(milliseconds: 300),
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
        ? FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: url,
          height: height,
          fadeInDuration: Duration(milliseconds: 200),
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