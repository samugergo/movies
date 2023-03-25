import 'package:flutter/material.dart';
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
  const percent = 20;
  assert(1 <= percent && percent <= 100);
  var f = 1 - percent / 100;
  return Color.fromARGB(
    c.alpha,
    (c.red * f).round(),
    (c.green  * f).round(),
    (c.blue * f).round()
  );
}

getImagePalette (ImageProvider imageProvider) async {
  final PaletteGenerator paletteGenerator = await PaletteGenerator
      .fromImageProvider(imageProvider);
  return paletteGenerator.dominantColor?.color ?? Color(0xff292A37);
}