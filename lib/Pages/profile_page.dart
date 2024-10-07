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

import '../model/bio_model.dart';
import '../widgets/constants.dart';
import '../widgets/editable_department.dart';
import '../widgets/editable_designation.dart';
import '../widgets/editable_location.dart';
import '../widgets/editable_project.dart';
import '../widgets/editable_staffcategory.dart';
import '../widgets/editable_state.dart';
import '../widgets/editable_supervisor.dart';
import '../widgets/input_field.dart';

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
  var newstaffCategory;
  var locationName;
  var updatedDepartment;
  var supervisor;
  var supervisorEmail;
  var supervisorName;
  var isSynced;
  var newSynced;
  var newState;
  var newCategory;

  // Controllers for editable fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserDetail().then((_){
     // _fetchLocationsFromIsar(state, newstaffCategory);
    });
    // getCurrentDateRecordCount();
  }

  // Future<int> getCurrentDateRecordCount() async {
  //   final attendanceLast = await IsarService().getAttendanceForSpecificDate(
  //       DateFormat('dd-MMMM-yyyy').format(DateTime.now()));
  //   //print("attendanceLastLength ===${attendanceLast.length}");

  //   return attendanceLast.length;
  // }

  Future<void> _getUserDetail() async {
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
      newstaffCategory = staffCategory == "Facility Staff"?"Facility":staffCategory == "State Office Staff"?"State Office":"HQ";
      mobile = userDetail?.mobile;
      emailAddress = userDetail?.emailAddress;
      role = userDetail?.role;
      supervisor = userDetail?.supervisor;
      supervisorEmail = userDetail?.supervisorEmail;
      isSynced = userDetail?.isSynced;
      newSynced = isSynced;

      // Initialize controllers with fetched data
      _emailController.text = emailAddress ?? "";
      _phoneController.text = mobile ?? "";
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
    return StreamBuilder<List<BioModel>>(
      stream: IsarService().listenToBiometric1(), // Replace with your actual stream
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show a loader while waiting for data
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Display an error message if the stream has an error
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No data available')); // Handle when there's no data
        }

        // Assuming snapshot.data contains the BioModel
        final bioModel = snapshot.data!.first;

        // Now, you can use bioModel to populate your UI or pass it to widgets
        return Scaffold(
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
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
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
                          child: RefreshableWidget<List<Uint8List>?>(
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
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '${bioModel.firstName.toString().toUpperCase()} ${bioModel.lastName.toString().toUpperCase()}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: "NexaLight",
                        ),
                      ),


                      SizedBox(height: 20),
                      Text(
                        '${bioModel.designation.toString().toUpperCase()}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: "NexaLight",
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "${bioModel.role}'s Information",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 2,
                              child: Card(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          EditableStaffCategoryTile(
                                            icon: Icons.category,
                                            title: "Staff Category",
                                            initialValue: bioModel.staffCategory!,
                                            onSave: (newValue) {
                                              IsarService().updateStaffCategoryLocation(
                                                2,
                                                BioModel(),
                                                newValue,
                                                false,
                                              );
                                              setState(() {
                                                isSynced = false;
                                                newCategory = newValue;
                                              });
                                            },
                                            fetchStaffCategory: () => _fetchStaffCategoryFromIsar(),
                                          ),

                                          newCategory != null?
                                          EditableStateTile(
                                            icon: Icons.place,
                                            title: "State",
                                            initialValue: bioModel.state!,
                                            onSave: (newValue) {
                                              IsarService().updateStateProject(
                                                2,
                                                BioModel(),
                                                newValue,
                                                false,
                                              );
                                              setState(() {
                                                newState = newValue;
                                                isSynced = false;
                                              });
                                            },
                                            fetchStates: () => _fetchStatesFromIsar(bioModel.staffCategory!),
                                          ):ListTile(
                                            leading: Icon(Icons.place),
                                            title: Text("State"),
                                            subtitle: Text(
                                                "${bioModel.state.toString()}"),
                                          ),

                                          bioModel.state!= null?
                                          EditableLocationTile(
                                            icon: Icons.my_location,
                                            title: bioModel.staffCategory == "Facility Staff"?"Facility Name":bioModel.staffCategory == "State Office Staff"?"Office Name":"Office Name",
                                            initialValue: bioModel.location!,
                                            onSave: (newValue) {
                                              IsarService().updateBioLocation(
                                                2,
                                                BioModel(),
                                                newValue,
                                                false,
                                              );
                                              setState(() {
                                                isSynced = false;
                                                //newState = newValue;
                                              });
                                            },
                                            fetchLocations: () => _fetchLocationsFromIsar(bioModel.state!,bioModel.staffCategory!),
                                          ):ListTile(
                                            leading: Icon(Icons.my_location),
                                            title:
                                            //staffCategory == "Facility Staff"?Text("State"):staffCategory == Text("State")?"State Office Location":Text("State"),
                                            Text("Office Name"),
                                            subtitle: Text(
                                                "${bioModel.location.toString()}"),
                                          ),
                                          _buildEditableListTile1(
                                            icon: Icons.email,
                                            title: 'Email',
                                            initialValue: bioModel.emailAddress,
                                            controller: _emailController,
                                            onSave: (newValue) async {
                                              await IsarService().updateBioEmail(2, BioModel(), newValue, false);
                                              setState(() {
                                                isSynced = false;
                                              });
                                            },
                                          ),
                                          _buildEditableListTile1(
                                            icon: Icons.phone,
                                            title: 'Phone',
                                            controller: _phoneController,
                                            initialValue: bioModel.mobile,
                                            onSave: (newValue) async {
                                              await IsarService().updateBioPhone(2, BioModel(), newValue, false);
                                              setState(() {
                                                isSynced = false;
                                              });
                                            },
                                          ),
                                          EditableDepartmentTile(
                                            icon: Icons.local_fire_department_sharp,
                                            title: 'Department',
                                            initialValue: bioModel.department!,
                                            onSave: (newValue) {
                                              IsarService().updateBioDepartment(2, BioModel(), newValue, false);
                                              setState(() {
                                               // department = newValue;
                                                updatedDepartment = newValue;
                                                isSynced = false;
                                              });
                                            },
                                            fetchDepartments: () => bioModel.staffCategory == 'Facility Staff'
                                                ? _fetchDepartmentsForFacilityFromIsar()
                                                : _fetchDepartmentsFromIsar(),
                                          ),

                                          updatedDepartment != null?
                                          EditableDesignationTile(
                                            icon: Icons.person,
                                            title: 'Designation',
                                            initialValue: bioModel.designation!,
                                            onSave: (newValue) {
                                              IsarService().updateBioDesignation(
                                                2,
                                                BioModel(),
                                                newValue,
                                                false,
                                              );
                                              setState(() {
                                                isSynced = false;
                                              });
                                            },
                                            fetchDesignations: () => _fetchDesignationsFromIsar(bioModel.department!, bioModel.staffCategory!),
                                          ):ListTile(
                                            leading: Icon(Icons.person),
                                            title: Text("Designation"),
                                            subtitle: Text(
                                                "${bioModel.designation.toString()}"),
                                          ),
                                          EditableProjectTile(
                                            icon: Icons.work,
                                            title: 'Project',
                                            initialValue: bioModel.project!,
                                            onSave: (newValue) {
                                              IsarService().updateBioProject(
                                                2,
                                                BioModel(),
                                                newValue,
                                                false,
                                              );
                                              setState(() {
                                                isSynced = false;
                                              });
                                            },
                                            fetchProjects: () => _fetchProjectsFromIsar(),
                                          )
                                          ,

                                          updatedDepartment != null?
                                          EditableSupervisorTile(
                                            icon: Icons.person,
                                            title: "Supervisor's Name",
                                            initialValue: bioModel.supervisor!,
                                            onSave: (newValue) async {


                                              List<String?> supervisorsemail = await IsarService().getSupervisorEmailFromIsar(bioModel.department,newValue);
                                              print("Edited supervisorsemail === $supervisorsemail");

                                              await IsarService().updateBioSupervisor(
                                                2,
                                                BioModel(),
                                                newValue,
                                                false,
                                              ).then((_) async {
                                                await IsarService().updateBioSupervisorEmail(
                                                  2,
                                                  BioModel(),
                                                  supervisorsemail[0]!,
                                                  false,
                                                );
                                              }).then((_){
                                                setState(() {
                                                  //Save Profile pic URL in User class
                                                  supervisorEmail = supervisorsemail[0];
                                                  isSynced = false;
                                                });
                                              });


                                            },
                                            fetchSupervisor: () => _fetchSupervisorsFromIsar(bioModel.department!,bioModel.state!),
                                          ):
                                          ListTile(
                                            leading: Icon(Icons.person),
                                            title: Text("Supervisor's Name"),
                                            subtitle: Text(
                                                "${supervisor.toString()}"),
                                          ),

                                          ListTile(
                                            leading: Icon(Icons.email),
                                            title: Text("Supervisor's Email"),
                                            subtitle: Text(
                                                "${supervisorEmail.toString()}"),
                                          )
                                          ,
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            )
                          ],
                        ),
                      ),
                      !isSynced?Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: GestureDetector(
                          onTap: () async {
                            // TODO: Add your sync logic here
                            await syncCompleteData();
                            setState(() {
                              isSynced = newSynced;
                            });
                            },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.60,
                            height: MediaQuery.of(context).size.height * 0.06,
                            padding: EdgeInsets.only(left: 20.0, bottom: 0.0),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red,
                                  Colors.black,
                                ],
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: const Row(
                                children:[
                                  Text(
                                    "Sync Updated Bio Data",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(width:10),
                                  Icon(
                                    Icons.arrow_upward,
                                    size: 20,
                                    color: Colors.white,
                                  ),


                                ]),

                            // Center(
                            //   child: Text(
                            //     "Sync Updated Bio Data",
                            //     style: TextStyle(
                            //         color: Colors.white,
                            //         fontWeight: FontWeight.bold,
                            //         fontSize: 16),
                            //   ),
                            // ),
                          ),
                        )
                      ):SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> syncCompleteData() async {
    try {
      // The try block first of all saves the data in the google sheet for the visualization and then on the firebase database as an extra backup database  before chahing the sync status on Mobile App to "Synced"
      //Query the firebase and get the records having updated records
      List<BioModel> getAttendanceForBio =
      await IsarService().getBioInfoWithUserBio();

      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Staff")
          .where("id", isEqualTo: getAttendanceForBio[0].firebaseAuthId)
          .get();

      //print("firebaseAuthId == ${getAttendanceForBio[0].firebaseAuthId}");

      List<BioModel> getBioForPartialUnSynced =
      await IsarService().getBioForId();

        //Iterate through each queried loop
        for (var unSyncedBio in getBioForPartialUnSynced)
          {

            await FirebaseFirestore.instance
                .collection("Staff")
                .doc(snap.docs[0].id)
                .set({
              "department": unSyncedBio.department,
              'designation': unSyncedBio.designation,
              'emailAddress': unSyncedBio.emailAddress,
              'firstName': unSyncedBio.firstName,
              'id': snap.docs[0].id,
              'lastName': unSyncedBio.lastName,
              'location': unSyncedBio.location,
              'mobile': unSyncedBio.mobile,
              'project': unSyncedBio.project,
              'staffCategory': unSyncedBio.staffCategory,
              'state': unSyncedBio.state,
              'supervisor': unSyncedBio.supervisor,
              'supervisorEmail': unSyncedBio.supervisorEmail,
              'version':appVersionConstant,
              'isRemoteDelete':false,
              'isRemoteUpdate':false,
              'lastUpdateDate':DateTime.now(),
            }).then((value) {
              Fluttertoast.showToast(
                msg: "Syncing BioData to Server...",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.black54,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              IsarService().updateSyncStatusForBio(
                  unSyncedBio.id, BioModel(), true).then((_){
                Fluttertoast.showToast(
                  msg: "Syncing Completed...",
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Colors.black54,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }); // Update Isar



            })
                .catchError((error) {
              Fluttertoast.showToast(
                msg: "Server Write Error: ${error.toString()}",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.black54,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            });

          }





    } catch (e) {
      // The catch block executes incase firebase database encounters an error thereby only saving the data in the google sheet for the analytics before chahing the sync status on Mobile App to "Synced"

      // List<AttendanceModel> getAttendanceForPartialUnSynced =
      //     await widget.service.getAttendanceForPartialUnSynced();
      Fluttertoast.showToast(
        msg: "Sync Error: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );


      //await _updateEmptyClockInAndOutLocation().then((value) async => {
      //Iterate through each queried loop
      // for (var unSyncedAttend in getAttendanceForPartialUnSynced) {
      //   await _updateGoogleSheet(
      //           state,
      //           project,
      //           firstName,
      //           lastName,
      //           designation,
      //           department,
      //           location,
      //           staffCategory,
      //           mobile,
      //           unSyncedAttend.date.toString(),
      //           emailAddress,
      //           unSyncedAttend.clockIn.toString(),
      //           unSyncedAttend.clockInLatitude.toString(),
      //           unSyncedAttend.clockInLongitude.toString(),
      //           unSyncedAttend.clockInLocation.toString(),
      //           unSyncedAttend.clockOut.toString(),
      //           unSyncedAttend.clockOutLatitude.toString(),
      //           unSyncedAttend.clockOutLongitude.toString(),
      //           unSyncedAttend.clockOutLocation.toString(),
      //           unSyncedAttend.durationWorked.toString(),
      //           unSyncedAttend.noOfHours.toString(),
      //           unSyncedAttend.comments.toString(),
      //   )
      //       .then((value) async {
      //     widget.service
      //         .updateSyncStatus(unSyncedAttend.id, AttendanceModel(), true);
      //   });
      // }
      // });
    }
  }



  Future<List<DropdownMenuItem<String>>> _fetchLocationsFromIsar(String state,String category) async {
    // Query Isar database for locations based on the selected state

    if(category == "Facility Staff"){

      List<String?> locations = await IsarService().getLocationsFromIsar(state,"Facility");

      // Convert the locations list to DropdownMenuItem list
      return locations.map((location) => DropdownMenuItem<String>(
        value: location,
        child: Text(location!),
      )).toList();
    }else if(category == "State Office Staff"){
      List<String?> locations = await IsarService().getLocationsFromIsar(state,"State Office");
      // Convert the locations list to DropdownMenuItem list
      return locations.map((location) => DropdownMenuItem<String>(
        value: location,
        child: Text(location!),
      )).toList();
    } else{
      List<String?> locations = await IsarService().getLocationsFromIsar(state,"HQ");
      // Convert the locations list to DropdownMenuItem list
      return locations.map((location) => DropdownMenuItem<String>(
        value: location,
        child: Text(location!),
      )).toList();
    }

  }


  Future<List<DropdownMenuItem<String>>> _fetchDepartmentsFromIsar() async {
    // Query Isar database for departments based on the selected location
    List<String?> departments = await IsarService().getDepartmentsFromIsar();

    // Convert the departments list to DropdownMenuItem list
    return departments.map((department) => DropdownMenuItem<String>(
      value: department,
      child: Text(department!),
    )).toList();
  }

  Future<List<DropdownMenuItem<String>>> _fetchStaffCategoryFromIsar() async {
    // Query Isar database for departments based on the selected location
    List<String?> staffCategory = await IsarService().getStaffCategoryFromIsar();

    // Convert the departments list to DropdownMenuItem list
    return staffCategory.map((staffCategor) => DropdownMenuItem<String>(
      value: staffCategor,
      child: Text(staffCategor!),
    )).toList();
  }

  Future<List<DropdownMenuItem<String>>> _fetchDepartmentsForFacilityFromIsar() async {
    // Query Isar database for departments based on the selected location
    List<String?> departments = await IsarService().getDepartmentsFromIsar();
    List<String> departmentFilterList = ['Care and Treatment','Laboratory','Pharmacy and Logistics','Preventions','Strategic Information'];

    // Filter the departments based on the provided list
    List<String> filteredDepartments = departments.where((department) {
      return department != null && departmentFilterList.contains(department);
    }).cast<String>().toList();

    // Convert the filtered departments list to DropdownMenuItem list
    return filteredDepartments.map((department) => DropdownMenuItem<String>(
      value: department,
      child: Text(department),
    )).toList();
  }

  Future<List<DropdownMenuItem<String>>> _fetchDesignationsFromIsar(String department,String category) async {
    // Query Isar database for designations based on the selected department
    if(category == "Facility Staff"){
      List<String?> designations = await IsarService().getDesignationsFromIsar(department,"Facility Staff");

      // Convert the designations list to DropdownMenuItem list
      return designations.map((designation) => DropdownMenuItem<String>(
        value: designation,
        child: Text(designation!),
      )).toList();
    }else{
      List<String?> designations = await IsarService().getDesignationsFromIsar(department,"Office Staff");

      // Convert the designations list to DropdownMenuItem list
      return designations.map((designation) => DropdownMenuItem<String>(
        value: designation,
        child: Text(designation!),
      )).toList();

    }


  }

  Future<List<DropdownMenuItem<String>>> _fetchStatesFromIsar(String category) async {
    if (category == 'HQ Staff') {
      final fctState = await IsarService().getAllStatesFromIsarForFCT();
      print("_fetchStatesFromIsar fctState == $fctState");
      return fctState.map((state) => DropdownMenuItem<String>(
        value: state,
        child: Text(state!),
      )).toList();
    } else {
      final otherState = await IsarService().getAllStatesFromIsar();

      // Filter out "Federal Capital Territory"
      final filteredStates = otherState.where((state) => state != "Federal Capital Territory").toList();

      print("_fetchStatesFromIsar otherState == $filteredStates");
      return filteredStates.map((state) => DropdownMenuItem<String>(
        value: state,
        child: Text(state!),
      )).toList();
    }
  }

  Future<List<DropdownMenuItem<String>>> _fetchProjectsFromIsar() async {
    // Query Isar database for designations based on the selected department
    List<String?> projects = await IsarService().getProjectFromIsar();

    // Convert the designations list to DropdownMenuItem list
    return projects.map((project) => DropdownMenuItem<String>(
      value: project,
      child: Text(project!),
    )).toList();
  }


  Future<List<DropdownMenuItem<String>>> _fetchSupervisorsFromIsar(String department,String state) async {
    // Query Isar database for designations based on the selected department

    List<String?> supervisors = await IsarService().getSupervisorsFromIsar(department,state);

    // Convert the designations list to DropdownMenuItem list
    return supervisors.map((supervisor) => DropdownMenuItem<String>(
      value: supervisor,
      child: Text(supervisor!),
    )).toList();
  }


  Widget _buildEditableListTile1({
    required IconData icon,
    required String title,
    String? initialValue,
    TextEditingController? controller,
    required Function(String) onSave,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: initialValue != null
          ? Text(initialValue
      )
          : initialValue != null
          ? Flexible( // Wrap Text widget with Flexible
        child: Text(
          initialValue,
          softWrap: true, // Ensure text can wrap to the next line
          overflow: TextOverflow.ellipsis, // Optionally handle overflow with ellipsis
        ),
      )
          : null,// Or set to null if no initialValue
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          _showEditDialog1(
            context: context,
            title: title,
            initialValue: initialValue ?? controller?.text,
            onSave: onSave,
          );
        },
      ),
    );
  }

  // Function to show the edit dialog/bottom sheet
  void _showEditDialog1({
    required BuildContext context,
    required String title,
    String? initialValue,
    required Function(String) onSave,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        String? newValue = initialValue; // Store the edited value

        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            onChanged: (value) {
              newValue = value;
            },
            controller: TextEditingController(text: initialValue),
            decoration: InputDecoration(
              hintText: 'Enter new $title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave(newValue ?? "");
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }



// Function to show the edit dialog/bottom sheet
  void _showEditDialog({
    required BuildContext context,
    required String title,
    String? initialValue,
    required Function(String) onSave,
    required Widget Function(BuildContext) futureBuilder,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: initialValue != null
              ? TextField(
            onChanged: (value) {
              initialValue = value;
            },
            controller: TextEditingController(text: initialValue),
            decoration: InputDecoration(
              hintText: 'Enter new $title',
            ),
          )
              : futureBuilder(context),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave(initialValue ?? "");
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }


  Future<List<Uint8List>?> _readImagesFromDatabase() async {
    return adapter.getImages();
  }
}
