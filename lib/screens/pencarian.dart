import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sumenep_tourism/models/wisata.dart';

class PencarianPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PencarianPageState();
}

class PencarianPageState extends State<PencarianPage> {
  double height, width;
  List<Wisata> listWisata;
  StreamController<List<Wisata>> _streamController =
      StreamController<List<Wisata>>();
  final MethodChannel methodChannel =
      MethodChannel("com.affan.sumenep_tourism/method_channel");
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listWisata = List<Wisata>();
    _loadData();
    _textEditingController.addListener(() {
      print(_textEditingController.text);
      if (_textEditingController.text.isNotEmpty) {
        var filtered = listWisata.where((Wisata wisata) {
          var tes = wisata.nama
              .toLowerCase()
              .contains(_textEditingController.text.toLowerCase());
          print(tes);
          return wisata.nama
              .toLowerCase()
              .contains(_textEditingController.text.toLowerCase());
        }).toList();
        print(filtered.length);
        _streamController.sink.add(filtered);
      } else {
        _streamController.sink.add(listWisata);
      }
    });
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void _loadData() async {
    var strWisata = await DefaultAssetBundle.of(context)
        .loadString("assets/json/wisata.json");
    final jsonWisata = jsonDecode(strWisata);
    listWisata = (jsonWisata['wisata'] as List)
        .map((json) => Wisata.fromJson(json))
        .toList();
    _streamController.sink.add(listWisata);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        title: TextFormField(
          autofocus: true,
          controller: _textEditingController,
          decoration: InputDecoration(hintText: "Cari..."),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buidBody(),
    );
  }

  Widget _buidBody() {
    return Container(
        child: StreamBuilder(
      stream: _streamController.stream,
      initialData: List<Wisata>(),
      builder: (BuildContext ctx, AsyncSnapshot<List<Wisata>> snapshot) {
        return GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(20),
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: snapshot.data
              .map((wisata) => Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: ExactAssetImage(wisata.gambar))),
                    child: InkWell(
                      onTap: () async {
                        print(wisata.nama);
                        await methodChannel.invokeMethod("showDetail", {
                          "vrImage": wisata.vrImage,
                          "deskripsi": wisata.deskripsi,
                          "nama": wisata.nama,
                        });
                      },
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            wisata.nama,
                            style: TextStyle(
                                fontFamily: "Rubik",
                                color: Colors.white,
                                fontSize: 18,
                                shadows: [
                                  Shadow(
                                      color: Colors.black54,
                                      offset: Offset(.9, .9),
                                      blurRadius: 1.5)
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        );
      },
    ));
  }
}
