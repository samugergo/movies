import 'package:flutter/material.dart';
import 'package:movies/utils/color_util.dart';

abstract class XState<T extends StatefulWidget> extends State<T> {
  Function _callOptionalFunction = (function, param) => {
    if(function != null) {
      function(param)
    }
  };

  @protected
  void init() async {}

  @protected
  bool isLoading();

  @protected
  void preloadImage(image, [Function? updateImage, Function? updateImageLoading]) {
    if(image == null || image == '') {
      _callOptionalFunction(updateImageLoading, false);
      return;
    }
    var loadedImage = Image.network(image);
    loadedImage.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, call) {
          _callOptionalFunction(updateImageLoading, false);
          _callOptionalFunction(updateImage, loadedImage);
        },
      ),
    );
  }

  /// Preloads the specified image to prevent flickering
  /// 
  /// [Image] image - image to preload
  /// [Function] setLoading - function to update loading variable
  /// [Function] callback - function to use the loaded image
  /// 
  @protected
  void preloadImageWithColor(image, [Function? updateColor]) {
    if(image == null || image == '') {
      _callOptionalFunction(updateColor, Color(0xff292A37));
      return;
    }
    var loadedImage = Image.network(image);
    loadedImage.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, call) {
          calcMainColor(loadedImage, updateColor);
        },
      ),
    );
  }

  /// Check the color if too bright make it darker
  ///  
  /// [Color] color - the color to check
  /// 
  @protected
  void checkColor(Color color, [Function? updateColor]) async {
    if(updateColor == null) {
      return;
    }
    bool isLight = ThemeData.estimateBrightnessForColor(color) == Brightness.light;
    if(isLight) {
      darken(color, updateColor);
    }
  }

  /// Calculate the main color from the cover image
  /// 
  /// [Image] image - the to calculate the main color
  /// [Color] color - variable to update with the main color
  /// 
  @protected
  void calcMainColor(Image? image, [Function? updateColor]) async {
    if(updateColor == null) {
      return;
    }
    if(image != null) {
      var color = await getImagePalette(image.image);
      updateColor(color);
      this.checkColor(
        color,
        updateColor
      );
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}