// import 'package:attendanceapp/mapbox/helpers/commons.dart';
// import 'package:carousel_slider/carousel_options.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import '../constants/offices.dart';
// import '../helpers/shared_prefs.dart';
//
// class OfficesMap extends StatefulWidget {
//   const OfficesMap({Key? key}) : super(key: key);
//
//   @override
//   State<OfficesMap> createState() => _OfficesMapState();
// }
//
// class _OfficesMapState extends State<OfficesMap>
//     with AutomaticKeepAliveClientMixin {
//   // Mapbox related
//   LatLng latLng = getLatLngFromSharedPrefs();
//   late CameraPosition _initialCameraPosition;
//   late MapboxMapController controller;
//   late List<CameraPosition> _kOfficeList;
//   List<Map> carouselData = [];
//
//   // Carousel related
//   int pageIndex = 0;
//   bool accessed = false;
//   late List<Widget> carouselItems;
//
//   @override
//   void initState() {
//     super.initState();
//     _initialCameraPosition = CameraPosition(target: latLng, zoom: 15);
//
//     // Calculate the distance and time from data in SharedPreferences
//     for (int index = 0; index < offices.length; index++) {
//       num distance = getDistanceFromSharedPrefs(index) / 1000;
//       num duration = getDurationFromSharedPrefs(index) / 60;
//       carouselData
//           .add({'index': index, 'distance': distance, 'duration': duration});
//     }
//     carouselData.sort((a, b) => a['duration'] < b['duration'] ? 0 : 1);
//
//     // Generate the list of carousel widgets
//     carouselItems = List<Widget>.generate(
//       offices.length,
//           (index) => carouselCard(
//         index: carouselData[index]['index'],
//         distance: carouselData[index]['distance'],
//         duration: carouselData[index]['duration'],
//       ),
//     );
//
//     // Initialize map symbols in the same order as carousel widgets
//     _kOfficeList = List<CameraPosition>.generate(
//       offices.length,
//           (index) => CameraPosition(
//         target: getLatLngFromOfficeData(carouselData[index]['index']),
//         zoom: 15,
//       ),
//     );
//   }
//
//   Widget carouselCard({
//     required int index,
//     required num distance,
//     required num duration,
//   }) {
//     return Card(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text("Office ${offices[index]['name']}"),
//           Text("Distance: ${distance.toStringAsFixed(2)} km"),
//           Text("Duration: ${duration.toStringAsFixed(2)} mins"),
//         ],
//       ),
//     );
//   }
//
//   _addSourceAndLineLayer(int index, bool removeLayer) async {
//     // Can animate camera to focus on the item
//     controller
//         .animateCamera(CameraUpdate.newCameraPosition(_kOfficeList[index]));
//
//     // Add a polyLine between source and destination
//     Map geometry = getGeometryFromSharedPrefs(carouselData[index]['index']);
//     final _fills = {
//       "type": "FeatureCollection",
//       "features": [
//         {
//           "type": "Feature",
//           "id": 0,
//           "properties": <String, dynamic>{},
//           "geometry": geometry,
//         },
//       ],
//     };
//
//     // Remove lineLayer and source if it exists
//     if (removeLayer == true) {
//       await controller.removeLayer("lines");
//       await controller.removeSource("fills");
//     }
//
//     // Add new source and lineLayer
//     await controller.addSource("fills", GeojsonSourceProperties(data: _fills));
//     await controller.addLineLayer(
//       "fills",
//       "lines",
//       LineLayerProperties(
//         lineColor: Colors.green.toHexStringRGB(),
//         lineCap: "round",
//         lineJoin: "round",
//         lineWidth: 2,
//       ),
//     );
//   }
//
//   _onMapCreated(MapboxMapController controller) async {
//     this.controller = controller;
//   }
//
//   _onStyleLoadedCallback() async {
//     for (CameraPosition _kOffice in _kOfficeList) {
//       await controller.addSymbol(
//         SymbolOptions(
//           geometry: _kOffice.target,
//           iconSize: 0.2,
//           iconImage: "images/office18.png",
//         ),
//       );
//     }
//     _addSourceAndLineLayer(0, false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Office Map'),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Stack(
//             children: [
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.8,
//                 child: MapboxMap(
//                   accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
//                   initialCameraPosition: _initialCameraPosition,
//                   onMapCreated: _onMapCreated,
//                   onStyleLoadedCallback: _onStyleLoadedCallback,
//                   myLocationEnabled: true,
//                   myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
//                   minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
//                 ),
//               ),
//               CarouselSlider(
//                 items: carouselItems,
//                 options: CarouselOptions(
//                   height: 100,
//                   viewportFraction: 0.6,
//                   initialPage: 0,
//                   enableInfiniteScroll: false,
//                   scrollDirection: Axis.horizontal,
//                   onPageChanged:
//                       (int index, CarouselPageChangedReason reason) {
//                     setState(() {
//                       pageIndex = index;
//                     });
//                     _addSourceAndLineLayer(index, true);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           controller.animateCamera(
//             CameraUpdate.newCameraPosition(_initialCameraPosition),
//           );
//         },
//         child: const Icon(Icons.my_location),
//       ),
//     );
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }


import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class OfficesMap extends StatefulWidget {
  const OfficesMap({Key? key}) : super(key: key);

  @override
  State<OfficesMap> createState() => _OfficesMapState();
}

class _OfficesMapState extends State<OfficesMap>
    with AutomaticKeepAliveClientMixin {
  // Mapbox related
  LatLng? latLng;
  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;

  // Initialize carousel and other data here
  bool locationFetched = false;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Handle permission denied scenario
          return;
        }
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        latLng = LatLng(position.latitude, position.longitude);
        _initialCameraPosition = CameraPosition(target: latLng!, zoom: 15);
        locationFetched = true; // Location has been fetched
      });
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!locationFetched) {
      return Scaffold(
        appBar: AppBar(title: const Text('Office Map')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Office Map'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            MapboxMap(
              accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (MapboxMapController mapController) {
                controller = mapController;
              },
              myLocationEnabled: true,
              myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
              minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
            ),
            // Add other widgets like Carousel here
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.animateCamera(
            CameraUpdate.newCameraPosition(_initialCameraPosition),
          );
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
