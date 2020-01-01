import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sumenep_tourism/constant/navigations.dart';
import 'package:sumenep_tourism/screens/beranda.dart';
import 'package:sumenep_tourism/screens/splash.dart';

Route generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.BERANDA:
      return buildRoute(settings, BerandaPage());
    default:
      return buildRoute(settings, Splash());
  }
}

MaterialPageRoute buildRoute(RouteSettings settings, Widget builder) {
  return new MaterialPageRoute(
      settings: settings, builder: (BuildContext context) => builder);
}
