import 'dart:convert';

import 'package:attendanceapp/model/user_model.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:attendanceapp/main.dart';

//Bot Navigation and Turn-by-turn
LatLng getLatLngFromSharedPrefs() {
  return LatLng(UserModel.lat, UserModel.long);
  // (pref.getDouble('latitude')!, pref.getDouble('longitude')!);
}

// Turn-By-Turn Part
String getCurrentAddressFromSharedPrefs() {
  return pref.getString('current-address')!;
}

LatLng getTripLatLngFromSharedPrefs(String type) {
  List sourceLocationList = json.decode(pref.getString('source')!)['location'];
  List destinationLocationList =
      json.decode(pref.getString('destination')!)['location'];
  LatLng source = LatLng(sourceLocationList[0], sourceLocationList[1]);
  LatLng destination =
      LatLng(destinationLocationList[0], destinationLocationList[1]);

  if (type == 'source') {
    return source;
  } else {
    return destination;
  }
}

String getSourceAndDestinationPlaceText(String type) {
  String sourceAddress = json.decode(pref.getString('source')!)['name'];
  String destinationAddress =
      json.decode(pref.getString('destination')!)['name'];

  if (type == 'source') {
    return sourceAddress;
  } else {
    return destinationAddress;
  }
}

// Navigation Part

Map getDecodedResponseFromSharedPrefs(int index) {
  String key = 'restaurant--$index';
  Map response = json.decode(pref.getString(key)!);
  return response;
}

num getDistanceFromSharedPrefs(int index) {
  num distance = getDecodedResponseFromSharedPrefs(index)['distance'];
  return distance;
}

num getDurationFromSharedPrefs(int index) {
  num duration = getDecodedResponseFromSharedPrefs(index)['duration'];
  return duration;
}

Map getGeometryFromSharedPrefs(int index) {
  Map geometry = getDecodedResponseFromSharedPrefs(index)['geometry'];
  return geometry;
}
