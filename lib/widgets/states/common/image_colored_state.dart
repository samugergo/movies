import 'package:flutter/material.dart';
import 'package:movies/widgets/states/common/x_state.dart';

abstract class ImageColoredState<T extends StatefulWidget> extends XState<T> {
  Image? coverImage;
  Color? mainColor;
  bool imageLoading = true;

  _updateMainColor(Color mainColor) {
    setState(() {
      this.mainColor = mainColor;
    });
  }
  _updateImageLoading(bool imageLoading) {
    setState(() {
      this.imageLoading = imageLoading;
    });
  }
  _updateCoverImage(Image coverImage) {
    setState(() {
      this.coverImage = coverImage;
    });
  }

  @override
  void preloadImage(image, [Function? updateImage, Function? updateImageLoading]) {
    super.preloadImage(image, _updateCoverImage, _updateImageLoading);
  }

  @override
  void preloadImageWithColor(image, [Function? updateColor]) {
    super.preloadImageWithColor(image, _updateMainColor);
  }

  @override
  void checkColor(Color color, [Function? updateColor]) async {
    super.checkColor(color, _updateMainColor);
  }

  @override
  void calcMainColor(Image? image, [Function? updateColor]) {
    super.calcMainColor(image, _updateMainColor);
  }
}