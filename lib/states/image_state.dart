import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/color_util.dart';

abstract class ImageState<T extends StatefulWidget> extends State<T> {
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

  @protected
  void init() async {}

  bool isLoading() {
    return this.imageLoading || mainColor == null;
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void preloadImage(image) {
    if (image == null || image == '') {
      _updateImageLoading(false);
      return;
    }
    var loadedImage = Image.network(image);
    loadedImage.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, call) {
          _updateImageLoading(false);
          _updateCoverImage(loadedImage);
        },
      ),
    );
  }

  /// Preloads the specified image to prevent flickering
  ///
  /// [Image] image - image to preload
  /// [Function] setLoading - function to update loading variable
  /// [Function] callback - function to use the loaded image
  void preloadImageWithColor(image) {
    if (image == null || image == '') {
      _updateMainColor(AppColors.theme.primary!);
      return;
    }
    var loadedImage = Image.network(image);
    loadedImage.image.resolve(ImageConfiguration()).addListener(ImageStreamListener((info, call) {
      calcMainColor(loadedImage);
    }));
  }

  /// Check the color if too bright make it darker
  ///
  /// [Color] color - the color to check
  void checkColor(Color color) async {
    bool isLight = ThemeData.estimateBrightnessForColor(color) == Brightness.light;
    if (isLight) {
      darken(color, _updateMainColor);
    }
  }

  /// Calculate the main color from the cover image
  ///
  /// [Image] image - the to calculate the main color
  /// [Color] color - variable to update with the main color
  void calcMainColor(Image? image) async {
    if (image != null) {
      var color = await getImagePalette(image.image);
      _updateMainColor(color);
      this.checkColor(color);
    }
  }
}
