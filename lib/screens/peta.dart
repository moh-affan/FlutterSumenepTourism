import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sumenep_tourism/models/wisata.dart';
import 'package:sumenep_tourism/utils/distance.util.dart';

class PetaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PetaPageState();
}

class PetaPageState extends State<PetaPage> {
  final MethodChannel methodChannel =
      MethodChannel("com.affan.sumenep_tourism/method_channel");
  CameraPosition _centerPosition = CameraPosition(
    target: LatLng(-7.008332, 113.8597028),
    zoom: 14.4746,
  );
  var location = new Location();
  GoogleMapController googleMapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<MarkerId, Wisata> markerWisata = <MarkerId, Wisata>{};
  MarkerId selectedMarker;
  LocationData currentLocation;
  List<Wisata> listWisata = List<Wisata>();
  bool filter = false;

  void _loadData() async {
    var strWisata = await DefaultAssetBundle.of(context)
        .loadString("assets/json/wisata.json");
    final jsonWisata = jsonDecode(strWisata);
    listWisata = (jsonWisata['wisata'] as List)
        .map((json) => Wisata.fromJson(json))
        .toList();
    loadMarkers(listWisata);
    setState(() {});
  }

  void initLocation() async {
    try {
      currentLocation = await location.getLocation();
      _centerPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 14.4746,
      );
      print("${currentLocation.latitude} : ${currentLocation.longitude}");
      setState(() {});
      if (googleMapController != null) {
        googleMapController
            .animateCamera(CameraUpdate.newCameraPosition(_centerPosition));
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        var error = 'Permission denied';
      }
    }
  }

  void _onMarkerTapped(MarkerId markerId) async {
    final Marker tappedMarker = markers[markerId];
    final Wisata wisata = markerWisata[markerId];
    var distance = currentLocation != null
        ? getDistanceBetweenCoord(
            LatLng(currentLocation.latitude, currentLocation.longitude),
            LatLng(wisata.koordinat.latitude, wisata.koordinat.longitude))
        : "invalid";
    print("distance : $distance");
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  void loadMarkers(List<Wisata> listWisata) {
    print("Wisata length : ${listWisata.length}");
    listWisata.forEach((Wisata w) {
      _add(w);
    });
  }

  void _add(Wisata wisata) {
    final String markerIdVal = 'marker_id_${wisata.nama}';
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        wisata.koordinat.latitude,
        wisata.koordinat.longitude,
      ),
      infoWindow: InfoWindow(
          title: wisata.nama,
          snippet: "${wisata.deskripsi}",
          onTap: () async {
            var res = await methodChannel.invokeMethod("showDetail", {
              "vrImage": wisata.vrImage,
              "deskripsi": wisata.deskripsi,
              "nama": wisata.nama,
            });
          }),
      onTap: () {
        _onMarkerTapped(markerId);
      },
    );

    setState(() {
      markers[markerId] = marker;
      markerWisata[markerId] = wisata;
    });
  }

  @override
  void initState() {
    super.initState();
    initLocation();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          markerWisata.clear();
          markers.clear();
          if (!filter) {
            var nearby = listWisata.where((Wisata wisata) {
              var distance = currentLocation != null
                  ? getDistanceBetweenCoord(
                      LatLng(
                          currentLocation.latitude, currentLocation.longitude),
                      LatLng(wisata.koordinat.latitude,
                          wisata.koordinat.longitude))
                  : 1000;
              return distance <= 10;
            });
            loadMarkers(nearby.toList());
          } else {
            loadMarkers(listWisata);
          }
          filter = !filter;
          setState(() {});
        },
        child: Icon(Icons.near_me),
      ),
      appBar: AppBar(
        title: Text("Peta Wisata"),
        automaticallyImplyLeading: true,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        initialCameraPosition: _centerPosition,
        markers: Set<Marker>.of(markers.values),
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
    );
  }
}
