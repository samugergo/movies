import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/theme/app_colors.dart';

const Color grad1 = Color(0xff0B1433);
const Color grad2 = Color(0xff332F57);

class GradientContainer extends StatelessWidget {
  final Widget child;
  final Color? color;

  GradientContainer({
    required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppColors>()!;

    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.5, 1],
                colors: [theme.primary!, theme.secondary!],
                tileMode: TileMode.mirror)),
        child: AnnotatedRegion(
            value: SystemUiOverlayStyle.light.copyWith(statusBarColor: color ?? theme.primary),
            child: SafeArea(child: child)));
  }
}
