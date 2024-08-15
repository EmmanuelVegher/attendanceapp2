import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:attendanceapp/Pages/Attendance/attendance_home.dart';
import 'package:attendanceapp/Pages/auth_exceptions.dart';
import 'package:attendanceapp/model/attendancemodel.dart';
import 'package:attendanceapp/model/bio_model.dart';
import 'package:attendanceapp/model/locationmodel.dart';
import 'package:attendanceapp/model/statemodel.dart';
import 'package:attendanceapp/services/database_adapter.dart';
import 'package:attendanceapp/services/hive_service.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../Pages/home.dart';
import '../model/app_usage_model.dart';
import '../widgets/constants.dart';
import '../widgets/show_error_dialog.dart';

class LoginController extends GetxController {
  late IsarService service; // Declare service without initializing

  final formKey = GlobalKey<FormState>();
  final emailAddressController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isObscure = true.obs;
  DatabaseAdapter adapter = HiveService();

  @override
  void onInit() {
    super.onInit();
    // service is now available here
  }

  void togglePasswordVisibility() {
    isObscure.value = !isObscure.value;
  }
  Future<void> handleLogin(BuildContext context, IsarService service) async {
    final email = emailAddressController.text.trim();
    final password = passwordController.text.trim();

    if (formKey.currentState!.validate()) {
      try {
        Get.dialog(const Center(child: CircularProgressIndicator()),
            barrierDismissible: false);

        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email, password: password);

        final user = FirebaseAuth.instance.currentUser;

        QuerySnapshot snap = await FirebaseFirestore.instance
            .collection("Staff")
            .where('emailAddress', isEqualTo: email)
            .get();

        await FirebaseFirestore.instance
            .collection("Staff")
            .doc(snap.docs[0].id)
            .update({'isVerified': user?.emailVerified});

        var box = await Hive.openBox('imageBox');
        await box.clear().then((value) async {
          await service.cleanDB().then((value) async {
            await _insertSuperUser(service); // Pass service to _insertSuperUser
          }).then((value) async {
            await _autoFirebaseDBUpdate(service, snap.docs[0].id);  // Pass service to _autoFirebaseDBUpdate
          }).then((value) async {
            fetchDataAndInsertIntoIsar(service); // Pass service to fetchDataAndInsertIntoIsar
          });
        });

        try{
          _pickImageFromFirebase(snap.docs[0]['photoUrl']);
        }catch(e){
          print("_pickImageFromFirebase error: ${e}");
        }



        final bioData = BioModel()
          ..emailAddress = email
          ..password = password
          ..role = snap.docs[0]['role']
          ..department = snap.docs[0]['department']
          ..designation = snap.docs[0]['designation']
          ..firstName = snap.docs[0]['firstName']
          ..lastName = snap.docs[0]['lastName']
          ..location = snap.docs[0]['location']
          ..mobile = snap.docs[0]['mobile']
          ..project = snap.docs[0]['project']
          ..staffCategory = snap.docs[0]['staffCategory']
          ..state = snap.docs[0]['state']
          ..firebaseAuthId = snap.docs[0]['id'];

        await service.saveBioData(bioData)
            .then((value) async {
          // Save the current date after successful login
          final appUsage = AppUsageModel()
            ..lastUsedDate = DateTime.now() ;
          await service.saveLastUsedDate(appUsage); // Call the method
        });

       if (context.mounted) {
          Get.off(() => HomePage(
            //  service: service
          ));
        }
      } on UserNotFoundAuthException {
        showErrorDialog(context, "User not Found");
      } on WrongPasswordAuthException {
        showErrorDialog(context, "Wrong Password");
      } on GenericAuthException {
        showErrorDialog(context, "Authentication Error");
      } catch (e) {
        String error = "";
        if (e.toString() ==
            "RangeError (index): Invalid value: Valid value range is empty: 0") {
          error = "Staff Email Address does not exist!!!";
        } else {
          error = "Error occurred!!!";
        }
        showErrorDialog(context, error);
      } finally {
        if (Get.isDialogOpen!) {
          Get.back();
        }
      }
    }
  }

  Future<void> _pickImageFromFirebase(String profilePicLink) async {
    var profilePic = profilePicLink;
    if (profilePic != null) {
      try {
        final image = FirebaseStorage.instance.refFromURL(profilePic);
        if (image == null) return;

        try {
          const oneMegabyte = 1024 * 1024;
          final Uint8List? data = await image.getData(oneMegabyte);
          adapter.storeImage(data!);
        } on FirebaseException catch (e) {
          // Handle any errors.
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Error:${e.toString()}",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.black54,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      return;
    }
  }

  Future<void> _autoFirebaseDBUpdate(IsarService service, String fireBaseIdNew) async {
    final allAttendance = await service.getAllAttendance();
    if (allAttendance.isEmpty) {
      await IsarService().removeAllAttendance(AttendanceModel());
      final CollectionReference snap3 = FirebaseFirestore.instance
          .collection('Staff')
          .doc(fireBaseIdNew)
          .collection("Record");
      print("snap3 ====$snap3");

      List data = [];
      List<AttendanceModel> allAttendance = [];

      await snap3.get().then((QuerySnapshot value) {
        for (var element in value.docs) {
          data.add(element.data());
        }
      });

      for (var document in data) {
        allAttendance.add(AttendanceModel.fromJson(document));
      }

      print("data ====$data");
      print("allAttendance ====$allAttendance");

      for (var attendanceHistory in allAttendance) {
        final attendnce = AttendanceModel()
          ..clockIn = attendanceHistory.clockIn
          ..date = attendanceHistory.date
          ..clockInLatitude = attendanceHistory.clockInLatitude
          ..clockInLocation = attendanceHistory.clockInLocation
          ..clockInLongitude = attendanceHistory.clockInLongitude
          ..clockOut = attendanceHistory.clockOut
          ..clockOutLatitude = attendanceHistory.clockOutLatitude
          ..clockOutLocation = attendanceHistory.clockOutLocation
          ..clockOutLongitude = attendanceHistory.clockOutLongitude
          ..isSynced = attendanceHistory.isSynced
          ..voided = attendanceHistory.voided
          ..isUpdated = attendanceHistory.isUpdated
          ..offDay = attendanceHistory.offDay
          ..durationWorked = attendanceHistory.durationWorked
          ..noOfHours = attendanceHistory.noOfHours
          ..month = attendanceHistory.month;

        service.saveAttendance(attendnce);
      }
      print("FirebaseID ====$firebaseAuthId");
      Fluttertoast.showToast(
          msg: "Logging In..",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void fetchDataAndInsertIntoIsar(IsarService service) async {
    final firestore = FirebaseFirestore.instance;
    final locationCollection = await firestore.collection('Location').get();

    for (final stateDoc in locationCollection.docs) {
      final state = stateDoc.id;
      //print("stateSnap====${state}");
      final stateSave = StateModel()..stateName = state;

      service.saveState(stateSave);

      final lgaCollectionRef = await firestore
          .collection('Location')
          .doc(state)
          .collection(state)
          .get();

      for (final lgaDoc in lgaCollectionRef.docs) {
        final lga = lgaDoc.id;
        // print("lgaSnap====${lga}");
        final data = lgaDoc.data() as Map<String, dynamic>;
        //print("data====${data}");

        final locationSave = LocationModel()
          ..state = state
          ..locationName = data['LocationName']
          ..latitude = double.parse(data['Latitude'].toString())
          ..longitude = double.parse(data['Longitude'].toString())
          ..radius = double.parse(data['Radius'].toString());

        service.saveLocation(locationSave);
      }
    }
  }

  Future<void> _insertSuperUser(IsarService service) async {
    final bioInfoForSuperUser = await service.getBioInfoForSuperUser();

    if (bioInfoForSuperUser.isEmpty) {
      final bioData = BioModel()
        ..emailAddress = emailAddress
        ..password = password
        ..role = role
        ..department = department
        ..designation = designation
        ..firstName = firstName
        ..lastName = lastName
        ..location = location
        ..mobile = mobile
        ..project = project
        ..staffCategory = staffCategory
        ..state = state
        ..firebaseAuthId = firebaseAuthId;

      await service.saveBioData(bioData);
    }
  }
}