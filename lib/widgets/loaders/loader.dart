import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movies/widgets/containers/gradient_container.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  GradientContainer(
      child: Center(
        child: LoadingAnimationWidget.fourRotatingDots(
          color: Colors.white, 
          size: 50
        ),
      ),
    );
  }
}