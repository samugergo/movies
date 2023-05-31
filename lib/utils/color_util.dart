import 'package:flutter/material.dart';
import 'package:movies/theme/app_colors.dart';
import 'package:palette_generator/palette_generator.dart';

darken(Color c, Function callback) async {
  const percent = 40;
  assert(1 <= percent && percent <= 100);
  var f = 1 - percent / 100;
  callback(
    Color.fromARGB(
      c.alpha,
      (c.red * f).round(),
      (c.green  * f).round(),
      (c.blue * f).round()
    )
  );
}

darkenSync(Color c) {
  const percent = 40;
  assert(1 <= percent && percent <= 100);
  var f = 1 - percent / 100;
  return Color.fromARGB(
    c.alpha,
    (c.red * f).round(),
    (c.green  * f).round(),
    (c.blue * f).round()
  );
}

getImagePalette(ImageProvider imageProvider) async {
  final PaletteGenerator paletteGenerator = await PaletteGenerator
      .fromImageProvider(imageProvider);
  return paletteGenerator.dominantColor?.color ?? AppColors.theme.primary;
}

Color checkColor(Color color) {
  bool isLight = ThemeData.estimateBrightnessForColor(color) == Brightness.light;
  return isLight ? darkenSync(color) : color;  
}

void calcMainColor(Image? image, Function callback) async {
  if(image != null) {
    var c = await getImagePalette(image.image);
    var color = checkColor(c);
    callback(color);
  }
}

getColorFromImage(String? image, Function callback) async {
  if (image == null || image == '') {
    callback(Colors.black);
  }
  var loadedImage = Image.network(image!);
  loadedImage.image.resolve(ImageConfiguration()).addListener(
    ImageStreamListener(
      (info, call) {
        calcMainColor(loadedImage, callback);
      },
    ),
  );
}