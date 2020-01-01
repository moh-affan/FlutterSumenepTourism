import 'dart:math' as math;

import 'package:google_maps_flutter/google_maps_flutter.dart';

double deg2rad(double deg) {
  return deg * (math.pi / 180);
}

double getDistanceBetweenCoord(LatLng from, LatLng to) {
  var R = 6372;
  var dLat = deg2rad(from.latitude - to.latitude);
  var dLon = deg2rad(from.longitude - to.longitude);
  var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(deg2rad(from.latitude)) *
          math.cos(deg2rad(to.latitude)) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);
  var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  var d = R * c;
  return d;
}
