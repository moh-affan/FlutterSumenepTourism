import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sumenep_tourism/config/ioc.dart';
import 'package:sumenep_tourism/constant/app.dart';
import 'package:sumenep_tourism/constant/colors.dart';
import 'package:sumenep_tourism/constant/navigations.dart';
import 'package:sumenep_tourism/services/database.service.dart';

class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  List<PermissionGroup> permissions = new List<PermissionGroup>();
  int count = 0;

  void _navigateHome() async {
    var _prefs = await SharedPreferences.getInstance();
    Navigator.of(context).pushReplacementNamed(AppRoutes.BERANDA);
  }

  _startTime() async {
    var _duration = Duration(seconds: 5);
    return Timer(_duration, _navigateHome);
  }

  checkPermissions() async {
    PermissionStatus permissionStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permissionStatus != PermissionStatus.granted)
      permissions.add(PermissionGroup.storage);
    if (permissions.isNotEmpty) await requestPermission();
  }

  requestPermission() async {
    await PermissionHandler()
        .requestPermissions(permissions)
        .then((result) async {
      if (result[PermissionGroup.storage] == PermissionStatus.granted) {
        print('permission granted');
        await ioc.get<SqliteDbService>().initDatabase();
        var path = ioc.get<SqliteDbService>().dbPathName;
        var exist = await io.File(path).exists();
        print('$path exist $exist');
      }
    });
  }

  @override
  void initState() {
    checkPermissions();
    _startTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyAppContext.context = context;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));

    return Scaffold(
        body: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          alignment: Alignment.centerRight,
          image: ExactAssetImage('assets/img/gili_labak.jpg'),
        ),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  BlueRaspberry.end.withOpacity(.8),
                  BlueRaspberry.start.withOpacity(0.2)
                ],
                begin: Alignment(1.0, 0),
                end: Alignment(1.0, 2.0),
              ),
            ),
          ),
          Positioned(
            top: height / 3,
            left: 0,
            right: 0,
            child: Container(
              width: width,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Sumenep Tourism",
                      style: TextStyle(
                          fontFamily: "Lobster",
                          fontSize: 30,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                color: Colors.black54,
                                offset: Offset(.5, .5),
                                blurRadius: 1.5)
                          ]),
                    ),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.contain,
                              image: ExactAssetImage("assets/img/visit.png"))),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: width,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation(Colors.black12),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Versi ' + App.VERSION,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
