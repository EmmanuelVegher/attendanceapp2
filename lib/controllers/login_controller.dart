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
import '../model/appversion.dart';
import '../model/departmentmodel.dart';
import '../model/designationmodel.dart';
import '../model/last_update_date.dart';
import '../model/projectmodel.dart';
import '../model/reasonfordaysoff.dart';
import '../model/staffcategory.dart';
import '../model/supervisor_model.dart';
import '../widgets/constants.dart';
import '../widgets/show_error_dialog.dart';

class LoginController extends GetxController {
  late IsarService service; // Declare service without initializing

  final formKey = GlobalKey<FormState>();
  final emailAddressController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isObscure = true.obs;
  DatabaseAdapter adapter = HiveService();
  var getAppVersion1;

  @override
  void onInit() {
    super.onInit();
    // service is now available here
   // fetchLastUpdateDateAndInsertIntoIsar(IsarService());
  }

  void togglePasswordVisibility() {
    isObscure.value = !isObscure.value;
  }




  Future<void> handleLogin(BuildContext context, IsarService service) async {
    final email = emailAddressController.text.trim();
    final password = passwordController.text.trim();
    final firestore = FirebaseFirestore.instance;

    final getAppVersion = await service.getAppVersionInfo();
    if (formKey.currentState!.validate()) {
      try {
        Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

        final user = FirebaseAuth.instance.currentUser;
        QuerySnapshot snap = await firestore.collection("Staff").where('emailAddress', isEqualTo: email).get();

        await firestore.collection("Staff").doc(snap.docs[0].id).update({'isVerified': user?.emailVerified});

        final lastUpdateDateDoc = await firestore.collection('AppVersion').doc('AppVersion').get();

        if (lastUpdateDateDoc.exists) {
          final data = lastUpdateDateDoc.data();
          if (data != null && data.containsKey('appVersionDate')) {
            final timestamp = data['appVersionDate'] as Timestamp;
            final appVersionDate = timestamp.toDate();
            final versionNumber = data['appVersion'];

            if (getAppVersion[0].appVersion == versionNumber) {
              await service.updateAppVersion1(1, AppVersionModel(), appVersionDate, DateTime.now(), true);
            } else {
              await service.updateAppVersion2(1, AppVersionModel(), DateTime.now(), false);
            }
          }
        }

        var box = await Hive.openBox('imageBox');
        await box.clear().then((value) async {
          await service.cleanDB().then((value) async {
            await _insertSuperUser(service);
            await _insertVersion();
          }).then((value) async {
            await _autoFirebaseDBUpdate(service, snap.docs[0].id);
          }).then((value) async {
            await fetchDataAndInsertIntoIsar(service);
            await fetchDepartmentAndDesignationAndInsertIntoIsar(service);
            fetchStaffCategoryAndInsertIntoIsar(service);
            fetchReasonsForDaysOffAndInsertIntoIsar(service);
            fetchLastUpdateDateAndInsertIntoIsar(service);
            fetchProjectAndInsertIntoIsar(service);
            fetchAppVersionAndInsertIntoIsar(service);
            fetchSupervisorAndInsertIntoIsar(service);
            getAppVersion1 = await service.getAppVersionInfo();
          });
        });

        try {
          _pickImageFromFirebase(snap.docs[0]['photoUrl']);
        } catch (e) {
          print("_pickImageFromFirebase error: $e");
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
          ..firebaseAuthId = snap.docs[0]['id']
          ..isSynced = true
          ..supervisor = snap.docs[0]['supervisor']
          ..supervisorEmail = snap.docs[0]['supervisorEmail'];

        await service.saveBioData(bioData);

        final appUsage = AppUsageModel()..lastUsedDate = DateTime.now();
        await service.saveLastUsedDate(appUsage);

        if (getAppVersion1[0].latestVersion == false) {
          Fluttertoast.showToast(
            msg: "You are yet to upgrade to the latest version",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black54,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          if (context.mounted) {
          // Get.off(() => HomePage());
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false,
            );
          Fluttertoast.showToast(
            msg: "Logging In..",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.black54,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0,
          );}
        }
      } on UserNotFoundAuthException {
        showErrorDialog(context, "User not Found");
        Fluttertoast.showToast(
          msg: "Error: User not Found!",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } on WrongPasswordAuthException {
        showErrorDialog(context, "Wrong Password");
        Fluttertoast.showToast(
          msg: "Error: Wrong Password",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } on GenericAuthException {
        showErrorDialog(context, "Authentication Error");
        Fluttertoast.showToast(
          msg: "Error: Authentication Error!",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } catch (e) {
        String error = "Error occurred: $e";
        if (e.toString() == "RangeError (index): Invalid value: Valid value range is empty: 0") {
          error = "Staff Email Address does not exist!!!";
        }
        Fluttertoast.showToast(
          msg: error,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        showErrorDialog(context, error);
      } finally {
        if (Get.isDialogOpen!) {
          Get.back();
        }
      }
    }
  }




  Future<void> _insertVersion() async {
    final getAppVersion = await service.getAppVersionInfo();

    if (getAppVersion.length == 0) {
      final appVersion = AppVersionModel()
        ..appVersion = appVersionConstant;

      await service.saveAppVersionData(appVersion);
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
          ..comments = attendanceHistory.comments
          ..month = attendanceHistory.month

        ;

        service.saveAttendance(attendnce);
      }
      //print("FirebaseID ====$firebaseAuthId");
      Fluttertoast.showToast(
          msg: "Authenticating account..",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> fetchDataAndInsertIntoIsar(IsarService service) async {
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
          ..category =  data['category']
          ..radius = double.parse(data['Radius'].toString());

        service.saveLocation(locationSave);
      }
    }
  }

  void fetchSupervisorAndInsertIntoIsar(IsarService service) async {
    final firestore = FirebaseFirestore.instance;
    final supervisorCollection = await firestore.collection('Supervisors').get();

    print("supervisorCollection == $supervisorCollection");

    for (final stateDoc in supervisorCollection.docs) {
      final state = stateDoc.id;
      print("supervisorCollectionstate == $state");


      final supervisorCollectionRef = await firestore
          .collection('Supervisors')
          .doc(state)
          .collection(state)
          .get();

      for (final supervisorDoc in supervisorCollectionRef.docs) {
        final supervisor = supervisorDoc.id;
        print("supervisorCollectionstatesupervisor == $supervisor");
        final data = supervisorDoc.data() as Map<String, dynamic>;

        print("supervisorCollectionstatesupervisorData == $data");

        final supervisorSave = SupervisorModel()
          ..department = data['department']
          ..email = data['email']
          ..state = state
          ..supervisor = data['supervisor']

        ;

        service.saveSupervisor(supervisorSave);
      }
    }
  }

  Future<void> fetchDepartmentAndDesignationAndInsertIntoIsar(IsarService service) async {
    final firestore = FirebaseFirestore.instance;
    final designationCollection = await firestore.collection('Designation').get();

    for (final departmentDoc in designationCollection.docs) {
      final department = departmentDoc.id;
      //print("stateSnap====${state}");
      final departmentSave = DepartmentModel()..departmentName = department;

      service.saveDepartment(departmentSave);

      final designationCollectionRef = await firestore
          .collection('Designation')
          .doc(department)
          .collection(department)
          .get();

      for (final designationDoc in designationCollectionRef.docs) {
        final designation = designationDoc.id;
        // print("lgaSnap====${lga}");
        final data = designationDoc.data() as Map<String, dynamic>;
        //print("data====${data}");

        final designationSave = DesignationModel()
          ..departmentName = department
          ..designationName = data['designationName']
          ..category = data['category']

        ;

        service.saveDesignation(designationSave);
      }
    }
  }

  Future<void> fetchProjectAndInsertIntoIsar(IsarService service) async {
    final firestore = FirebaseFirestore.instance;
    final projectCollection = await firestore.collection('Project').get();

    for (final projectDoc in projectCollection.docs) {
      final project = projectDoc.id;
      //print("stateSnap====${state}");
      final projectSave = ProjectModel()..project = project;

      service.saveProject(projectSave);


    }
  }

  Future<void> fetchLastUpdateDateAndInsertIntoIsar(IsarService service) async {
    final firestore = FirebaseFirestore.instance;

    try {
      final lastUpdateDateDoc = await firestore
          .collection('LastUpdateDate')
          .doc("LastUpdateDate")
          .get();

      if (lastUpdateDateDoc.exists) {
        // Get the data from the document
        final data = lastUpdateDateDoc.data();

        if (data != null && data.containsKey('LastUpdateDate')) {
          // Safely extract the timestamp and convert to DateTime
          final timestamp = data['LastUpdateDate'] as Timestamp;
          final lastUpdate = timestamp.toDate();

          print("LastUpdateDate ====${lastUpdate}");

          final lastUpdateSave = LastUpdateDateModel()
            ..lastUpdateDate = lastUpdate;

          await service.saveLastUpdateDate(lastUpdateSave);
         // await service.updateAppVersion(1,AppVersionModel(),lastUpdate);
          print("Last update date saved: $lastUpdate");
        } else {
          print("Document does not contain 'lastUpdate' field.");
        }
      } else {
        print("Document 'LastUpdateDate' not found.");
      }
    } catch (e) {
      print("Error fetching last update date: $e");
      // Handle the error appropriately (e.g., show an error message to the user)
    }
  }

  Future<void> fetchAppVersionAndInsertIntoIsar(IsarService service) async {
    final firestore = FirebaseFirestore.instance;
    final getAppVersion = await service.getAppVersionInfo();

    try {
      final lastUpdateDateDoc = await firestore
          .collection('AppVersion')
         // .doc(getAppVersion[0].appVersion)
          .doc('AppVersion')
          .get();

      if (lastUpdateDateDoc.exists) {
        // Get the data from the document
        final data = lastUpdateDateDoc.data();


        if (data != null && data.containsKey('appVersionDate')) {
          // Safely extract the timestamp and convert to DateTime
          final timestamp = data['appVersionDate'] as Timestamp;
          final appVersionDate = timestamp.toDate();
          final versionNumber = data['appVersion'];

          print("appVersionDate ====${appVersionDate}");
          print("versionNumber ====${versionNumber}");


          if(getAppVersion[0].appVersion == versionNumber){
            await service.updateAppVersion1(1,AppVersionModel(),appVersionDate,DateTime.now(),true);
          }else{
            await service.updateAppVersion2(1,AppVersionModel(),DateTime.now(),false);
          }
          print("Last appVersionDate saved: $appVersionDate");
        } else {
          print("Document does not contain 'appVersionDate' field.");
        }
      } else {
        print("Document 'appVersionDate' not found.");
      }
    } catch (e) {
      print("Error fetching last appVersionDate: $e");
      // Handle the error appropriately (e.g., show an error message to the user)
    }
  }

  void fetchReasonsForDaysOffAndInsertIntoIsar(IsarService service) async {
    final firestore = FirebaseFirestore.instance;
    final reasonsForDaysOffCollection = await firestore.collection('ReasonsForDaysOff').get();

    for (final reasonsForDaysOffDoc in reasonsForDaysOffCollection.docs) {
      final reasonsForDaysOff = reasonsForDaysOffDoc.id;
      //print("stateSnap====${state}");
      final reasonsForDaysOffSave = ReasonForDaysOffModel()..reasonForDaysOff = reasonsForDaysOff;

      service.saveReasonForDaysOff(reasonsForDaysOffSave);

    }
  }

  void fetchStaffCategoryAndInsertIntoIsar(IsarService service) async {
    final firestore = FirebaseFirestore.instance;
    final staffCategoryCollection = await firestore.collection('StaffCategory').get();

    for (final staffCategoryDoc in staffCategoryCollection.docs) {
      final staffCategory = staffCategoryDoc.id;
      //print("stateSnap====${state}");
      final staffCategorySave = StaffCategoryModel()..staffCategory = staffCategory;

      service.saveStaffCategory(staffCategorySave);

    }
  }

  Future<void> _insertSuperUser(IsarService service) async {
    final bioInfoForSuperUser = await service.getBioInfoForSuperUser();

    if (bioInfoForSuperUser.isEmpty) {
      final bioData = BioModel()
        ..emailAddress = emailAddressConstant
        ..password = passwordConstant
        ..role = roleConstant
        ..department = departmentConstant
        ..designation = designationConstant
        ..firstName = firstNameConstant
        ..lastName = lastNameConstant
        ..location = locationConstant
        ..mobile = mobileConstant
        ..project = projectConstant
        ..staffCategory = staffCategoryConstant
        ..state = stateConstant
        ..firebaseAuthId = firebaseAuthIdConstant
        ..isSynced = isSyncedConstant
        ..supervisor = supervisorConstant
        ..supervisorEmail = supervisorEmailConstant;

      await service.saveBioData(bioData);
    }
  }
}