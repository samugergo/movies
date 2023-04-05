import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.primaryLight,
    required this.secondary,
    required this.iconColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
  });

  final Color? primary;
  final Color? primaryLight;
  final Color? secondary;
  final Color? iconColor;
  final Color? primaryTextColor;
  final Color? secondaryTextColor;

  static const theme = AppColors(
    primary: Color(0xff292A37),
    primaryLight: Color(0xff343643),
    secondary: Color(0xff0F1018),
    iconColor: Colors.white,
    primaryTextColor: Colors.white,
    secondaryTextColor: Colors.white70
  );

  @override
  ThemeExtension<AppColors> copyWith({
    Color? primary,
    Color? primaryLight,
    Color? secondary,
    Color? iconColor,
    Color? primaryTextColor,
    Color? secondaryTextColor,
  }) {
    return AppColors(
      primary: primary ?? this.primary, 
      primaryLight: primaryLight ?? this.primaryLight, 
      secondary: secondary ?? this.secondary,
      iconColor: iconColor ?? this.iconColor,
      primaryTextColor: primaryTextColor ?? this.primaryTextColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(covariant ThemeExtension<AppColors>? other, double t) {
    if(other is! AppColors) {
      return this;
    }
    return AppColors(
      primary: Color.lerp(primary, other.primary, t), 
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t), 
      secondary: Color.lerp(secondary, other.secondary, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      primaryTextColor: Color.lerp(primaryTextColor, other.primaryTextColor, t),
      secondaryTextColor: Color.lerp(secondaryTextColor, other.secondaryTextColor, t),
    );
  }
}