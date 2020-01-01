import 'package:flutter/material.dart';

class JShine {
  static const start = Color(0xff12c2e9);
  static const middle = Color(0xffc471ed);
  static const end = Color(0xfff64f59);
}

class Quepal {
  static const start = Color(0xff11998e);
  static const end = Color(0xff38ef7d);
}

class BlueRaspberry {
  static const start = Color(0xff00B4DB);
  static const end = Color(0xff0083B0);
}

class MoonLite {
  static const start = Color(0xff0F2027);
  static const middle = Color(0xff203A43);
  static const end = Color(0xff2C5364);
}

class Liquid {
  static const colorPrimary = BlueRaspberry.start /*Color(0xff55C3FE)*/;
  static const colorLight = Color(0xff55C3FE) /*Color(0xff6fcdff)*/;
  static const colorDark = BlueRaspberry.end /*Color(0xff4298c7)*/;
  static const colorAccent = Quepal.end;
}

class Subu {
  static const start = Color(0xff0cebeb);
  static const middle = Color(0xff20e3b2);
  static const end = Color(0xff29ffc6);
}

Shader createLinearGradientShader(List<Color> colors) {
  return LinearGradient(colors: colors)
      .createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
}

final Color bgColor = Color(0xfff2f2f2);
final Color borderColor = Color(0xffd6d6d6);
