//import 'dart:async';
//
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//
//void main() => runApp(MyApp());
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Demo',
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: MyHomePage(title: 'Flutter Demo Home Page'),
//    );
//  }
//}
//
//// ignore: must_be_immutable
//class MyHomePage extends StatelessWidget {
//  int _counter = 0;
//  final StreamController<int> _streamController = new StreamController<int>();
//  final MethodChannel methodChannel =
//      MethodChannel("com.affan.sumenep_tourism/method_channel");
//  final String title;
//
//  MyHomePage({this.title});
//
//  void _incrementCounter() async {
//    var res =
//        await methodChannel.invokeMethod("increment", {"counter": _counter});
//    print(res);
//    _streamController.sink.add(++_counter);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(title),
//      ),
//      body: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text(
//              'You have pushed the button this many times:',
//            ),
//            StreamBuilder<int>(
//              initialData: 0,
//              stream: _streamController.stream,
//              builder: (c, s) {
//                return Text(
//                  '${s.data}',
//                  style: Theme.of(context).textTheme.display1,
//                );
//              },
//            ),
//          ],
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
//    );
//  }
//}
