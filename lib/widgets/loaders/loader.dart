import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/widgets/containers/gradient_container.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = getAppTheme(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 1],
          colors: [
            theme.primary!, 
            theme.primaryLight!
          ],
          tileMode: TileMode.mirror
        ),
      ),
      child: Center(
        child: LoadingAnimationWidget.fourRotatingDots(
          color: Colors.white, 
          size: 50
        ),
      ),
    );
  }
}