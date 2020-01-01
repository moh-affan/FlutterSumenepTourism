import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config/ioc.dart';

class Environtment {
  static setup() async {
    // lock orientation position
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    // transparent status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    Ioc.setupIocDependency();
    
  }
}
