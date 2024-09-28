import 'dart:io';
import 'package:attendanceapp/services/database_adapter.dart';
import 'package:attendanceapp/services/hive_service.dart';
import 'package:attendanceapp/Pages/auth_exceptions.dart';
import 'package:attendanceapp/Pages/login_page.dart';
import 'package:attendanceapp/model/user_model.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:attendanceapp/widgets/drawer.dart';
import 'package:attendanceapp/widgets/drawer2.dart';
import 'package:attendanceapp/widgets/header_widget.dart';
import 'package:attendanceapp/widgets/input_field.dart';
import 'package:attendanceapp/widgets/locations.dart';
import 'package:attendanceapp/widgets/progress_dialog.dart';
import 'package:attendanceapp/widgets/show_error_dialog.dart';
import 'package:attendanceapp/widgets/theme_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:refreshable_widget/refreshable_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../widgets/constants.dart';
import '../widgets/facility_dropdown.dart';

class RegistrationPageUpdated extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageUpdatedState();
  }
}

class _RegistrationPageUpdatedState extends State<RegistrationPageUpdated> {
  var role;
  late TextEditingController _firstNameControl;
  late TextEditingController _lastNameControl;
  late TextEditingController _emailAddressControl;
  late TextEditingController _mobileNumberControl;
  late TextEditingController _passwordControl;
  late TextEditingController _stateControl;
  late TextEditingController _facilityControl;
  late TextEditingController _departmentControl;
  late TextEditingController _designationControl;
  String stateName = "";
  String staffStateName = "";
  String facilityStateName = "";
  String locationName = "";
  String staffLocationName = "";
  String facilityLocationName = "";
  String departmentName = "";
  String supervisorEmail = "";
  String supervisorName = "";
  String staffdepartmentName = "";
  String facilitydepartmentName = "";
  String designation = "";
  String staffdesignationName = "";
  String facilitydesignationName = "";
  String projectName = "";
  String staffingCategory = "";
  bool? isVeriffied;
  DatabaseAdapter adapter = HiveService();

  List<DropdownMenuItem<String>> menuitems = [];
  List<DropdownMenuItem<String>> menuitems2 = [];
  bool disableddropdown = true;
  bool disableddropdown2 = true;
  bool disableddropdown3 = true;
  bool disableddropdown4 = true;
  String value = "";
  String value2 = "";
  String value3 = "";
  String value4 = "";
  String value5 = "";
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  bool _isObscure3 = true;

  double screenHeight = 0;
  double screenWidth = 0;
  late SharedPreferences sharedPreferences;
  var firstName;
  var lastName;
  var firebaseAuthId;
  var staffCategory;
  var state;
  var emailAddress;
  var location;
  var department;
  var mobile;
  var project;

  @override
  void initState() {
    _firstNameControl = TextEditingController();
    _lastNameControl = TextEditingController();
    _emailAddressControl = TextEditingController();
    _mobileNumberControl = TextEditingController();
    _passwordControl = TextEditingController();
    _stateControl = TextEditingController();
    _facilityControl = TextEditingController();
    _departmentControl = TextEditingController();
    _designationControl = TextEditingController();
    _getUserDetail();
    super.initState();
  }

  @override
  void dispose() {
    _firstNameControl.dispose();
    _lastNameControl.dispose();
    _emailAddressControl.dispose();
    _mobileNumberControl.dispose();
    _passwordControl.dispose();
    _stateControl.dispose();
    _facilityControl.dispose();
    _departmentControl.dispose();
    _designationControl.dispose();
    super.dispose();
  }



  Future<List<Uint8List>?> _readImagesFromDatabase() async {
    return adapter.getImages();
  }

  Future<List<DropdownMenuItem<String>>> _fetchStatesFromIsar(String state) async {
    List<String?> states = await IsarService().getStatesFromIsar(state);
    // Remove duplicates:
    Set<String?> uniqueStates = Set.from(states);
    // Convert to DropdownMenuItem list:
    return uniqueStates.map((state) => DropdownMenuItem<String>(
      value: state,
      child: Text(state!),
    )).toList();
  }

  Future<List<DropdownMenuItem<String>>> _fetchStatesFromIsarForFCT(String state) async {
    List<String?> states = await IsarService().getStatesFromIsarForFCT(state);
    // Remove duplicates:
    Set<String?> uniqueStates = Set.from(states);
    // Convert to DropdownMenuItem list:
    return uniqueStates.map((state) => DropdownMenuItem<String>(
      value: state,
      child: Text(state!),
    )).toList();
  }

  Future<List<DropdownMenuItem<String>>> _fetchLocationsFromIsar(String state,String category) async {
    // Query Isar database for locations based on the selected state
    List<String?> locations = await IsarService().getLocationsFromIsar(state,category);

    // Convert the locations list to DropdownMenuItem list
    return locations.map((location) => DropdownMenuItem<String>(
      value: location,
      child: Text(location!),
    )).toList();
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

  Future<List<DropdownMenuItem<String>>> _fetchSupervisorsFromIsar(String department,String state) async {
    // Query Isar database for designations based on the selected department
    List<String?> supervisors = await IsarService().getSupervisorsFromIsar(department,state);

    // Convert the designations list to DropdownMenuItem list
    return supervisors.map((supervisor) => DropdownMenuItem<String>(
      value: supervisor,
      child: Text(supervisor!),
    )).toList();
  }

  Future<List<DropdownMenuItem<String>>> _fetchSupervisorEmailFromIsar(String department,String nameofsupervisor) async {
    // Query Isar database for designations based on the selected department
    List<String?> supervisorsemail = await IsarService().getSupervisorEmailFromIsar(department,nameofsupervisor);

    // Convert the designations list to DropdownMenuItem list
    return supervisorsemail.map((supervisoremail) => DropdownMenuItem<String>(
      value: supervisoremail,
      child: Text(supervisoremail!),
    )).toList();
  }

  Future<List<DropdownMenuItem<String>>> _fetchDesignationsFromIsar(String department,String category) async {
    // Query Isar database for designations based on the selected department
    List<String?> designations = await IsarService().getDesignationsFromIsar(department,category);

    // Convert the designations list to DropdownMenuItem list
    return designations.map((designation) => DropdownMenuItem<String>(
      value: designation,
      child: Text(designation!),
    )).toList();
  }




  Future<List<DropdownMenuItem<String>>> _fetchStaffCategoryFromIsar() async {
    // Query Isar database for designations based on the selected department
    List<String?> staffCategory = await IsarService().getStaffCategoryFromIsar();

    // Convert the designations list to DropdownMenuItem list
    return staffCategory.map((staffCategory) => DropdownMenuItem<String>(
      value: staffCategory,
      child: Text(staffCategory!),
    )).toList();
  }

  Future<List<DropdownMenuItem<String>>> _fetchProjectFromIsar() async {
    // Query Isar database for designations based on the selected department
    List<String?> project = await IsarService().getProjectFromIsar();

    // Convert the designations list to DropdownMenuItem list
    return project.map((project) => DropdownMenuItem<String>(
      value: project,
      child: Text(project!),
    )).toList();
  }


  // Helper function to build a DropdownMenuItem
  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value: item,
    child: Text(
      item,
      style: TextStyle(fontSize: 13, fontFamily: "NexaLight"),
    ),
  );



  void _getUserDetail() async {
    final userDetail = await IsarService().getBioInfoWithFirebaseAuth();
    setState(() {
      firebaseAuthId = userDetail?.firebaseAuthId;
      state = userDetail?.state;
      project = userDetail?.project;
      firstName = userDetail?.firstName;
      lastName = userDetail?.lastName;
      //designation = userDetail?.designation;
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

      // Uint8List imageBytes = await image.readAsBytes();

      // // Replace "your-bucket-name" with your actual Google Cloud Storage bucket name
      // String bucketName = "your-bucket-name";

      // // Specify the path where you want to store the image in the bucket
      // //String storagePath = "profile_pics/${DateTime.now().millisecondsSinceEpoch}.jpg";
      // String storagePath = "profile_pics/${firstName.toLowerCase()}_${lastName.toLowerCase()}_${firebaseAuthId}_profilepic.jpg";

      // await firebase_storage.FirebaseStorage.instance
      //     .ref('$bucketName/$storagePath')
      //     .putData(imageBytes);

      // String downloadURL = await firebase_storage.FirebaseStorage.instance
      //     .ref('$bucketName/$storagePath')
      //     .getDownloadURL();

      // setState(() {
      //   // Save the profile pic URL in your class
      //   // Assuming you have a variable named 'profilePicLink' in your class
      //   // Replace 'YourClass' with the actual name of your class
      //   UserModel.profilePicLink = downloadURL;
      // });

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
      //     "photoUrl": value,
      //   });
      // });

      // Save the profile pic link to Firestore or any other storage
      // Replace the following lines with your Firestore update logic
      // await FirebaseFirestore.instance
      //     .collection("Staff")
      //     .doc(firebaseAuthId)
      //     .update({
      //   "profilePic": downloadURL,
      // });

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


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Registration Page",
          style: TextStyle(color: Colors.red, fontFamily: "NexaBold"),
        ),
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.red),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.white,
                    Colors.white,
                  ])),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 15, right: 15, bottom: 15),
            child: Stack(
              children: <Widget>[
                Image.asset("./assets/image/ccfn_logo.png"),
              ],
            ),
          )
        ],
      ),
      drawer: role == "User"
          ? drawer(this.context, IsarService())
          : drawer2(this.context, IsarService()),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 150,
              child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  //
                    Column(
                      children: [

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


                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "First Name",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration:
                              ThemeHelper().inputBoxDecorationShaddow(),
                              child: TextFormField(
                                controller: _firstNameControl,
                                decoration: ThemeHelper().textInputDecoration(
                                  "",
                                  "Enter your First Name",
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.person,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                validator: (value) =>
                                value != null && value.isEmpty
                                    ? 'Enter First Name'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Last Name",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration:
                              ThemeHelper().inputBoxDecorationShaddow(),
                              child: TextFormField(
                                controller: _lastNameControl,
                                decoration: ThemeHelper().textInputDecoration(
                                  "",
                                  "Enter your Last Name",
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.person,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                validator: (value) =>
                                value != null && value.isEmpty
                                    ? 'Enter Last Name'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email Address",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration:
                              ThemeHelper().inputBoxDecorationShaddow(),
                              child: TextFormField(
                                controller: _emailAddressControl,
                                decoration: ThemeHelper().textInputDecoration(
                                  "",
                                  "Enter your email",
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.email,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) {
                                  if ((!(val!.isEmpty) &&
                                      !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                          .hasMatch(val)) ||
                                      (val != null && val.isEmpty)) {
                                    return "Enter a valid email address";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Mobile Number",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration:
                              ThemeHelper().inputBoxDecorationShaddow(),
                              child: TextFormField(
                                controller: _mobileNumberControl,
                                decoration: ThemeHelper().textInputDecoration(
                                  "",
                                  "Enter your Mobile Number",
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.phone_android,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (val) {
                                  if ((!(val!.isEmpty) &&
                                      !RegExp(r"^(\d+)*$").hasMatch(val)) ||
                                      (val != null && val.isEmpty)) {
                                    return "Enter a valid phone number";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),

                        FutureBuilder<List<DropdownMenuItem<String>>>(
                          future: _fetchStaffCategoryFromIsar(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                              // Check if facilityStateName is in the list of dropdown values
                              String? selectedStaffCategory = snapshot.data!.any((item) => item.value == value5)
                                  ? value5
                                  : null;

                              // If there's no valid state selected, set the first item as the default
                              if (selectedStaffCategory == null) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  setState(() {
                                    //facilityStateName = snapshot.data!.first.value!;
                                    // facilityStateName = "Select your state";
                                  });
                                });
                              }

                              return MyInputField(
                                title: "Staff Category",
                                hint: "Select Staff Category",
                                widget: Container(
                                  width: MediaQuery.of(context).size.width*0.81,
                                  //height: MediaQuery.of(context).size.height * 1,// Set your desired width
                                  //color:Colors.red,
                                  child: SizedBox(
                                      child:SizedBox(
                                          child:
                                          DropdownButtonFormField<String>(

                                            decoration: InputDecoration(
                                              iconColor:Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                            value: selectedStaffCategory,
                                            icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: Container( // Wrap the Text inside the DropdownMenuItem
                                                // width: MediaQuery.of(context).size.width * 0.66,
                                                //color: Colors.pink,// Adjust this width as needed
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                //departmentName = value!;
                                                value5 = value!;
                                                disableddropdown = false;
                                              });
                                            },
                                            isExpanded: true,
                                          ))),
                                ),
                              );

                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),

          // Container that displays State of Implementation,Location,Department and designation based on staff category selection
                        Container(
                          child: value5 == ""
                              ? Container()
                              :
                          //State List
                          Container(
                            child: value5 == "Facility Staff"
                                ?
                            Column(
                               // Add this line

                              children: [

                                FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchStatesFromIsar("Federal Capital Territory"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedState = snapshot.data!.any((item) => item.value == facilityStateName)
                                          ? facilityStateName
                                          : null;

                                      // If there's no valid state selected, set the first item as the default
                                      if (selectedState == null) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          setState(() {
                                            //facilityStateName = snapshot.data!.first.value!;
                                             // facilityStateName = "Select your state";
                                          });
                                        });
                                      }

                                      return  MyInputField(
                                        title: "State Of Implementations",
                                        hint: "",
                                        widget: Container(
                                          width: MediaQuery.of(context).size.width*0.81,
                                          child: SizedBox(
                                              child:SizedBox(
                                                  child:
                                                  DropdownButtonFormField<String>(

                                                    decoration: InputDecoration(
                                                      iconColor:Colors.blue,
                                                      labelText: "",
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    value: selectedState,
                                                    icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                                    dropdownColor: Colors.white,
                                                    elevation: 4,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: "NexaBold",
                                                    ),
                                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                                      value: item.value,
                                                      child: Container( // Wrap the Text inside the DropdownMenuItem
                                                        // width: MediaQuery.of(context).size.width * 0.66,
                                                        //color: Colors.pink,// Adjust this width as needed
                                                        child: Text(
                                                          (item.child as Text).data!,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    )).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        stateName = value!;
                                                        facilityStateName = value;
                                                        disableddropdown = false;
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  ))),
                                        ),
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                                // Facility List
                                stateName != null && stateName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchLocationsFromIsar(stateName,"Facility"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedLocation = snapshot.data!.any((item) => item.value == facilityLocationName)
                                          ? facilityLocationName
                                          : null;

                                      // If there's no valid state selected, set the first item as the default
                                      if (selectedLocation == null) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          setState(() {
                                            //facilityStateName = snapshot.data!.first.value!;
                                            // facilityStateName = "Select your state";
                                          });
                                        });
                                      }

                                      return MyInputField(
                                        title: "Location",
                                        hint: "",
                                        widget: Container(
                                          width: MediaQuery.of(context).size.width*0.81,
                                          //height: MediaQuery.of(context).size.height * 1,// Set your desired width
                                          //color:Colors.red,
                                          child: SizedBox(
                                              child:SizedBox(
                                                  child:
                                                  DropdownButtonFormField<String>(

                                                    decoration: InputDecoration(
                                                      iconColor:Colors.blue,
                                                      labelText: "",
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    value: selectedLocation,
                                                    icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                                    dropdownColor: Colors.white,
                                                    elevation: 4,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: "NexaBold",
                                                    ),
                                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                                      value: item.value,
                                                      child: Container( // Wrap the Text inside the DropdownMenuItem
                                                        // width: MediaQuery.of(context).size.width * 0.66,
                                                        //color: Colors.pink,// Adjust this width as needed
                                                        child: Text(
                                                          (item.child as Text).data!,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    )).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        locationName = value!;
                                                        //selectedLocation = value;
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  ))),
                                        ),
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                )
                                    : const MyInputField(
                                  title: "Location",
                                  hint: "",
                                  widget: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
                                    child: Text(
                                      "First Select your state",
                                      style: TextStyle(
                                        fontSize: 15, // Optional: Adjust font size as needed
                                        fontWeight: FontWeight.normal, // Optional: Adjust text weight
                                      ),
                                    ),
                                  ),
                                ),
                                    // Department
                                FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchDepartmentsForFacilityFromIsar(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDepartment = snapshot.data!.any((item) => item.value == facilitydepartmentName)
                                          ? facilitydepartmentName
                                          : null;

                                      // If there's no valid state selected, set the first item as the default
                                      if (selectedDepartment == null) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          setState(() {
                                            //facilityStateName = snapshot.data!.first.value!;
                                            // facilityStateName = "Select your state";
                                          });
                                        });
                                      }

                                      return MyInputField(
                                        title: "Department",
                                        hint: "",
                                        widget: Container(
                                          width: MediaQuery.of(context).size.width*0.81,
                                          //height: MediaQuery.of(context).size.height * 1,// Set your desired width
                                          //color:Colors.red,
                                          child: SizedBox(
                                              child:SizedBox(
                                                  child:
                                                  DropdownButtonFormField<String>(

                                                    decoration: InputDecoration(
                                                      iconColor:Colors.blue,
                                                      labelText: "",
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    value: selectedDepartment,
                                                    icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                                    dropdownColor: Colors.white,
                                                    elevation: 4,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: "NexaBold",
                                                    ),
                                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                                      value: item.value,
                                                      child: Container( // Wrap the Text inside the DropdownMenuItem
                                                        // width: MediaQuery.of(context).size.width * 0.66,
                                                        //color: Colors.pink,// Adjust this width as needed
                                                        child: Text(
                                                          (item.child as Text).data!,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    )).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        departmentName = value!;
                                                        facilitydepartmentName = value!;
                                                        disableddropdown = false;
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  ))),
                                        ),
                                      );

                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                                // Designations
                                facilitydepartmentName != null && facilitydepartmentName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchDesignationsFromIsar(departmentName,"Facility Staff"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDesignation = snapshot.data!.any((item) => item.value == facilitydesignationName)
                                          ? facilitydesignationName
                                          : null;

                                      // If there's no valid state selected, set the first item as the default
                                      if (selectedDesignation == null) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          setState(() {
                                            //facilityStateName = snapshot.data!.first.value!;
                                            // facilityStateName = "Select your state";
                                          });
                                        });
                                      }

                                      return MyInputField(
                                        title: "Designation",
                                        hint: "",
                                        widget: Container(
                                          width: MediaQuery.of(context).size.width*0.81,
                                          //height: MediaQuery.of(context).size.height * 1,// Set your desired width
                                          //color:Colors.red,
                                          child: SizedBox(
                                              child:SizedBox(
                                                  child:
                                                  DropdownButtonFormField<String>(

                                                    decoration: InputDecoration(
                                                      iconColor:Colors.blue,
                                                      labelText: "",
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    value: selectedDesignation,
                                                    icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                                    dropdownColor: Colors.white,
                                                    elevation: 4,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: "NexaBold",
                                                    ),
                                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                                      value: item.value,
                                                      child: Container( // Wrap the Text inside the DropdownMenuItem
                                                        // width: MediaQuery.of(context).size.width * 0.66,
                                                        //color: Colors.pink,// Adjust this width as needed
                                                        child: Text(
                                                          (item.child as Text).data!,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    )).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        designation = value!;
                                                        facilitydesignationName = value;
                                                        disableddropdown = false;
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  ))),
                                        ),
                                      );

                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                )
                                    :const MyInputField(
                                  title: "Designation",
                                  hint: "",
                                  widget: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
                                    child: Text(
                                      "First Select your department",
                                      style: TextStyle(
                                        fontSize: 15, // Optional: Adjust font size as needed
                                        fontWeight: FontWeight.normal, // Optional: Adjust text weight
                                      ),
                                    ),
                                  ),
                                ),

                                //_fetchProjectFromIsar

                                // Supervisor
                                facilitydepartmentName != null && facilitydepartmentName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchSupervisorsFromIsar(departmentName,stateName),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDesignation = snapshot.data!.any((item) => item.value == supervisorName)
                                          ? supervisorName
                                          : null;

                                      // If there's no valid state selected, set the first item as the default
                                      if (selectedDesignation == null) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          setState(() {
                                            //facilityStateName = snapshot.data!.first.value!;
                                            // facilityStateName = "Select your state";
                                          });
                                        });
                                      }

                                      return MyInputField(
                                        title: "Name of Supervisor",
                                        hint: "",
                                        widget: Container(
                                          width: MediaQuery.of(context).size.width*0.81,
                                          //height: MediaQuery.of(context).size.height * 1,// Set your desired width
                                          //color:Colors.red,
                                          child: SizedBox(
                                              child:SizedBox(
                                                  child:
                                                  DropdownButtonFormField<String>(

                                                    decoration: InputDecoration(
                                                      iconColor:Colors.blue,
                                                      labelText: "",
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    value: selectedDesignation,
                                                    icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                                    dropdownColor: Colors.white,
                                                    elevation: 4,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: "NexaBold",
                                                    ),
                                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                                      value: item.value,
                                                      child: Container( // Wrap the Text inside the DropdownMenuItem
                                                        // width: MediaQuery.of(context).size.width * 0.66,
                                                        //color: Colors.pink,// Adjust this width as needed
                                                        child: Text(
                                                          (item.child as Text).data!,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    )).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        supervisorName = value!;
                                                        //facilitydesignationName = value;
                                                        disableddropdown = false;
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  ))),
                                        ),
                                      );

                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                )
                                    :const MyInputField(
                                  title: "Name of Supervisor",
                                  hint: "",
                                  widget: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
                                    child: Text(
                                      "First Select your department",
                                      style: TextStyle(
                                        fontSize: 15, // Optional: Adjust font size as needed
                                        fontWeight: FontWeight.normal, // Optional: Adjust text weight
                                      ),
                                    ),
                                  ),
                                ),

                                // Supervisor Email
                                supervisorName != null && supervisorName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchSupervisorEmailFromIsar(departmentName,supervisorName),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDesignation = snapshot.data!.any((item) => item.value == supervisorEmail)
                                          ? supervisorEmail
                                          : null;

                                      // If there's no valid state selected, set the first item as the default
                                      if (selectedDesignation == null) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          setState(() {
                                            //facilityStateName = snapshot.data!.first.value!;
                                            // facilityStateName = "Select your state";
                                          });
                                        });
                                      }

                                      return MyInputField(
                                        title: "Email of Supervisor",
                                        hint: "",
                                        widget: Container(
                                          width: MediaQuery.of(context).size.width*0.81,
                                          //height: MediaQuery.of(context).size.height * 1,// Set your desired width
                                          //color:Colors.red,
                                          child: SizedBox(
                                              child:SizedBox(
                                                  child:
                                                  DropdownButtonFormField<String>(

                                                    decoration: InputDecoration(
                                                      iconColor:Colors.blue,
                                                      labelText: "",
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    value: selectedDesignation,
                                                    icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                                    dropdownColor: Colors.white,
                                                    elevation: 4,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: "NexaBold",
                                                    ),
                                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                                      value: item.value,
                                                      child: Container( // Wrap the Text inside the DropdownMenuItem
                                                        // width: MediaQuery.of(context).size.width * 0.66,
                                                        //color: Colors.pink,// Adjust this width as needed
                                                        child: Text(
                                                          (item.child as Text).data!,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    )).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        supervisorEmail = value!;
                                                        //facilitydesignationName = value;
                                                        disableddropdown = false;
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  ))),
                                        ),
                                      );

                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                )
                                    :const MyInputField(
                                  title: "  Email of Supervisor",
                                  hint: "",
                                  widget: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
                                    child: Text(
                                      "First Select your Supervisor",
                                      style: TextStyle(
                                        fontSize: 15, // Optional: Adjust font size as needed
                                        fontWeight: FontWeight.normal, // Optional: Adjust text weight
                                      ),
                                    ),
                                  ),
                                ),



                              ],
                            )
// ---------------------------------------------------------------------------
                            // State of Cordination
                                : value5 == "State Office Staff" ?
                            Column(
                              // Add this line

                              children: [

                                FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchStatesFromIsar("Federal Capital Territory"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedState = snapshot.data!.any((item) => item.value == facilityStateName)
                                          ? facilityStateName
                                          : null;

                                      // If there's no valid state selected, set the first item as the default
                                      if (selectedState == null) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          setState(() {
                                            //facilityStateName = snapshot.data!.first.value!;
                                            // facilityStateName = "Select your state";
                                          });
                                        });
                                      }

                                      return  MyInputField(
                                        title: "State",
                                        hint: "",
                                        widget: Container(
                                          width: MediaQuery.of(context).size.width*0.81,
                                          child: SizedBox(
                                              child:SizedBox(
                                                  child:
                                                  DropdownButtonFormField<String>(

                                                    decoration: InputDecoration(
                                                      iconColor:Colors.blue,
                                                      labelText: "",
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    value: selectedState,
                                                    icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                                    dropdownColor: Colors.white,
                                                    elevation: 4,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: "NexaBold",
                                                    ),
                                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                                      value: item.value,
                                                      child: Container( // Wrap the Text inside the DropdownMenuItem
                                                        // width: MediaQuery.of(context).size.width * 0.66,
                                                        //color: Colors.pink,// Adjust this width as needed
                                                        child: Text(
                                                          (item.child as Text).data!,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    )).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        stateName = value!;
                                                        facilityStateName = value;
                                                        disableddropdown = false;
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  ))),
                                        ),
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                                // Facility List
                                stateName != null && stateName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchLocationsFromIsar(stateName,"State Office"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedLocation = snapshot.data!.any((item) => item.value == locationName)
                                          ? locationName
                                          : null;

                                      // If there's no valid state selected, set the first item as the default
                                      if (selectedLocation == null) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          setState(() {
                                            //facilityStateName = snapshot.data!.first.value!;
                                            // facilityStateName = "Select your state";
                                          });
                                        });
                                      }

                                      return MyInputField(
                                        title: "Office",
                                        hint: "",
                                        widget: Container(
                                          width: MediaQuery.of(context).size.width*0.81,
                                          //height: MediaQuery.of(context).size.height * 1,// Set your desired width
                                          //color:Colors.red,
                                          child: SizedBox(
                                              child:SizedBox(
                                                  child:
                                                  DropdownButtonFormField<String>(

                                                    decoration: InputDecoration(
                                                      iconColor:Colors.blue,
                                                      labelText: "",
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    value: selectedLocation,
                                                    icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                                    dropdownColor: Colors.white,
                                                    elevation: 4,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: "NexaBold",
                                                    ),
                                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                                      value: item.value,
                                                      child: Container( // Wrap the Text inside the DropdownMenuItem
                                                        // width: MediaQuery.of(context).size.width * 0.66,
                                                        //color: Colors.pink,// Adjust this width as needed
                                                        child: Text(
                                                          (item.child as Text).data!,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    )).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        locationName = value!;
                                                        //selectedLocation = value;
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  ))),
                                        ),
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                )
                                    : const MyInputField(
                                  title: "State",
                                  hint: "",
                                  widget: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
                                    child: Text(
                                      "First Select your state",
                                      style: TextStyle(
                                        fontSize: 15, // Optional: Adjust font size as needed
                                        fontWeight: FontWeight.normal, // Optional: Adjust text weight
                                      ),
                                    ),
                                  ),
                                ),
                                // Department
                                FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchDepartmentsFromIsar(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDepartment = snapshot.data!.any((item) => item.value == facilitydepartmentName)
                                          ? facilitydepartmentName
                                          : null;

                                      // If there's no valid state selected, set the first item as the default
                                      if (selectedDepartment == null) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          setState(() {
                                            //facilityStateName = snapshot.data!.first.value!;
                                            // facilityStateName = "Select your state";
                                          });
                                        });
                                      }

                                      return MyInputField(
                                        title: "Department",
                                        hint: "",
                                        widget: Container(
                                          width: MediaQuery.of(context).size.width*0.81,
                                          //height: MediaQuery.of(context).size.height * 1,// Set your desired width
                                          //color:Colors.red,
                                          child: SizedBox(
                                              child:SizedBox(
                                                  child:
                                                  DropdownButtonFormField<String>(

                                                    decoration: InputDecoration(
                                                      iconColor:Colors.blue,
                                                      labelText: "",
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    value: selectedDepartment,
                                                    icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                                    dropdownColor: Colors.white,
                                                    elevation: 4,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: "NexaBold",
                                                    ),
                                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                                      value: item.value,
                                                      child: Container( // Wrap the Text inside the DropdownMenuItem
                                                        // width: MediaQuery.of(context).size.width * 0.66,
                                                        //color: Colors.pink,// Adjust this width as needed
                                                        child: Text(
                                                          (item.child as Text).data!,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    )).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        departmentName = value!;
                                                        facilitydepartmentName = value;
                                                        disableddropdown = false;
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  ))),
                                        ),
                                      );

                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                                // Designations
                                departmentName != null && departmentName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchDesignationsFromIsar(departmentName,"Office Staff"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDesignation = snapshot.data!.any((item) => item.value == facilitydesignationName)
                                          ? facilitydesignationName
                                          : null;

                                      // If there's no valid state selected, set the first item as the default
                                      if (selectedDesignation == null) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          setState(() {
                                            //facilityStateName = snapshot.data!.first.value!;
                                            // facilityStateName = "Select your state";
                                          });
                                        });
                                      }

                                      return MyInputField(
                                        title: "Designation",
                                        hint: "",
                                        widget: Container(
                                          width: MediaQuery.of(context).size.width*0.81,
                                          //height: MediaQuery.of(context).size.height * 1,// Set your desired width
                                          //color:Colors.red,
                                          child: SizedBox(
                                              child:SizedBox(
                                                  child:
                                                  DropdownButtonFormField<String>(

                                                    decoration: InputDecoration(
                                                      iconColor:Colors.blue,
                                                      labelText: "",
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    value: selectedDesignation,
                                                    icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                                    dropdownColor: Colors.white,
                                                    elevation: 4,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: "NexaBold",
                                                    ),
                                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                                      value: item.value,
                                                      child: Container( // Wrap the Text inside the DropdownMenuItem
                                                        // width: MediaQuery.of(context).size.width * 0.66,
                                                        //color: Colors.pink,// Adjust this width as needed
                                                        child: Text(
                                                          (item.child as Text).data!,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    )).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        designation = value!;
                                                        facilitydesignationName = value;
                                                        disableddropdown = false;
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  ))),
                                        ),
                                      );

                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                )
                                    :const MyInputField(
                                  title: "Designation",
                                  hint: "",
                                  widget: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
                                    child: Text(
                                      "First Select your department",
                                      style: TextStyle(
                                        fontSize: 15, // Optional: Adjust font size as needed
                                        fontWeight: FontWeight.normal, // Optional: Adjust text weight
                                      ),
                                    ),
                                  ),
                                ),

                                //_fetchProjectFromIsar
                                // Supervisor
                                departmentName != null && departmentName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchSupervisorsFromIsar(departmentName,stateName),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDesignation = snapshot.data!.any((item) => item.value == supervisorName)
                                          ? supervisorName
                                          : null;

                                      // If there's no valid state selected, set the first item as the default
                                      if (selectedDesignation == null) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          setState(() {
                                            //facilityStateName = snapshot.data!.first.value!;
                                            // facilityStateName = "Select your state";
                                          });
                                        });
                                      }

                                      return MyInputField(
                                        title: "Name of Supervisor",
                                        hint: "",
                                        widget: Container(
                                          width: MediaQuery.of(context).size.width*0.81,
                                          //height: MediaQuery.of(context).size.height * 1,// Set your desired width
                                          //color:Colors.red,
                                          child: SizedBox(
                                              child:SizedBox(
                                                  child:
                                                  DropdownButtonFormField<String>(

                                                    decoration: InputDecoration(
                                                      iconColor:Colors.blue,
                                                      labelText: "",
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    value: selectedDesignation,
                                                    icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                                    dropdownColor: Colors.white,
                                                    elevation: 4,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: "NexaBold",
                                                    ),
                                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                                      value: item.value,
                                                      child: Container( // Wrap the Text inside the DropdownMenuItem
                                                        // width: MediaQuery.of(context).size.width * 0.66,
                                                        //color: Colors.pink,// Adjust this width as needed
                                                        child: Text(
                                                          (item.child as Text).data!,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    )).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        supervisorName = value!;
                                                        //facilitydesignationName = value;
                                                        disableddropdown = false;
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  ))),
                                        ),
                                      );

                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                )
                                    :const MyInputField(
                                  title: "Name of Supervisor",
                                  hint: "",
                                  widget: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
                                    child: Text(
                                      "First Select your department",
                                      style: TextStyle(
                                        fontSize: 15, // Optional: Adjust font size as needed
                                        fontWeight: FontWeight.normal, // Optional: Adjust text weight
                                      ),
                                    ),
                                  ),
                                ),

                                // Supervisor Email
                                supervisorName != null && supervisorName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchSupervisorEmailFromIsar(departmentName,supervisorName),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDesignation = snapshot.data!.any((item) => item.value == supervisorEmail)
                                          ? supervisorEmail
                                          : null;

                                      // If there's no valid state selected, set the first item as the default
                                      if (selectedDesignation == null) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          setState(() {
                                            //facilityStateName = snapshot.data!.first.value!;
                                            // facilityStateName = "Select your state";
                                          });
                                        });
                                      }

                                      return MyInputField(
                                        title: "Email of Supervisor",
                                        hint: "",
                                        widget: Container(
                                          width: MediaQuery.of(context).size.width*0.81,
                                          //height: MediaQuery.of(context).size.height * 1,// Set your desired width
                                          //color:Colors.red,
                                          child: SizedBox(
                                              child:SizedBox(
                                                  child:
                                                  DropdownButtonFormField<String>(

                                                    decoration: InputDecoration(
                                                      iconColor:Colors.blue,
                                                      labelText: "",
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    value: selectedDesignation,
                                                    icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                                    dropdownColor: Colors.white,
                                                    elevation: 4,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: "NexaBold",
                                                    ),
                                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                                      value: item.value,
                                                      child: Container( // Wrap the Text inside the DropdownMenuItem
                                                        // width: MediaQuery.of(context).size.width * 0.66,
                                                        //color: Colors.pink,// Adjust this width as needed
                                                        child: Text(
                                                          (item.child as Text).data!,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    )).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        supervisorEmail = value!;
                                                        //facilitydesignationName = value;
                                                        disableddropdown = false;
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  ))),
                                        ),
                                      );

                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                )
                                    :const MyInputField(
                                  title: "  Email of Supervisor",
                                  hint: "",
                                  widget: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
                                    child: Text(
                                      "First Select your Supervisor",
                                      style: TextStyle(
                                        fontSize: 15, // Optional: Adjust font size as needed
                                        fontWeight: FontWeight.normal, // Optional: Adjust text weight
                                      ),
                                    ),
                                  ),
                                ),




                              ],
                            )
                            :
                            Column(
                              // Add this line

                              children: [

                                FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchStatesFromIsarForFCT("Federal Capital Territory"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedState = snapshot.data!.any((item) => item.value == locationName)
                                          ? locationName
                                          : null;

                                      // If there's no valid state selected, set the first item as the default
                                      if (selectedState == null) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          setState(() {
                                            //facilityStateName = snapshot.data!.first.value!;
                                            // facilityStateName = "Select your state";
                                          });
                                        });
                                      }

                                      return  MyInputField(
                                        title: "State (HQ)",
                                        hint: "",
                                        widget: Container(
                                          width: MediaQuery.of(context).size.width*0.81,
                                          child: SizedBox(
                                              child:SizedBox(
                                                  child:
                                                  DropdownButtonFormField<String>(

                                                    decoration: InputDecoration(
                                                      iconColor:Colors.blue,
                                                      labelText: "",
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    value: selectedState,
                                                    icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                                    dropdownColor: Colors.white,
                                                    elevation: 4,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: "NexaBold",
                                                    ),
                                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                                      value: item.value,
                                                      child: Container( // Wrap the Text inside the DropdownMenuItem
                                                        // width: MediaQuery.of(context).size.width * 0.66,
                                                        //color: Colors.pink,// Adjust this width as needed
                                                        child: Text(
                                                          (item.child as Text).data!,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    )).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        stateName = value!;
                                                        facilityStateName = value;
                                                        disableddropdown = false;
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  ))),
                                        ),
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                                // Facility List
                                stateName != null && stateName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchLocationsFromIsar(stateName,"HQ"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedLocation = snapshot.data!.any((item) => item.value == facilityLocationName)
                                          ? facilityLocationName
                                          : null;

                                      // If there's no valid state selected, set the first item as the default
                                      if (selectedLocation == null) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          setState(() {
                                            //facilityStateName = snapshot.data!.first.value!;
                                            // facilityStateName = "Select your state";
                                          });
                                        });
                                      }

                                      return MyInputField(
                                        title: "Office",
                                        hint: "",
                                        widget: Container(
                                          width: MediaQuery.of(context).size.width*0.81,
                                          //height: MediaQuery.of(context).size.height * 1,// Set your desired width
                                          //color:Colors.red,
                                          child: SizedBox(
                                              child:SizedBox(
                                                  child:
                                                  DropdownButtonFormField<String>(

                                                    decoration: InputDecoration(
                                                      iconColor:Colors.blue,
                                                      labelText: "",
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    value: selectedLocation,
                                                    icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                                    dropdownColor: Colors.white,
                                                    elevation: 4,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: "NexaBold",
                                                    ),
                                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                                      value: item.value,
                                                      child: Container( // Wrap the Text inside the DropdownMenuItem
                                                        // width: MediaQuery.of(context).size.width * 0.66,
                                                        //color: Colors.pink,// Adjust this width as needed
                                                        child: Text(
                                                          (item.child as Text).data!,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    )).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        locationName = value!;
                                                        selectedLocation = value;
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  ))),
                                        ),
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                )
                                    : const MyInputField(
                                  title: "Office",
                                  hint: "",
                                  widget: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
                                    child: Text(
                                      "First Select your state",
                                      style: TextStyle(
                                        fontSize: 15, // Optional: Adjust font size as needed
                                        fontWeight: FontWeight.normal, // Optional: Adjust text weight
                                      ),
                                    ),
                                  ),
                                ),
                                // Department
                                FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchDepartmentsFromIsar(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDepartment = snapshot.data!.any((item) => item.value == facilitydepartmentName)
                                          ? facilitydepartmentName
                                          : null;

                                      // If there's no valid state selected, set the first item as the default
                                      if (selectedDepartment == null) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          setState(() {
                                            //facilityStateName = snapshot.data!.first.value!;
                                            // facilityStateName = "Select your state";
                                          });
                                        });
                                      }

                                      return MyInputField(
                                        title: "Department",
                                        hint: "",
                                        widget: Container(
                                          width: MediaQuery.of(context).size.width*0.81,
                                          //height: MediaQuery.of(context).size.height * 1,// Set your desired width
                                          //color:Colors.red,
                                          child: SizedBox(
                                              child:SizedBox(
                                                  child:
                                                  DropdownButtonFormField<String>(

                                                    decoration: InputDecoration(
                                                      iconColor:Colors.blue,
                                                      labelText: "",
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    value: selectedDepartment,
                                                    icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                                    dropdownColor: Colors.white,
                                                    elevation: 4,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: "NexaBold",
                                                    ),
                                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                                      value: item.value,
                                                      child: Container( // Wrap the Text inside the DropdownMenuItem
                                                        // width: MediaQuery.of(context).size.width * 0.66,
                                                        //color: Colors.pink,// Adjust this width as needed
                                                        child: Text(
                                                          (item.child as Text).data!,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    )).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        departmentName = value!;
                                                        facilitydepartmentName = value;
                                                        disableddropdown = false;
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  ))),
                                        ),
                                      );

                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                                // Designations
                                departmentName != null && departmentName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchDesignationsFromIsar(departmentName,"Office Staff"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDesignation = snapshot.data!.any((item) => item.value == facilitydesignationName)
                                          ? facilitydesignationName
                                          : null;

                                      // If there's no valid state selected, set the first item as the default
                                      if (selectedDesignation == null) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          setState(() {
                                            //facilityStateName = snapshot.data!.first.value!;
                                            // facilityStateName = "Select your state";
                                          });
                                        });
                                      }

                                      return MyInputField(
                                        title: "Designation",
                                        hint: "",
                                        widget: Container(
                                          width: MediaQuery.of(context).size.width*0.81,
                                          //height: MediaQuery.of(context).size.height * 1,// Set your desired width
                                          //color:Colors.red,
                                          child: SizedBox(
                                              child:SizedBox(
                                                  child:
                                                  DropdownButtonFormField<String>(

                                                    decoration: InputDecoration(
                                                      iconColor:Colors.blue,
                                                      labelText: "",
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    value: selectedDesignation,
                                                    icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                                    dropdownColor: Colors.white,
                                                    elevation: 4,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: "NexaBold",
                                                    ),
                                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                                      value: item.value,
                                                      child: Container( // Wrap the Text inside the DropdownMenuItem
                                                        // width: MediaQuery.of(context).size.width * 0.66,
                                                        //color: Colors.pink,// Adjust this width as needed
                                                        child: Text(
                                                          (item.child as Text).data!,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    )).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        designation = value!;
                                                        facilitydesignationName = value;
                                                        disableddropdown = false;
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  ))),
                                        ),
                                      );

                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                )
                                    :const MyInputField(
                                  title: "Designation",
                                  hint: "",
                                  widget: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
                                    child: Text(
                                      "First Select your department",
                                      style: TextStyle(
                                        fontSize: 15, // Optional: Adjust font size as needed
                                        fontWeight: FontWeight.normal, // Optional: Adjust text weight
                                      ),
                                    ),
                                  ),
                                ),

                                //_fetchProjectFromIsar

                                // Supervisor
                                departmentName != null && departmentName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchSupervisorsFromIsar(departmentName,stateName),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDesignation = snapshot.data!.any((item) => item.value == supervisorName)
                                          ? supervisorName
                                          : null;

                                      // If there's no valid state selected, set the first item as the default
                                      if (selectedDesignation == null) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          setState(() {
                                            //facilityStateName = snapshot.data!.first.value!;
                                            // facilityStateName = "Select your state";
                                          });
                                        });
                                      }

                                      return MyInputField(
                                        title: "Name of Supervisor",
                                        hint: "",
                                        widget: Container(
                                          width: MediaQuery.of(context).size.width*0.81,
                                          //height: MediaQuery.of(context).size.height * 1,// Set your desired width
                                          //color:Colors.red,
                                          child: SizedBox(
                                              child:SizedBox(
                                                  child:
                                                  DropdownButtonFormField<String>(

                                                    decoration: InputDecoration(
                                                      iconColor:Colors.blue,
                                                      labelText: "",
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    value: selectedDesignation,
                                                    icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                                    dropdownColor: Colors.white,
                                                    elevation: 4,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: "NexaBold",
                                                    ),
                                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                                      value: item.value,
                                                      child: Container( // Wrap the Text inside the DropdownMenuItem
                                                        // width: MediaQuery.of(context).size.width * 0.66,
                                                        //color: Colors.pink,// Adjust this width as needed
                                                        child: Text(
                                                          (item.child as Text).data!,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    )).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        supervisorName = value!;
                                                        //facilitydesignationName = value;
                                                        disableddropdown = false;
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  ))),
                                        ),
                                      );

                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                )
                                    :const MyInputField(
                                  title: "Name of Supervisor",
                                  hint: "",
                                  widget: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
                                    child: Text(
                                      "First Select your department",
                                      style: TextStyle(
                                        fontSize: 15, // Optional: Adjust font size as needed
                                        fontWeight: FontWeight.normal, // Optional: Adjust text weight
                                      ),
                                    ),
                                  ),
                                ),

                                // Supervisor Email
                                supervisorName != null && supervisorName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchSupervisorEmailFromIsar(departmentName,supervisorName),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDesignation = snapshot.data!.any((item) => item.value == supervisorEmail)
                                          ? supervisorEmail
                                          : null;

                                      // If there's no valid state selected, set the first item as the default
                                      if (selectedDesignation == null) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          setState(() {
                                            //facilityStateName = snapshot.data!.first.value!;
                                            // facilityStateName = "Select your state";
                                          });
                                        });
                                      }

                                      return MyInputField(
                                        title: "Email of Supervisor",
                                        hint: "",
                                        widget: Container(
                                          width: MediaQuery.of(context).size.width*0.81,
                                          //height: MediaQuery.of(context).size.height * 1,// Set your desired width
                                          //color:Colors.red,
                                          child: SizedBox(
                                              child:SizedBox(
                                                  child:
                                                  DropdownButtonFormField<String>(

                                                    decoration: InputDecoration(
                                                      iconColor:Colors.blue,
                                                      labelText: "",
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    value: selectedDesignation,
                                                    icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                                    dropdownColor: Colors.white,
                                                    elevation: 4,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: "NexaBold",
                                                    ),
                                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                                      value: item.value,
                                                      child: Container( // Wrap the Text inside the DropdownMenuItem
                                                        // width: MediaQuery.of(context).size.width * 0.66,
                                                        //color: Colors.pink,// Adjust this width as needed
                                                        child: Text(
                                                          (item.child as Text).data!,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    )).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        supervisorEmail = value!;
                                                        //facilitydesignationName = value;
                                                        disableddropdown = false;
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  ))),
                                        ),
                                      );

                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                )
                                    :const MyInputField(
                                  title: "  Email of Supervisor",
                                  hint: "",
                                  widget: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
                                    child: Text(
                                      "First Select your Supervisor",
                                      style: TextStyle(
                                        fontSize: 15, // Optional: Adjust font size as needed
                                        fontWeight: FontWeight.normal, // Optional: Adjust text weight
                                      ),
                                    ),
                                  ),
                                ),




                              ],
                            ),
                          ),
                        ),

                        // Project
                        FutureBuilder<List<DropdownMenuItem<String>>>(
                          future: _fetchProjectFromIsar(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                              // Check if facilityStateName is in the list of dropdown values
                              String? selectedProject = snapshot.data!.any((item) => item.value == project)
                                  ? project
                                  : null;

                              // If there's no valid state selected, set the first item as the default
                              if (selectedProject == null) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  setState(() {
                                    //facilityStateName = snapshot.data!.first.value!;
                                    // facilityStateName = "Select your state";
                                  });
                                });
                              }

                              return MyInputField(
                                title: "Project",
                                hint: "",
                                widget: Container(
                                  width: MediaQuery.of(context).size.width*0.81,
                                  //height: MediaQuery.of(context).size.height * 1,// Set your desired width
                                  //color:Colors.red,
                                  child: SizedBox(
                                      child:SizedBox(
                                          child:
                                          DropdownButtonFormField<String>(

                                            decoration: InputDecoration(
                                              iconColor:Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                            value: selectedProject,
                                            icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: Container( // Wrap the Text inside the DropdownMenuItem
                                                // width: MediaQuery.of(context).size.width * 0.66,
                                                //color: Colors.pink,// Adjust this width as needed
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                projectName = value!;
                                                //staffingCategory = value!;
                                                disableddropdown = false;
                                              });
                                            },
                                            isExpanded: true,
                                          ))),
                                ),
                              );

                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),

                        //Project


                        //Roles
                        MyInputField(
                          title: "Role",
                          hint: "${value4}",
                          widget: Row(
                            children: <Widget>[
                              SizedBox(
                                height: 100,
                                child: DropdownButton<String>(
                                  //value: value,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                  ),
                                  iconSize: 32,
                                  elevation: 4,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: "NexaBold"),
                                  underline: Container(
                                    height: 0,
                                  ),
                                  items: Roles.map(buildMenuItem).toList(),
                                  onChanged: (value4) =>
                                      setState(() => this.value4 = value4!),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Password**",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration:
                              ThemeHelper().inputBoxDecorationShaddow(),
                              child: TextFormField(
                                controller: _passwordControl,
                                obscureText: _isObscure3,
                                decoration: ThemeHelper().textInputDecoration(
                                  "",
                                  "Enter your Password**",
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isObscure3 = !_isObscure3;
                                      });
                                    },
                                    icon: Icon(
                                      _isObscure3
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  //
                                ),
                                validator: (value) =>
                                value != null && value.isEmpty
                                    ? 'Enter Password'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        FormField<bool>(
                          builder: (state) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: checkboxValue,
                                        onChanged: (value) {
                                          setState(() {
                                            checkboxValue = value!;
                                            state.didChange(value);
                                          });
                                        }),
                                    Text(
                                      "I accept all terms and conditions.",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.errorText ?? '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      //color: Color.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                          validator: (value) {
                            if (!checkboxValue) {
                              return 'You need to accept terms and conditions';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 20.0),

                        Container(
                          decoration:
                          ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding:
                              const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Register".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final email = _emailAddressControl.text;
                                final password = _passwordControl.text;
                                // Retrieve images
                                List<Uint8List> images =
                                    await adapter.getImages() ?? [];

                                HiveService hiveService = HiveService();

                                try {
                                  String firstName = _firstNameControl.text;
                                  String lastName = _lastNameControl.text;
                                  String emailAddress =
                                      _emailAddressControl.text;
                                  String mobile = _mobileNumberControl.text;
                                  String staffCategory = value5;
                                  String state = stateName;
                                  String location = locationName;
                                  String department = departmentName;
                                  String designatn = designation;
                                  String project = projectName;
                                  String role = value4 == ""?"User":value4;
                                  String password = _passwordControl.text;
                                  String supervsorName = supervisorName;
                                  String supervsorEmail = supervisorEmail;

                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return ProgressDialog(
                                          message: "Please wait...",
                                        );
                                      });
                                  //Create a user email and password in Firebase Authentication
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                      email: email, password: password);

                                  //Check to see if there is a collection created and input the records
                                  final User? user =
                                      FirebaseAuth.instance.currentUser;
                                  final isVeriffied = user?.emailVerified;
                                  final CollectionReference<
                                      Map<String, dynamic>> usersRef =
                                  FirebaseFirestore.instance
                                      .collection('Staff');
                                  usersRef.doc(user?.uid).set({
                                    'id': user?.uid,
                                    'firstName': firstName,
                                    'lastName': lastName,
                                    'photoUrl': user?.photoURL,
                                    'emailAddress': emailAddress,
                                    'password': password,
                                    'mobile': mobile,
                                    'staffCategory': staffCategory,
                                    'state': state,
                                    'location': location,
                                    'department': department,
                                    'designation': designatn,
                                    'project': project,
                                    'role': role,
                                    'isVerified': isVeriffied,
                                    'supervisor':supervsorName,
                                    'supervisorEmail':supervsorEmail,
                                    'version':appVersionConstant,
                                    'isRemoteDelete':false,
                                    'isRemoteUpdate':false,
                                    'lastUpdateDate':DateTime.now(),
                                  }).then((value) async {

                                    try{}catch(e){}
                                    // Replace "your-bucket-name" with your actual Google Cloud Storage bucket name
                                    //String bucketName = "AttendanceApp";
                                    String bucketName = "attendanceapp-a6853.appspot.com";

                                    // Specify the path where you want to store the image in the bucket
                                    //String storagePath = "profile_pics/${DateTime.now().millisecondsSinceEpoch}.jpg";
                                    String storagePath =
                                        "profile_pics/${firstName.toLowerCase()}_${lastName.toLowerCase()}_${user?.uid}_profilepic.jpg";

                                    await firebase_storage
                                        .FirebaseStorage.instance
                                        .ref('$bucketName/$storagePath')
                                        .putData(images.first)
                                        .then((value) async {
                                      String downloadURL =
                                      await firebase_storage
                                          .FirebaseStorage.instance
                                          .ref('$bucketName/$storagePath')
                                          .getDownloadURL();
                                      //Save Profile Pic link to firebase
                                      await FirebaseFirestore.instance
                                          .collection("Staff")
                                          .doc(user?.uid)
                                          .update({
                                        "photoUrl": downloadURL,
                                      });
                                    });
                                  });
                                  // Clear images in Hive box
                                  await hiveService.clearImages();

                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage(
                                              service: IsarService())),
                                          (Route<dynamic> route) => false);

                                  Fluttertoast.showToast(
                                    msg: "Registration Completed",
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor: Colors.black54,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                } on EmailAlreadyInUseAuthException {
                                  await showErrorDialog(
                                      context, "Email Already in Use");
                                  Fluttertoast.showToast(
                                    msg: "Email Already in Use",
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor: Colors.black54,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                } on WeakPasswordAuthException {
                                  await showErrorDialog(
                                      context, "Weak Password");
                                  Fluttertoast.showToast(
                                    msg: "Weak Password",
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor: Colors.black54,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                } on InvalidEmailAuthException {
                                  await showErrorDialog(
                                      context, "Invalid Email");
                                  Fluttertoast.showToast(
                                    msg: "Invalid Email",
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor: Colors.black54,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                } on GenericAuthException {
                                  await showErrorDialog(
                                      context, "Authentication Error");
                                  Fluttertoast.showToast(
                                    msg: "Authentication Error",
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor: Colors.black54,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                } catch (e) {
                                  await showErrorDialog(context, e.toString());
                                  Fluttertoast.showToast(
                                    msg: "${e.toString()}",
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor: Colors.black54,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  //),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
  //     value: item,
  //     child: Text(
  //       item,
  //       style: TextStyle(fontSize: 13, fontFamily: "NexaLight"),
  //     ));
}

Widget textField(
    ThemeHelper label, ThemeHelper hint, TextEditingController controller) {
  return Container(
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label.toString(),
        hintText: hint.toString(),
      ),
    ),
  );
}
