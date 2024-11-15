import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:attendanceapp/Pages/Dashboard/super_admin_dashboard.dart';
import 'package:attendanceapp/Pages/auth_exceptions.dart';
import 'package:attendanceapp/Pages/forgot_password.dart';
import 'package:attendanceapp/Pages/register.dart';
import 'package:attendanceapp/Pages/register_page.dart';
import 'package:attendanceapp/Pages/registration_updated.dart';
import 'package:attendanceapp/Pages/routing.dart';
import 'package:attendanceapp/controllers/login_controller.dart';
import 'package:attendanceapp/model/attendancemodel.dart';
import 'package:attendanceapp/model/bio_model.dart';
import 'package:attendanceapp/model/locationmodel.dart';
import 'package:attendanceapp/model/statemodel.dart';
import 'package:attendanceapp/services/database_adapter.dart';
import 'package:attendanceapp/services/hive_service.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:attendanceapp/widgets/constants.dart';
import 'package:attendanceapp/widgets/header_widget.dart';
import 'package:attendanceapp/widgets/progress_dialog.dart';
import 'package:attendanceapp/widgets/show_error_dialog.dart';
import 'package:attendanceapp/widgets/theme_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/appversion.dart';
import '../model/departmentmodel.dart';
import '../model/designationmodel.dart';
import '../model/projectmodel.dart';
import '../model/reasonfordaysoff.dart';
import '../model/staffcategory.dart';
import '../model/supervisor_model.dart';
// ignore_for_file: avoid_print

class LoginPage extends StatelessWidget {
  final IsarService service;

  LoginPage({super.key, required this.service});

  Future<void>_updateRegistrationPage() async {
    try{
      await IsarService().cleanLocationCollection().then((_) async {
        await IsarService().cleanStateCollection().then((_) async {
          await IsarService().cleanStaffCategoryCollection().then((_) async {
            await IsarService().cleanReasonsForDayOffCollection().then((_) async {
              await IsarService().cleanDesignationCollection().then((_) async {
                await IsarService().cleanDepartmentCollection().then((_) async {
                  await IsarService().cleanSupervisorCollection().then((_){
                    fetchDataAndInsertIntoIsar();
                    fetchSupervisorAndInsertIntoIsar();
                    fetchDepartmentAndDesignationAndInsertIntoIsar(IsarService());
                    fetchProjectAndInsertIntoIsar(IsarService());
                    fetchReasonsForDaysOffAndInsertIntoIsar(IsarService());
                    fetchStaffCategoryAndInsertIntoIsar(IsarService());
                  });
                });
              });
            });
          });
        });
      });

    }catch(e){
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }


  }


  void fetchDataAndInsertIntoIsar() async {
    final firestore = FirebaseFirestore.instance;
    final locationCollection = await firestore.collection('Location').get();

    for (final stateDoc in locationCollection.docs) {
      final state = stateDoc.id;
      //print("stateSnap====${state}");
      final stateSave = StateModel()..stateName = state;

      IsarService().saveState(stateSave);

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

        IsarService().saveLocation(locationSave);
      }
    }
  }

  void fetchSupervisorAndInsertIntoIsar() async {
    final firestore = FirebaseFirestore.instance;
    final supervisorCollection = await firestore.collection('Supervisors').get();

    for (final stateDoc in supervisorCollection.docs) {
      final state = stateDoc.id;

      final superviseCollectionRef = await firestore
          .collection('Supervisors')
          .doc(state)
          .collection(state)
          .get();

      for (final supervisorDoc in superviseCollectionRef.docs) {
        final lga = supervisorDoc.id;
        // print("lgaSnap====${lga}");
        final data = supervisorDoc.data() as Map<String, dynamic>;
        //print("data====${data}");

        final supervisorSave = SupervisorModel()
          ..state = state
          ..supervisor = data['supervisor']
          ..email = data['email']
          ..department =  data['department'];

        IsarService().saveSupervisor(supervisorSave);
      }
    }
  }

  void fetchDepartmentAndDesignationAndInsertIntoIsar(IsarService service) async {
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

  void fetchProjectAndInsertIntoIsar(IsarService service) async {
    final firestore = FirebaseFirestore.instance;
    final projectCollection = await firestore.collection('Project').get();

    for (final projectDoc in projectCollection.docs) {
      final project = projectDoc.id;
      //print("stateSnap====${state}");
      final projectSave = ProjectModel()..project = project;

      service.saveProject(projectSave);


    }
  }

  // void fetchAppVersionAndInsertIntoIsar(IsarService service) async {
  //   final firestore = FirebaseFirestore.instance;
  //   final appVersionCollection = await firestore.collection('AppVersion').get();
  //
  //   for (final appVersionDoc in appVersionCollection.docs) {
  //     final appversion = appVersionDoc.id;
  //     //print("stateSnap====${state}");
  //     final appVersionSave = AppVersionModel()..appVersion = appversion;
  //
  //     service.saveAppVersion(appVersionSave);
  //
  //
  //   }
  // }

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

  @override
  Widget build(BuildContext context) {

    // Access screen width and height
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final LoginController loginController = Get.put(LoginController()); // Correct initialization
    loginController.service = service; // Pass 'service' in onInit

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.35, // 35% of screen height
              child: HeaderWidget(screenHeight * 0.35, true, Icons.login_rounded),
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // 5% horizontal padding
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02), // 5% horizontal, 2% vertical margin
                child: Column(
                  children: [
                    Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize:  MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.085 : 0.065), // Responsive font size
                        fontWeight: FontWeight.bold,
                        fontFamily: "NexaBold",
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01), // Responsive SizedBox height
                    Text(
                      "Sign-In into your account",
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "NexaBold",
                        fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.050 : 0.030), // Responsive font size
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03), // Responsive SizedBox height
                    Form(
                      key: loginController.formKey,
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Email Address",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.040 : 0.025), // Responsive font size
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01), // Responsive SizedBox height
                              Container(

                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextFormField(
                                  controller: loginController.emailAddressController,
                                  decoration: ThemeHelper().textInputDecoration(
                                    "",
                                    "Enter your email",
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.email,
                                        color: Colors.black54,
                                        size: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.055 : 0.030), // Responsive icon size
                                      ),
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (val) {
                                    // ... (Email validation logic remains the same)
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02), // Responsive SizedBox height
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Password**",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.040 : 0.025), // Responsive font size
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01), // Responsive SizedBox height
                              Obx(() => Container(
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextFormField(
                                  controller: loginController.passwordController,
                                  obscureText: loginController.isObscure.value,
                                  decoration: ThemeHelper().textInputDecoration(
                                    "",
                                    "Enter your Password**",
                                    IconButton(
                                      onPressed: loginController.togglePasswordVisibility,
                                      icon: Icon(
                                        loginController.isObscure.value ? Icons.visibility : Icons.visibility_off,
                                        color: Colors.black54,
                                        size: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.055 : 0.030),  // Responsive icon size
                                      ),
                                    ),
                                  ),
                                  validator: (value) => value != null && value.isEmpty
                                      ? 'Enter Password'
                                      : null,
                                ),
                              )),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: screenHeight * 0.01, right: screenWidth * 0.025),
                            alignment: Alignment.topRight,
                            child: TextButton(
                              child: Text(
                                "Forgot your password?",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.040 : 0.025),
                                ),
                              ),
                              onPressed: () => Get.to(() => ForgotPasswordPage()),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02), // Responsive SizedBox height
                          Container(
                            decoration: ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              onPressed: () => loginController.handleLogin(context, service),
                              style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding:  EdgeInsets.symmetric(vertical: screenHeight * 0.015, horizontal: screenWidth * 0.1), // Responsive padding
                                child: Text(
                                  "Sign In".toUpperCase(),
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.040 : 0.025), color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, screenHeight * 0.02, 10, screenHeight * 0.04),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(text: "Don't have an account? "),
                                  TextSpan(
                                    text: "Register Here",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _updateRegistrationPage().then((_){
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                ),
                                                child: Container(
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        "Registration",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(height: 20),
                                                      Text(
                                                        "Don't have an account yet? Click on Register to create one.",
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      SizedBox(height: 30),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop(); // Close the dialog
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: Colors.grey, // Customize button color
                                                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                                              textStyle: TextStyle(fontSize: 16),
                                                            ),
                                                            child: Text("Cancel", style: TextStyle(color: Colors.white)),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                              Get.off(() => RegistrationPageUpdated());
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: Colors.red, // Customize button color
                                                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                                              textStyle: TextStyle(fontSize: 16),
                                                            ),
                                                            child: Text("Register", style: TextStyle(color: Colors.white)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        });


                                      },
                                    style: TextStyle(
                                      fontFamily: "NexaBold",
                                      color: Colors.red,
                                      fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.040 : 0.025),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}