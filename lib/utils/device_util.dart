import 'package:flutter/material.dart';

enum ScreenType { phone, tablet, desktop }

const tabletWidth = 600;
const desktopWidth = 900; 

ScreenType getScreenType(BuildContext context) { 
  double deviceWidth = MediaQuery.of(context).size.shortestSide;
  if (deviceWidth > desktopWidth) return ScreenType.desktop;
  if (deviceWidth > tabletWidth) return ScreenType.tablet;
  return ScreenType.phone;
}