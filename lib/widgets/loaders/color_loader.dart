import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ColorLoader extends StatelessWidget {
  ColorLoader({
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: LoadingAnimationWidget.fourRotatingDots(
        color: Colors.white, 
        size: 50
      ),
    );
  }
}