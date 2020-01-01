import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class TentangSumenepPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TentangSumenepState();
}

class TentangSumenepState extends State<TentangSumenepPage> {
  String data = "";

  void loadData(BuildContext context) async {
    data = await DefaultAssetBundle.of(context)
        .loadString("assets/html/sumenep.html");
    print(data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    loadData(context);
    print(data);
    return Scaffold(
      appBar: AppBar(
        title: Text("Tentang Sumenep"),
        automaticallyImplyLeading: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Html(data: data),
      ),
    );
  }
}
