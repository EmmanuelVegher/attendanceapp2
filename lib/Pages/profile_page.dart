import 'dart:io';
import 'dart:math';
import 'package:attendanceapp/Pages/Attendance/attendance_home.dart';
import 'package:attendanceapp/Pages/Dashboard/super_admin_dashboard.dart';
import 'package:attendanceapp/model/user_model.dart';
import 'package:attendanceapp/services/database_adapter.dart';
import 'package:attendanceapp/services/hive_service.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:attendanceapp/widgets/drawer.dart';
import 'package:attendanceapp/widgets/header_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:refreshable_widget/refreshable_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  DatabaseAdapter adapter = HiveService();
  double _drawerIconSize = 24;
  double _drawerFontSize = 17;
  late SharedPreferences sharedPreferences;
  var firstName;
  var lastName;
  var firebaseAuthId;
  var staffCategory;
  var designation;
  var state;
  var emailAddress;
  var location;
  var department;
  var mobile;
  var project;
  var role;

  @override
  void initState() {
    super.initState();
    _getUserDetail();
    // getCurrentDateRecordCount();
  }

  // Future<int> getCurrentDateRecordCount() async {
  //   final attendanceLast = await IsarService().getAttendanceForSpecificDate(
  //       DateFormat('dd-MMMM-yyyy').format(DateTime.now()));
  //   //print("attendanceLastLength ===${attendanceLast.length}");

  //   return attendanceLast.length;
  // }

  void _getUserDetail() async {
    final userDetail = await IsarService().getBioInfoWithFirebaseAuth();
    setState(() {
      firebaseAuthId = userDetail?.firebaseAuthId;
      state = userDetail?.state;
      project = userDetail?.project;
      firstName = userDetail?.firstName;
      lastName = userDetail?.lastName;
      designation = userDetail?.designation;
      department = userDetail?.department;
      location = userDetail?.location;
      staffCategory = userDetail?.staffCategory;
      mobile = userDetail?.mobile;
      emailAddress = userDetail?.emailAddress;
      role = userDetail?.role;
    });
  }

  Future<void> _pickImage() async {
    try {
      ImagePicker imagePicker = ImagePicker();
      XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 90,
      );
      if (image == null) return;
      // Reference ref = FirebaseStorage.instance.ref().child(
      //     "${firstName.toLowerCase()}_${lastName.toLowerCase()}_profilepic.jpg");

      // await ref.putFile(File(image.path));

      // ref.getDownloadURL().then((value) async {
      //   setState(() {
      //     //Save Profile pic URL in User class
      //     UserModel.profilePicLink = value;
      //   });
      //   //Save Profile Pic link to firebase
      //   await FirebaseFirestore.instance
      //       .collection("Staff")
      //       .doc(firebaseAuthId)
      //       .update({
      //     "profilePic": value,
      //   });
      // });
      Uint8List imageBytes = await image.readAsBytes();
      adapter.storeImage(imageBytes);

      
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
  }

  void pickUpLoadProfilePic() async {
    //Function for Picking and Uploading Profile Picture
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );

    Reference ref = FirebaseStorage.instance.ref().child(
        "${firstName.toLowerCase()}_${lastName.toLowerCase()}_profilepic.jpg");

    await ref.putFile(File(image!.path));

    ref.getDownloadURL().then((value) async {
      setState(() {
        //Save Profile pic URL in User class
        UserModel.profilePicLink = value;
      });
      //Save Profile Pic link to firebase
      await FirebaseFirestore.instance
          .collection("Staff")
          .doc(firebaseAuthId)
          .update({
        "photoUrl": value,
      });
    });
  }

  Future<void> getAttendance() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    try {
      if (sharedPreferences.getString("employeeId") != null) {
        setState(() {
          // Save Staff ID to the user class from this main.dart
          UserModel.emailAddress = sharedPreferences.getString("emailAddress")!;
          var userAvailable = true;
          if (userAvailable) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SuperAdminUserDashBoard()));
          }
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "Profile Page",
      //     style: TextStyle(color: Colors.red, fontFamily: "NexaBold"),
      //   ),
      //   elevation: 0.5,
      //   iconTheme: const IconThemeData(color: Colors.red),
      //   flexibleSpace: Container(
      //     decoration: const BoxDecoration(
      //         gradient: LinearGradient(
      //             begin: Alignment.topLeft,
      //             end: Alignment.bottomRight,
      //             colors: <Color>[
      //           Colors.white,
      //           Colors.white,
      //         ])),
      //   ),
      //   actions: [
      //     Container(
      //       margin: const EdgeInsets.only(top: 15, right: 15, bottom: 15),
      //       child: Stack(
      //         children: <Widget>[
      //           Image.asset("./assets/image/ccfn_logo.png"),
      //         ],
      //       ),
      //     )
      //   ],
      // ),
      drawer: drawer(
        context,
        IsarService(),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 100,
              child: HeaderWidget(100, false, Icons.house_rounded),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  /* Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(width: 5, color: Colors.white),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(5, 5),),
                      ],
                    ),
                    child: Icon(Icons.person, size: 80, color: Colors.grey.shade300,),
                  ),*/
                  /*
                  GestureDetector(
                      onTap: () {
                      //pickUpLoadProfilePic();
                      FaceScanScreen();
                          },
                      child: Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 24,),
                      height: 120,
                      width: 120,

                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme
                      .of(context)
                      .primaryColor,
                        ),
                      child: Center(
                        //If Profile Pic url is available, show picture, else Icon
                        child: User.profilePicLink == " " ? const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 80,
                          ) : ClipRRect(
                          borderRadius: BorderRadius.circular(20),

                          child: Image.network(User
                            .profilePicLink) //Wrapping with ClipRRect to create border radius
                            ),
                          ),
                          ),
                          ),*/
                  GestureDetector(
                    onTap: () {
                      //pickUpLoadProfilePic();

                      _pickImage();
                    },
                    child: Container(
                        margin: const EdgeInsets.only(
                          top: 20,
                          bottom: 24,
                        ),
                        height: 120,
                        width: 120,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.red,
                        ),
                        child:
                            // FutureBuilder<List<Uint8List>?>(
                            //   future: _readImagesFromDatabase(),
                            //   builder: (context,
                            //       AsyncSnapshot<List<Uint8List>?> snapshot) {
                            //     if (snapshot.hasError) {
                            //       return Text("Error appeared ${snapshot.error}");
                            //     }
                            //     if (snapshot.hasData) {
                            //       if (snapshot.data == null) {
                            //         return Text("Nothing to show");
                            //       }
                            //       return ListView.builder(
                            //         itemCount: snapshot.data!.length,
                            //         itemBuilder: (context, index) =>
                            //             Image.memory(snapshot.data![index]),
                            //       );
                            //     }
                            //     return const Center(
                            //         child: CircularProgressIndicator());
                            //   },
                            // )

                            RefreshableWidget<List<Uint8List>?>(
                          refreshCall: () async {
                            return await _readImagesFromDatabase();
                          },
                          refreshRate: const Duration(seconds: 1),
                          errorWidget: Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.grey.shade300,
                          ),
                          loadingWidget: Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.grey.shade300,
                          ),
                          builder: ((context, value) {
                            return ListView.builder(
                              itemCount: value!.length,
                              itemBuilder: (context, index) =>
                                  Image.memory(value.first),
                            );
                          }),
                        )

                        //  Center(
                        //   //If Profile Pic url is available, show picture, else Icon
                        //   child: _readImagesFromDatabase()
                        //   // == " "
                        //   //     ? const Icon(
                        //   //         Icons.person,
                        //   //         color: Colors.white,
                        //   //         size: 80,
                        //   //       )
                        //   //     : ClipRRect(
                        //   //         borderRadius: BorderRadius.circular(20),
                        //   //         child: Image.network(UserModel
                        //   //             .profilePicLink) //Wrapping with ClipRRect to create border radius
                        //   //         ),

                        // ),
                        ),
                  ),
                 
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${firstName.toString().toUpperCase()} ${lastName.toString().toUpperCase()}',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: "NexaLight"),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Text(
                    '${designation.toString().toUpperCase()}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "NexaLight"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding:
                              const EdgeInsets.only(left: 8.0, bottom: 4.0),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "${role}'s Information",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Card(
                          child: Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    ...ListTile.divideTiles(
                                      color: Colors.grey,
                                      tiles: [
                                        ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          leading: Icon(Icons.my_location),
                                          title: Text("Location"),
                                          subtitle: Text(
                                              "${location.toString().toUpperCase()}"),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.email),
                                          title: Text("Email"),
                                          subtitle: Text("${emailAddress}"),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.phone),
                                          title: Text("Phone"),
                                          subtitle: Text(
                                              "${mobile.toString().toUpperCase()}"),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons
                                              .local_fire_department_sharp),
                                          title: Text("Department"),
                                          subtitle: Text(
                                              "${department.toString().toUpperCase()}"),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.work),
                                          title: Text("Project"),
                                          subtitle: Text(
                                              "${project.toString().toUpperCase()}"),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Uint8List>?> _readImagesFromDatabase() async {
    return adapter.getImages();
  }
}
