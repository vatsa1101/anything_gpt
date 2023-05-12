import 'package:flutter/material.dart';

Size displaySize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  return displaySize(context).height;
}

double displayWidth(BuildContext context) {
  return displaySize(context).width;
}

double dp(BuildContext context) {
  return MediaQuery.of(context).devicePixelRatio;
}

const int largeScreenSize = 1366;
const int mediumScreenSize = 768;
const int smallScreenSize = 360;

bool isSmallScreen(double width) {
  return width < mediumScreenSize;
}

bool isMediumScreen(double width) {
  return width >= mediumScreenSize && width < largeScreenSize;
}

bool isLargeScreen(double width) {
  return width >= largeScreenSize;
}
