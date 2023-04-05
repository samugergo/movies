import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/theme/app_colors.dart';

class GradientContainer extends StatelessWidget {

  final Widget child;

  GradientContainer({
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppColors>()!;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 1],
          colors: [
            theme.primary!, 
            theme.secondary!
          ],
          tileMode: TileMode.mirror
        ),
      ),
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light.copyWith(           
          statusBarColor: theme.primary,
        ),
        child: SafeArea(
          child: child,
        )
      ),
    );
  }
}