import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
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
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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
import 'model/bio_model.dart';
import 'model/locationmodel.dart';
import 'model/track_location_model.dart';
import 'services/background_service.dart';


// Global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

int id = 0;
late SharedPreferences pref;
RxBool isDeviceConnected = false.obs;

Future<void> main() async {
  await dotenv.load(fileName: "assets/config/.env"); // Load environment variables
 // Initialize time zones
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase and other services
    await initializeServices();
    tz.initializeTimeZones();
   //await dotenv.load(fileName: "/.env"); // Explicitly load .env
    //print("Current directory: ${Directory.current.path}");
    //checkEnvFile();
    debugEnvironment();

    runApp(MyApp());
    // Initialize and start the background service
    await initializeService();
  } catch (e) {
    print("Error loading .env file: $e");
  }


//  runApp(MyApp());

  // Initialize and start background services
  //await initializeBackgroundService();


}

void debugEnvironment() {
  final currentDir = Directory.current.path;
  print("Current directory2: $currentDir");

  try {
    final files = Directory(currentDir).listSync();
    print("Files in current directory:");
    files.forEach((file) {
      print(file.path);
    });
  } catch (e) {
    print("Error accessing directory: $e");
  }
}

void checkEnvFile() {
  final currentDir = Directory.current.path;
  print("Current directory: $currentDir");

  // Check if .env file exists
  final envFile = File('$currentDir/.env');
  if (envFile.existsSync()) {
    print(".env file found!");
  } else {
    print(".env file not found in $currentDir");
  }

  // List all files in the directory
  print("Files in the directory:");
  Directory(currentDir)
      .listSync()
      .forEach((file) => print(file.path));
}

Future<void> initializeServices() async {
  // Ensure Firebase is initialized first
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.playIntegrity,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    //appleProvider: AppleProvider.appAttest,
    appleProvider: AppleProvider.debug,
  );


  // Initialize other services
  await Future.wait([
    GetStorage.init(),
    NotifyHelper().initializeNotification(),
    Hive.initFlutter(),
    IsarService().openDB(),
    AttendanceGSheetsApi.init(),
    _setupCrashlytics(),
    _checkNetworkConnectivity(),
  ]);

  tz.initializeTimeZones();
  pref = await SharedPreferences.getInstance();
  configLoading();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Update locations based on data
  await _updateEmptyLocationForTwelve();
  await _updateEmptyClockInLocation();
  await _updateEmptyClockOutLocation();
}

Future<void> _setupCrashlytics() async {
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}

Future<void> _checkNetworkConnectivity() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  isDeviceConnected.value = connectivityResult != ConnectivityResult.none;
}

Future<void> _updateEmptyClockInLocation() async {
  try {
    List<AttendanceModel> attendanceForEmptyLocation =
    await IsarService().getAttendanceForEmptyClockInLocation();

    for (var attend in attendanceForEmptyLocation) {
      var location2 = await _getLocationName(
        attend.clockInLatitude!,
        attend.clockInLongitude!,
        "clock-in",
      );

      if (location2.isNotEmpty) {
        await IsarService().updateEmptyClockInLocation(
          attend.id,
          AttendanceModel(),
          location2,
        );
      }
    }
  } catch (e) {
    log("Error updating empty Clock-In locations: ${e.toString()}");
  }
}

Future<void> _updateEmptyClockOutLocation() async {
  try {
    List<AttendanceModel> attendanceForEmptyLocation =
    await IsarService().getAttendanceForEmptyClockOutLocation();

    for (var attend in attendanceForEmptyLocation) {
      var location2 = await _getLocationName(
        attend.clockOutLatitude!,
        attend.clockOutLongitude!,
        "clock-out",
      );

      if (location2.isNotEmpty) {
        await IsarService().updateEmptyClockOutLocation(
          attend.id,
          AttendanceModel(),
          location2,
        );
      }
    }
  } catch (e) {
    log("Error updating empty Clock-Out locations: ${e.toString()}");
  }
}

Future<String> _getLocationName(double latitude, double longitude, String type) async {
  String locationName = '';
  bool isInsideGeofence = false;

  try {
    List<Placemark> placemark = await placemarkFromCoordinates(latitude, longitude);
    List<LocationModel> isarLocations =
    await IsarService().getLocationsByState(placemark[0].administrativeArea);

    List<GeofenceModel> offices = isarLocations.map((location) => GeofenceModel(
      name: location.locationName!,
      latitude: location.latitude ?? 0.0,
      longitude: location.longitude ?? 0.0,
      radius: location.radius?.toDouble() ?? 0.0,
    )).toList();

    for (GeofenceModel office in offices) {
      double distance = GeoUtils.haversine(latitude, longitude, office.latitude, office.longitude);
      if (distance <= office.radius) {
        log('Entered office: ${office.name}');
        locationName = office.name;
        isInsideGeofence = true;
        break;
      }
    }

    if (!isInsideGeofence) {
      locationName = "${placemark[0].street}, ${placemark[0].subLocality}, ${placemark[0].locality}, ${placemark[0].administrativeArea}, ${placemark[0].country}";
    }
  } catch (e) {
    log("Error fetching location name for $type: ${e.toString()}");
  }

  return locationName;
}

Future<void> _updateEmptyLocationForTwelve() async {
  try {
    List<TrackLocationModel> attendanceForEmptyLocationFor12 =
    await IsarService().getAttendanceForEmptyLocationFor12();

    for (var attend in attendanceForEmptyLocationFor12) {
      var location2 = await _getLocationName(
        attend.latitude!,
        attend.longitude!,
        "12pm",
      );

      if (location2.isNotEmpty) {
        await IsarService().updateEmptyLocationFor12(
          attend.id,
          TrackLocationModel(),
          location2,
        );
      }
    }
  } catch (e) {
    log("Error updating 12pm locations: ${e.toString()}");
  }
}

Future<void> syncCompleteDataForLocationForTwelve() async {
  try {

    List<BioModel> getAttendanceForBio =
    await IsarService().getBioInfoWithUserBio();



    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("Staff")
        .where("id", isEqualTo: getAttendanceForBio[0].firebaseAuthId)
        .get();



    List<TrackLocationModel> unSyncedLocations =
    await IsarService().getTracklocationForPartialUnSynced();

    for (var unSyncedTrackLocation in unSyncedLocations) {
      log("Synching tracked location for 12pm");
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
      });

      await IsarService().updateSyncStatusForTrackLocationBy12(
        unSyncedTrackLocation.id,
        TrackLocationModel(),
        true,
      );
    }
  } catch (e) {
    log("Sync Error Skipping firebase DB: ${e.toString()}");
  }
}

Future<Position> _getUserLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled, don't continue.
    return Future.error('Location services are disabled.');
  }

  // Check for location permissions.
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are permanently denied.
    return Future.error('Location permissions are permanently denied');
  }

  // When permissions are granted, get the position.
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

Future<void> fetchAddressFromLocation() async {
  try {
    Position position = await _getUserLocation();
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final placemark = placemarks[0];
      final address = '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
      log('Current Address: $address');
    }
  } catch (e) {
    log('Error fetching address: $e');
  }
}

Future<void> configLoading() async {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..radius = 10.0
    ..progressColor = Colors.blue
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.blue
    ..textColor = Colors.black
    ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}
//
// Future<void> initializeBackgroundService() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize the background service
//   await FlutterBackgroundService().startService();
//   FlutterBackgroundService().sendData({"action": "setAsForeground"});
//
//   // Configure the background service
//   FlutterBackgroundService().onDataReceived.listen((event) {
//     if (event!["action"] == "setAsForeground") {
//       FlutterBackgroundService().setForegroundMode(true);
//     }
//   });
//
//   // Perform background work here
//   Timer.periodic(Duration(seconds: 15), (timer) async {
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     log('Background Location: ${position.latitude}, ${position.longitude}');
//   });
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       navigatorKey: navigatorKey,
//       title: 'Attendance App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: SplashScreen(service: IsarService(),),
//       builder: EasyLoading.init(),
//     );
//   }
// }

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