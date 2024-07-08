// Here we would create functions to get longitude and latitude

import 'package:location/location.dart';

class LocationService {
  //import Location from Location Class , and not from Geocoding location
  Location location = Location();
  late LocationData _locDate;
  late bool locationServiceEnabled;
  var locationPermissionGranted;

  Future<void> initialize() async {
    bool serviceEnabled;
    PermissionStatus permission;

    //Check if location is enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission == PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<double?> getLatitude() async {
    _locDate = await location.getLocation();
    return _locDate.latitude;
  }

  Future<double?> getLongitude() async {
    _locDate = await location.getLocation();
    return _locDate.longitude;
  }

  Future<bool?> getLocationStatus() async {
    return locationServiceEnabled = await location.serviceEnabled();
  }

  Future getPermissionStatus() async {
    return locationPermissionGranted = await location.hasPermission();
  }
}
