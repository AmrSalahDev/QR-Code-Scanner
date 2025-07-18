import 'package:flutter/material.dart';

class ScreenUtils {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  static bool isMobileLandscape(BuildContext context) =>
      isMobile(context) && isLandscape(context);

  static DeviceType getDeviceType(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    if (width >= 900 && height <= 1000) {
      return DeviceType.tabletLandscape;
    } else if (width >= 600 && width <= 800 && height >= 900) {
      return DeviceType.tabletPortrait;
    } else if (width >= 480) {
      return DeviceType.largePhone;
    } else if (width >= 390) {
      return DeviceType.mediumPhone;
    } else {
      return DeviceType.smallPhone;
    }
  }

  static T getResponsiveSize<T>(
    BuildContext context, {
    required T smallPhone,
    required T mediumPhone,
    required T largePhone,
    required T tabletPortrait,
    required T tabletLandscape,
  }) {
    switch (getDeviceType(context)) {
      case DeviceType.smallPhone:
        print('smallPhone');
        return smallPhone;
      case DeviceType.mediumPhone:
        print('mediumPhone');
        return mediumPhone;
      case DeviceType.largePhone:
        print('largePhone');
        return largePhone;
      case DeviceType.tabletPortrait:
        print('tabletPortrait');
        return tabletPortrait;
      case DeviceType.tabletLandscape:
        print('tabletLandscape');
        return tabletLandscape;
    }
  }
}

enum DeviceType {
  smallPhone,
  mediumPhone,
  largePhone,
  tabletPortrait,
  tabletLandscape,
}
