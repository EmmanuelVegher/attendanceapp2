// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:attendanceapp/main.dart';
// import '../constants/offices.dart';
// import '../requests/mapbox_requests.dart';

// Future<Map> getDirectionsAPIResponse(LatLng currentLatLng, int index) async {
//   final response = await getCyclingRouteUsingMapbox(
//       currentLatLng,
//       LatLng(double.parse(offices[index]['coordinates']['latitude']),
//           double.parse(offices[index]['coordinates']['longitude'])));
//   Map geometry = response['routes'][0]['geometry'];
//   num duration = response['routes'][0]['duration'];
//   num distance = response['routes'][0]['distance'];
//   print('-------------------${offices[index]['name']}-------------------');
//   print(distance);
//   print(duration);

//   Map modifiedResponse = {
//     "geometry": geometry,
//     "duration": duration,
//     "distance": distance,
//   };
//   return modifiedResponse;
// }

// void saveDirectionsAPIResponse(int index, String response) {
//   pref.setString('restaurant--$index', response);
// }
