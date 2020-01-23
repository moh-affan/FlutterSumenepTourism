import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sumenep_tourism/constant/app.dart';
import 'package:sumenep_tourism/constant/navigations.dart';
import 'package:sumenep_tourism/models/wisata.dart';
import 'package:sumenep_tourism/screens/pencarian.dart';
import 'package:sumenep_tourism/screens/tentang_sumenep.dart';
import 'package:sumenep_tourism/widgets/carousel.dart';

class BerandaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BerandaPageState();
}

class BerandaPageState extends State<BerandaPage>
    with SingleTickerProviderStateMixin {
  double height, width;
  List<Wisata> listWisata;
  TabController _tabController;
  final MethodChannel methodChannel =
      MethodChannel("com.affan.sumenep_tourism/method_channel");
  final ScrollController _scrollController = ScrollController();

  void _onSliderChanged(int index) {
    print('index now is $index');
  }

  @override
  void initState() {
    super.initState();
    listWisata = List<Wisata>();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    _tabController.addListener(onTabChange);
    _loadData();
    _scrollController.addListener(() {
      print(_scrollController.offset);
    });
  }

  void onTabChange() {
    print(_tabController.index);
//    if (_tabController.index == 1) {
//      Navigator.of(context).pushNamed(AppRoutes.PETA);
//    }
  }

  void _loadData() async {
    var strWisata = await DefaultAssetBundle.of(context)
        .loadString("assets/json/wisata.json");
    final jsonWisata = jsonDecode(strWisata);
    listWisata = (jsonWisata['wisata'] as List)
        .map((json) => Wisata.fromJson(json))
        .toList();
    setState(() {});
  }

  Widget _buidBody() {
    return Stack(
      children: <Widget>[
        GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(20),
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: listWisata
              .map((wisata) => Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: ExactAssetImage(wisata.gambar))),
                    child: InkWell(
                      onTap: () async {
                        print(wisata.nama);
                        var res =
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
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ));

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    MyAppContext.context = context;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => TentangSumenepPage()));
        },
        child: Icon(Icons.info_outline),
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                pinned: true,
                floating: false,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      print("on tap");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PencarianPage()));
                    },
                  )
                ],
//                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  collapseMode: CollapseMode.parallax,
                  title: Text(
                    "Sumenep Tourism",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontFamily: "Lobster",
                        shadows: [
                          Shadow(
                              color: Colors.black54,
                              offset: Offset(.5, .5),
                              blurRadius: 1.5)
                        ]),
                  ),
                  background: Carousel(
                    items: [
                      Image.asset(
                        "assets/img/gili_labak.jpg",
                        fit: BoxFit.fitWidth,
                      ),
                      Image.asset("assets/img/gili_genting.jpg",
                          fit: BoxFit.fitWidth),
                      Image.asset("assets/img/masjid.jpg", fit: BoxFit.cover),
                    ],
                    autoPlay: true,
                    viewportFraction: 1.0,
                    height: 250,
                    onPageChanged: _onSliderChanged,
                    withIndicator: true,
                    enlargeCenterPage: true,
                    aspectRatio: 1,
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: Colors.black87,
                    controller: _tabController,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      ListTile(
                          leading: Icon(Icons.apps), title: Text("Wisata")),
                      ListTile(
                        leading: Icon(Icons.map),
                        title: Text("Peta"),
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutes.PETA);
                        },
                      ),
                    ],
                  ),
                ),
                pinned: true,
//                floating: false,
              ),
            ];
          },
          body: _buidBody(),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
