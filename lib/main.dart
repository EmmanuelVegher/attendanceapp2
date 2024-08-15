import 'dart:async';
import 'dart:developer';
import 'package:attendanceapp/Pages/splash_screen.dart';
import 'package:attendanceapp/api/Attendance_gsheet_api.dart';
import 'package:attendanceapp/model/attendancemodel.dart';
import 'package:attendanceapp/services/attendance_service.dart';
import 'package:attendanceapp/services/flutter_background_service.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:attendanceapp/services/notification_services.dart';
import 'package:attendanceapp/widgets/constants.dart';
import 'package:attendanceapp/widgets/geo_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:screen_loader/screen_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'Pages/Attendance/clock_attendance.dart';
import 'Pages/auth_check.dart';
import 'model/locationmodel.dart';
import 'model/track_location_model.dart';
import 'services/background_service.dart';

// Define the global navigatorKey
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

int id = 0;
late SharedPreferences pref;
RxBool isDeviceConnected = false.obs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  tz.initializeTimeZones();

  // Initialize notification service
  await NotifyHelper().initializeNotification();

  // Check for Network Connection
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult != ConnectivityResult.none) {
    await Firebase.initializeApp();
  } else {
    print('No network connection available.');
  }

  pref = await SharedPreferences.getInstance();
  await AttendanceGSheetsApi.init();
  await Hive.initFlutter();
  await IsarService().openDB();
  configLoading();

  // Asynchronous tasks
  await  _updateEmptyLocationForTwelve().then((_)async{
    syncCompleteDataForLocationForTwelve();
  });
  await _updateEmptyClockInLocation().then((_) async {
    await _updateEmptyClockOutLocation();
  });

  configScreenLoader(
    loader: const AlertDialog(
      title: Text('Global Loader..'),
    ),
    bgBlur: 20.0,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());

  // Initialize and start the background service
  await initializeService();
}

// Update empty Clock-In location
Future<void> _updateEmptyClockInLocation() async {
  try {
    List<AttendanceModel> attendanceForEmptyLocation =
    await IsarService().getAttendanceForEmptyClockInLocation();

    for (var attend in attendanceForEmptyLocation) {
      List<Placemark> placemark = await placemarkFromCoordinates(
          attend.clockInLatitude!, attend.clockInLongitude!);

      IsarService().updateEmptyClockInLocation(
        attend.id,
        AttendanceModel(),
        "${placemark[0].street}, ${placemark[0].subLocality}, ${placemark[0].subAdministrativeArea}, ${placemark[0].locality}, ${placemark[0].administrativeArea}, ${placemark[0].postalCode}, ${placemark[0].country}",
      );
    }
  } catch (e) {
    log(e.toString());
  }
}

// Update empty Clock-Out location
Future<void> _updateEmptyClockOutLocation() async {
  try {
    List<AttendanceModel> attendanceForEmptyLocation =
    await IsarService().getAttendanceForEmptyClockOutLocation();

    for (var attend in attendanceForEmptyLocation) {
      List<Placemark> placemark = await placemarkFromCoordinates(
          attend.clockOutLatitude!, attend.clockOutLongitude!);

      IsarService().updateEmptyClockOutLocation(
        attend.id,
        AttendanceModel(),
        "${placemark[0].street}, ${placemark[0].subLocality}, ${placemark[0].subAdministrativeArea}, ${placemark[0].locality}, ${placemark[0].administrativeArea}, ${placemark[0].postalCode}, ${placemark[0].country}",
      );
    }
  } catch (e) {
    log(e.toString());
  }
}

Future<void> _updateEmptyLocationForTwelve() async {

  //First, query the list of all records with empty Clock-In Location
  List<TrackLocationModel> attendanceForEmptyLocationFor12 =
  await IsarService().getAttendanceForEmptyLocationFor12();

  try {
    for (var attend in attendanceForEmptyLocationFor12) {
      // Create a variable
      var location2 = "";
      bool isInsideAnyGeofence = false;
      List<Placemark> placemark = await placemarkFromCoordinates(
          attend.latitude!, attend.longitude!);

      List<LocationModel> isarLocations =
      await IsarService().getLocationsByState(placemark[0].administrativeArea);

      // Convert Isar locations to GeofenceModel
      List<GeofenceModel> offices = isarLocations.map((location) => GeofenceModel(
        name: location.locationName!, // Use 'locationName'
        latitude: location.latitude ?? 0.0,
        longitude: location.longitude ?? 0.0,
        radius: location.radius?.toDouble() ?? 0.0,
      )).toList();

      print("Officessss == ${offices}");

      isInsideAnyGeofence = false;
      for (GeofenceModel office in offices) {
        double distance = GeoUtils.haversine(
            attend.latitude!, attend.longitude!, office.latitude, office.longitude);
        if (distance <= office.radius) {
          print('Entered office: ${office.name}');

          location2 = office.name;
          isInsideAnyGeofence = true;
          break;
        }
      }

      if (!isInsideAnyGeofence) {
        List<Placemark> placemark = await placemarkFromCoordinates(
            attend.latitude!, attend.longitude!);

        location2 =
        "${placemark[0].street},${placemark[0].subLocality},${placemark[0].subAdministrativeArea},${placemark[0].locality},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";

        print("Location from map === ${location2}");
      }

      //Input the queried latitude and Lngitude, but also assign 0.0 to any null Latitude and Longitude


      //log("ClockOutPlacemarker = $location");

      //Update all missing Clock In location
      await IsarService().updateEmptyLocationFor12(
          attend.id, TrackLocationModel(), location2);
      //print(attend.clockInLatitude);
    }
  } catch (e) {
    log(e.toString());
  }

  //Iterate through each queried loop
}

Future<void>syncCompleteDataForLocationForTwelve() async {
  try {
    // The try block first of all saves the data in the google sheet for the visualization and then on the firebase database as an extra backup database  before chahing the sync status on Mobile App to "Synced"
    //Query the firebase and get the records having updated records
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("Staff")
        .where("id", isEqualTo: firebaseAuthId)
        .get();

    List<AttendanceModel> getAttendanceForPartialUnSynced =
    await IsarService().getAttendanceForPartialUnSynced();

    List<TrackLocationModel> getTracklocationForPartialUnSynced =
    await IsarService().getTracklocationForPartialUnSynced();

    for (var unSyncedTrackLocation in getTracklocationForPartialUnSynced){
      log("Synching Tracked location by 12pm");
      await FirebaseFirestore.instance
          .collection("Staff")
          .doc(snap.docs[0].id)
          .collection("LocationBy12PM")
          .doc(DateFormat('dd-MMMM-yyyy').format(unSyncedTrackLocation.timestamp!))
          .set({
        "latitudeBy12": unSyncedTrackLocation.latitude,
        'longitudeBy12': unSyncedTrackLocation.longitude,
        'Date': unSyncedTrackLocation.timestamp,
        'locationName': unSyncedTrackLocation.locationName,
      }).then((value){
        IsarService().updateSyncStatusForTrackLocationBy12(
            unSyncedTrackLocation.id, TrackLocationModel(), true);
      });
    }


  } catch (e) {
    // The catch block executes incase firebase database encounters an error thereby only saving the data in the google sheet for the analytics before chahing the sync status on Mobile App to "Synced"
    log("Sync Error Skipping firebase DB = ${e.toString()}");

  }
}



// Configure EasyLoading
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

// MyApp widget
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    // Add this instance as an observer to WidgetsBinding (only once)
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Attendance App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate,
      ],
      builder: EasyLoading.init(),
      navigatorKey: navigatorKey, // Pass the navigatorKey here
      home: SplashScreen(
        service: IsarService(),
      ),
    );
  }
}
