import 'package:flutter/material.dart';
import 'package:movies/models/base/display_model.dart';
import 'package:movies/widgets/others/image.dart';

class ImageCard extends StatelessWidget {
  final DisplayModel model;
  final Function goTo;

  ImageCard({
    required this.model,
    required this.goTo,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => goTo(model),
      child: XImage.custom(
        model.image
      ),
    );
  }
}