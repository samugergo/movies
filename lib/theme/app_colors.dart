import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.primaryLight,
    required this.secondary,
    required this.iconColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.unselected,
    required this.selected,
    required this.hidable,
  });

  final Color? primary;
  final Color? primaryLight;
  final Color? secondary;
  final Color? iconColor;
  final Color? primaryTextColor;
  final Color? secondaryTextColor;
  final Color? unselected;
  final Color? selected;
  final Color? hidable;

  static const theme = AppColors(
    // primary: Color(0xff03001C),
    primary: Color(0xff292A37),
    primaryLight: Color(0xff343643),
    secondary: Color(0xff0F1018),
    iconColor: Colors.white,
    primaryTextColor: Colors.white,
    secondaryTextColor: Colors.white70,
    unselected: Color.fromRGBO(117, 117, 117, 1),
    selected: Colors.white,
    hidable: Color.fromARGB(206, 0, 0, 0),
  );

  @override
  ThemeExtension<AppColors> copyWith({
    Color? primary,
    Color? primaryLight,
    Color? secondary,
    Color? iconColor,
    Color? primaryTextColor,
    Color? secondaryTextColor,
    Color? unselected,
    Color? selected,
    Color? hidable,
  }) {
    return AppColors(
      primary: primary ?? this.primary, 
      primaryLight: primaryLight ?? this.primaryLight, 
      secondary: secondary ?? this.secondary,
      iconColor: iconColor ?? this.iconColor,
      primaryTextColor: primaryTextColor ?? this.primaryTextColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      unselected: unselected ?? this.unselected,
      selected: selected ?? this.selected,
      hidable: hidable ?? this.hidable,
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
      unselected: Color.lerp(unselected, other.unselected, t),
      selected: Color.lerp(selected, other.selected, t),
      hidable: Color.lerp(hidable, other.hidable, t),
    );
  }
}