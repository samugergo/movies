import 'package:flutter/material.dart';
import 'package:movies/theme/app_colors.dart';
import 'package:palette_generator/palette_generator.dart';

/// This function is used to darken a color. It darken the color with a specified 40 percent
/// to the white text can be read easily.
///
/// [Color] is the color to be darkened
/// [Function] is a callback which is called when the color is darkened.
darken(Color c, Function callback) async {
  const percent = 40;
  assert(1 <= percent && percent <= 100);
  var f = 1 - percent / 100;
  callback(
      Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(), (c.blue * f).round()));
}

/// It is a synchronized version of the above function but does exactly the same thing.
///
/// [Color] is the color to be darkened.
darkenSync(Color c) {
  const percent = 40;
  assert(1 <= percent && percent <= 100);
  var f = 1 - percent / 100;
  return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(), (c.blue * f).round());
}

/// This function is return the dominant color of an image. This is very expensive
/// to calculate so it is async and should be used only when it is necessary!
///
/// [ImageProvider] is the image you want to use for calculating the dominant color
getImagePalette(ImageProvider imageProvider) async {
  final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
  return paletteGenerator.dominantColor?.color ?? AppColors.theme.primary;
}

/// This functon checks the given color and if it is needed calls the [darkenSync] function
/// to darken the color for the white text.
///
/// [Color] is the color to check.
Color checkColor(Color color) {
  bool isLight = ThemeData.estimateBrightnessForColor(color) == Brightness.light;
  return isLight ? darkenSync(color) : color;
}

/// This function calculates the main color for the movie/show page. It uses all the necessary
/// functions above to achive this.
///
/// [Image] is the image to use for calulation.
/// [Function] is a callback to call when the calculation is finished.
void calcMainColor(Image? image, Function callback) async {
  if (image != null) {
    var c = await getImagePalette(image.image);
    var color = checkColor(c);
    callback(color);
  }
}

/// This function does exactly the same thing as [calcMainColor] except it is not needed to the image
/// being preloaded this function preloads the image first.
///
/// [String] is url of the image.
/// [Function] is a callback to call when the calculation is finished.
getColorFromImage(String? image, Function callback) async {
  if (image == null || image == '') {
    callback(Colors.black);
  }
  var loadedImage = Image.network(image!);
  loadedImage.image.resolve(ImageConfiguration()).addListener(ImageStreamListener((info, call) {
    calcMainColor(loadedImage, callback);
  }));
}
