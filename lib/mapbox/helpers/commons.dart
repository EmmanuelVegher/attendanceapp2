import 'package:intl/intl.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../constants/offices.dart';

//Navigation Part
LatLng getLatLngFromOfficeData(int index) {
  return LatLng(double.parse(offices[index]['coordinates']['latitude']),
      double.parse(offices[index]['coordinates']['longitude']));
}

//Turn By Turn Part
String getDropOffTime(num duration) {
  int minutes = (duration / 60).round();
  int seconds = (duration % 60).round();
  DateTime tripEndDateTime =
  DateTime.now().add(Duration(minutes: minutes, seconds: seconds));
  String dropOffTime = DateFormat.jm().format(tripEndDateTime);
  return dropOffTime;
}
