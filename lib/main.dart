import 'package:flutter/material.dart';
import 'package:sumenep_tourism/constant/app.dart';

import 'config/routes.dart';
import 'constant/navigations.dart';
import 'environtment.dart';

void main() async {
  await Environtment.setup();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyAppContext.context = context;

    return MaterialApp(
      title: 'Sumenep Tourism',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'BPreplay',
      ),
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoutes,
      navigatorKey: AppRoutes.navKey,
    );
  }
}
