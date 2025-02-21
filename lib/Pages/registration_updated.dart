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

class RegistrationPageUpdated extends StatefulWidget {
  const RegistrationPageUpdated({super.key});

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
  late TextEditingController _supervisorNameControl;
  late TextEditingController _supervisorEmailControl;
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
  String staffGender = "";
  String staffMaritalStatus = "";
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
  var _formKey ;
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

  final List<String> roles = ["User", "Facility Supervisor", "State Office Staff", "HQ Staff"];


  String termsAndConditionsText = """
  1. **Purpose:** This Attendance App is designed to track and monitor staff attendance.  By using this app, you agree to abide by the following terms and conditions.
  2. **Accuracy:** You are responsible for ensuring the accuracy of your attendance records. Report any discrepancies to your supervisor immediately.
  3. **Privacy:**  Attendance data collected through this app will be used solely for monitoring attendance and will be treated confidentially.  
  4. **Misuse:**  Do not use the app for fraudulent purposes or to misrepresent your attendance. Any such misuse may result in disciplinary action.
  5. **Updates:** The app may be updated periodically. You agree to install any updates to ensure proper functionality.
  6. **Random Check-ins:** You agree to participate in random location check-ins during work hours. These check-ins are solely for monitoring purposes and to verify your presence at your designated work location.
  7. **Support:** For technical support or questions about the app, please contact the technical teams in your individual state.
""";

  void _showTermsAndConditionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Terms and Conditions"),
          content: SingleChildScrollView( // Make content scrollable
            child: Text(
              termsAndConditionsText,  // Replace with your actual terms and conditions
              style: const TextStyle(fontSize: 14),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Disagree"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Agree"),
              onPressed: () {
                setState(() {
                  checkboxValue = true; // Tick the checkbox
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _firstNameControl = TextEditingController();
    _lastNameControl = TextEditingController();
    _emailAddressControl = TextEditingController();
    _mobileNumberControl = TextEditingController();
    _passwordControl = TextEditingController();
    _stateControl = TextEditingController();
    _facilityControl = TextEditingController();
    _departmentControl = TextEditingController();
    _designationControl = TextEditingController();
    _supervisorEmailControl = TextEditingController();
    _supervisorNameControl = TextEditingController();
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
    _supervisorEmailControl.dispose();
    _supervisorNameControl.dispose();
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
    List<String> departmentFilterList = ['Care and Treatment','Laboratory','Pharmacy and Logistics','Preventions','Strategic Information','Orphan and Vulnerable Children (OVC)'];

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

  Future<List<DropdownMenuItem<String>>> _fetchGenderFromIsar() async {
    // Query Isar database for designations based on the selected department
    List<String?> gender = await IsarService().getGenderFromIsar();

    // Convert the designations list to DropdownMenuItem list
    return gender.map((gender) => DropdownMenuItem<String>(
      value: gender,
      child: Text(gender!),
    )).toList();
  }

  Future<List<DropdownMenuItem<String>>> _fetchMaritalStatusFromIsar() async {
    // Query Isar database for designations based on the selected department
    List<String?> maritalStatus = await IsarService().getMaritalStatusFromIsar();

    // Convert the designations list to DropdownMenuItem list
    return maritalStatus.map((maritalStatus) => DropdownMenuItem<String>(
      value: maritalStatus,
      child: Text(maritalStatus!),
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
      style: const TextStyle(fontSize: 13, fontFamily: "NexaLight"),
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
        title: const Text(
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
            const SizedBox(
              height: 150,
              child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                            const Text(
                              "First Name",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
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
                                    icon: const Icon(
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
                            const Text(
                              "Last Name",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
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
                                    icon: const Icon(
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
                            const Text(
                              "Email Address",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
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
                                    icon: const Icon(
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
                                      (val.isEmpty)) {
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
                            const Text(
                              "Mobile Number",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
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
                                    icon: const Icon(
                                      Icons.phone_android,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (val) {
                                  if ((!(val!.isEmpty) &&
                                      !RegExp(r"^(\d+)*$").hasMatch(val)) ||
                                      (val.isEmpty)) {
                                    return "Enter a valid phone number";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),

                        //Gender
                        FutureBuilder<List<DropdownMenuItem<String>>>(
                          future: _fetchGenderFromIsar(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                              // Check if facilityStateName is in the list of dropdown values
                              String? selectedGender;

                              // If there's no valid state selected, set the first item as the default
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  //facilityStateName = snapshot.data!.first.value!;
                                  // facilityStateName = "Select your state";
                                });
                              });
                            
                              return MyInputField(
                                title: "Gender",
                                hint: "",
                                widget: SizedBox(
                                  width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      iconColor: Colors.blue,
                                      labelText: "",
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),

                                    icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                    dropdownColor: Colors.white,
                                    elevation: 4,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: "NexaBold",
                                    ),
                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                      value: item.value,
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                        child: Text(
                                          (item.child as Text).data!,
                                          softWrap: true,
                                        ),
                                      ),
                                    )).toList(),
                                    isExpanded: true, // Allow dropdown to expand and use available width
                                    value: selectedGender,
                                    onChanged: (value) {
                                      setState(() {
                                        staffGender = value!;
                                        disableddropdown = false;
                                      });
                                    },

                                  ),
                                ),
                              );



                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),

                        //Marital Status
                        //Gender
                        FutureBuilder<List<DropdownMenuItem<String>>>(
                          future: _fetchMaritalStatusFromIsar(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                              // Check if facilityStateName is in the list of dropdown values
                              String? selectedMaritalStatus;

                              // If there's no valid state selected, set the first item as the default
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  //facilityStateName = snapshot.data!.first.value!;
                                  // facilityStateName = "Select your state";
                                });
                              });
                            
                              return MyInputField(
                                title: "Marital Status",
                                hint: "",
                                widget: SizedBox(
                                  width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      iconColor: Colors.blue,
                                      labelText: "",
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),

                                    icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                    dropdownColor: Colors.white,
                                    elevation: 4,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: "NexaBold",
                                    ),
                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                      value: item.value,
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                        child: Text(
                                          (item.child as Text).data!,
                                          softWrap: true,
                                        ),
                                      ),
                                    )).toList(),
                                    isExpanded: true, // Allow dropdown to expand and use available width
                                    value: selectedMaritalStatus,
                                    onChanged: (value) {
                                      setState(() {
                                        staffMaritalStatus = value!;
                                        disableddropdown = false;
                                      });
                                    },

                                  ),
                                ),
                              );



                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),

                        //Staff Category
                        FutureBuilder<List<DropdownMenuItem<String>>>(
                          future: _fetchStaffCategoryFromIsar(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                              // Check if facilityStateName is in the list of dropdown values
                              String? selectedStaffCategory;

                              // If there's no valid state selected, set the first item as the default
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  //facilityStateName = snapshot.data!.first.value!;
                                  // facilityStateName = "Select your state";
                                });
                              });
                            
                              return MyInputField(
                                title: "Staff Category",
                                hint: "",
                                widget: SizedBox(
                                  width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      iconColor: Colors.blue,
                                      labelText: "",
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),

                                    icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                    dropdownColor: Colors.white,
                                    elevation: 4,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: "NexaBold",
                                    ),
                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                      value: item.value,
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                        child: Text(
                                          (item.child as Text).data!,
                                          softWrap: true,
                                        ),
                                      ),
                                    )).toList(),
                                    isExpanded: true, // Allow dropdown to expand and use available width
                                    value: selectedStaffCategory,
                                    onChanged: (value) {
                                      setState(() {
                                        value5 = value!;
                                        disableddropdown = false;
                                      });
                                    },

                                  ),
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
                                      String? selectedState;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                           // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return  MyInputField(
                                        title: "State Of Implementations",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedState,
                                            onChanged: (value) {
                                              setState(() {
                                                stateName = value!;
                                                facilityStateName = value;
                                                disableddropdown = false;
                                              });
                                            },

                                          ),
                                        ),
                                      );

                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                                // Facility List
                                stateName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchLocationsFromIsar(stateName,"Facility"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedLocation;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                          // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return MyInputField(
                                        title: "Location",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedLocation,
                                            onChanged: (value) {
                                              setState(() {
                                                locationName = value!;
                                                //selectedLocation = value;
                                              });
                                            },

                                          ),
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
                                    padding: EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
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
                                      String? selectedDepartment;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                          // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return MyInputField(
                                        title: "Department",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedDepartment,
                                            onChanged: (value) {
                                              setState(() {
                                                departmentName = value!;
                                                facilitydepartmentName = value;
                                                disableddropdown = false;
                                              });
                                            },

                                          ),
                                        ),
                                      );


                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                                // Designations
                                facilitydepartmentName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchDesignationsFromIsar(departmentName,"Facility Staff"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDesignation;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                          // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return MyInputField(
                                        title: "Designation",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedDesignation,
                                            onChanged: (value) {
                                              setState(() {
                                                designation = value!;
                                                facilitydesignationName = value;
                                                disableddropdown = false;
                                              });
                                            },

                                          ),
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
                                    padding: EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
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
                                facilitydepartmentName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchSupervisorsFromIsar(departmentName,stateName),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDesignation;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                          // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return MyInputField(
                                        title: "Name of Supervisor",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedDesignation,
                                            onChanged: (value) {
                                              setState(() {
                                                supervisorName = value!;
                                                //facilitydesignationName = value;
                                                disableddropdown = false;
                                              });
                                            },

                                          ),
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
                                    padding: EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
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
                                supervisorName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchSupervisorEmailFromIsar(departmentName,supervisorName),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDesignation;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                          // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return  MyInputField(
                                        title: "Email of Supervisor",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedDesignation,
                                            onChanged: (value) {
                                              setState(() {
                                                supervisorEmail = value!;
                                                //facilitydesignationName = value;
                                                disableddropdown = false;
                                              });
                                            },
                                          ),
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
                                    padding: EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
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
                                : value5 == "Facility Supervisor"
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
                                      String? selectedState;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                          // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return  MyInputField(
                                        title: "State Of Implementations",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedState,
                                            onChanged: (value) {
                                              setState(() {
                                                stateName = value!;
                                                facilityStateName = value;
                                                disableddropdown = false;
                                              });
                                            },

                                          ),
                                        ),
                                      );

                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                                // Facility List
                                stateName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchLocationsFromIsar(stateName,"Facility"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedLocation;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                          // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return MyInputField(
                                        title: "Location",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedLocation,
                                            onChanged: (value) {
                                              setState(() {
                                                locationName = value!;
                                                //selectedLocation = value;
                                              });
                                            },

                                          ),
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
                                    padding: EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
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
                                      String? selectedDepartment;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                          // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return MyInputField(
                                        title: "Department",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedDepartment,
                                            onChanged: (value) {
                                              setState(() {
                                                departmentName = value!;
                                                facilitydepartmentName = value;
                                                disableddropdown = false;
                                              });
                                            },

                                          ),
                                        ),
                                      );


                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                                // Designations
                                facilitydepartmentName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchDesignationsFromIsar(departmentName,"Facility Supervisor"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDesignation;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                          // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return MyInputField(
                                        title: "Designation",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedDesignation,
                                            onChanged: (value) {
                                              setState(() {
                                                designation = value!;
                                                facilitydesignationName = value;
                                                disableddropdown = false;
                                              });
                                            },

                                          ),
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
                                    padding: EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
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

                                // // Supervisor
                                // facilitydepartmentName != null && facilitydepartmentName.isNotEmpty
                                //     ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                //   future: _fetchSupervisorsFromIsar(departmentName,stateName),
                                //   builder: (context, snapshot) {
                                //     if (snapshot.hasError) {
                                //       return Text('Error: ${snapshot.error}');
                                //     } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                //       // Check if facilityStateName is in the list of dropdown values
                                //       String? selectedDesignation =
                                //       // snapshot.data!.any((item) => item.value == supervisorName)
                                //       //     ? supervisorName
                                //       //     :
                                //       null;
                                //
                                //       // If there's no valid state selected, set the first item as the default
                                //       if (selectedDesignation == null) {
                                //         WidgetsBinding.instance.addPostFrameCallback((_) {
                                //           setState(() {
                                //             //facilityStateName = snapshot.data!.first.value!;
                                //             // facilityStateName = "Select your state";
                                //           });
                                //         });
                                //       }
                                //
                                //       return MyInputField(
                                //         title: "Name of Supervisor",
                                //         hint: "",
                                //         widget: Container(
                                //           width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                //           child: DropdownButtonFormField<String>(
                                //             decoration: InputDecoration(
                                //               iconColor: Colors.blue,
                                //               labelText: "",
                                //               filled: true,
                                //               fillColor: Colors.white,
                                //               contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                //               border: OutlineInputBorder(
                                //                 borderRadius: BorderRadius.circular(8),
                                //                 borderSide: BorderSide.none,
                                //               ),
                                //             ),
                                //
                                //             icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                //             dropdownColor: Colors.white,
                                //             elevation: 4,
                                //             style: TextStyle(
                                //               color: Colors.black,
                                //               fontSize: 16,
                                //               fontFamily: "NexaBold",
                                //             ),
                                //             items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                //               value: item.value,
                                //               child: SizedBox(
                                //                 width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                //                 child: Text(
                                //                   (item.child as Text).data!,
                                //                   softWrap: true,
                                //                 ),
                                //               ),
                                //             )).toList(),
                                //             isExpanded: true, // Allow dropdown to expand and use available width
                                //             value: selectedDesignation,
                                //             onChanged: (value) {
                                //               setState(() {
                                //                 supervisorName = value!;
                                //                 //facilitydesignationName = value;
                                //                 disableddropdown = false;
                                //               });
                                //             },
                                //
                                //           ),
                                //         ),
                                //       );
                                //
                                //
                                //     } else {
                                //       return const CircularProgressIndicator();
                                //     }
                                //   },
                                // )
                                //     :const MyInputField(
                                //   title: "Name of Supervisor",
                                //   hint: "",
                                //   widget: Padding(
                                //     padding: const EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
                                //     child: Text(
                                //       "First Select your department",
                                //       style: TextStyle(
                                //         fontSize: 15, // Optional: Adjust font size as needed
                                //         fontWeight: FontWeight.normal, // Optional: Adjust text weight
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                SizedBox(
                                    height: MediaQuery.of(context).size.height * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.015),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Name of Supervisor",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                      child: TextFormField(
                                        controller: _supervisorNameControl,
                                        decoration: ThemeHelper().textInputDecoration(
                                          "",
                                          "Enter your Supervisor's Name",
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.person,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                        keyboardType: TextInputType.text,
                                        validator: (value) =>
                                        value != null && value.isEmpty
                                            ? "Enter Supervisor's Name"
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.015),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Email of Supervisor",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                      child: TextFormField(
                                        controller: _supervisorEmailControl,
                                        decoration: ThemeHelper().textInputDecoration(
                                          "",
                                          "Enter your Supervisor's Email",
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.person,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                        keyboardType: TextInputType.text,
                                        validator: (value) =>
                                        value != null && value.isEmpty
                                            ? "Enter Supervisor's Email"
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),

                                // Supervisor Email
                                // supervisorName != null && supervisorName.isNotEmpty
                                //     ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                //   future: _fetchSupervisorEmailFromIsar(departmentName,supervisorName),
                                //   builder: (context, snapshot) {
                                //     if (snapshot.hasError) {
                                //       return Text('Error: ${snapshot.error}');
                                //     } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                //       // Check if facilityStateName is in the list of dropdown values
                                //       String? selectedDesignation =
                                //       // snapshot.data!.any((item) => item.value == supervisorEmail)
                                //       //     ? supervisorEmail
                                //       //     :
                                //       null;
                                //
                                //       // If there's no valid state selected, set the first item as the default
                                //       if (selectedDesignation == null) {
                                //         WidgetsBinding.instance.addPostFrameCallback((_) {
                                //           setState(() {
                                //             //facilityStateName = snapshot.data!.first.value!;
                                //             // facilityStateName = "Select your state";
                                //           });
                                //         });
                                //       }
                                //
                                //       return  MyInputField(
                                //         title: "Email of Supervisor",
                                //         hint: "",
                                //         widget: Container(
                                //           width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                //           child: DropdownButtonFormField<String>(
                                //             decoration: InputDecoration(
                                //               iconColor: Colors.blue,
                                //               labelText: "",
                                //               filled: true,
                                //               fillColor: Colors.white,
                                //               contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                //               border: OutlineInputBorder(
                                //                 borderRadius: BorderRadius.circular(8),
                                //                 borderSide: BorderSide.none,
                                //               ),
                                //             ),
                                //
                                //             icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                //             dropdownColor: Colors.white,
                                //             elevation: 4,
                                //             style: TextStyle(
                                //               color: Colors.black,
                                //               fontSize: 16,
                                //               fontFamily: "NexaBold",
                                //             ),
                                //             items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                //               value: item.value,
                                //               child: SizedBox(
                                //                 width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                //                 child: Text(
                                //                   (item.child as Text).data!,
                                //                   softWrap: true,
                                //                 ),
                                //               ),
                                //             )).toList(),
                                //             isExpanded: true, // Allow dropdown to expand and use available width
                                //             value: selectedDesignation,
                                //             onChanged: (value) {
                                //               setState(() {
                                //                 supervisorEmail = value!;
                                //                 //facilitydesignationName = value;
                                //                 disableddropdown = false;
                                //               });
                                //             },
                                //           ),
                                //         ),
                                //       );
                                //
                                //
                                //     } else {
                                //       return const CircularProgressIndicator();
                                //     }
                                //   },
                                // )
                                //     :const MyInputField(
                                //   title: "  Email of Supervisor",
                                //   hint: "",
                                //   widget: Padding(
                                //     padding: const EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
                                //     child: Text(
                                //       "First Select your Supervisor",
                                //       style: TextStyle(
                                //         fontSize: 15, // Optional: Adjust font size as needed
                                //         fontWeight: FontWeight.normal, // Optional: Adjust text weight
                                //       ),
                                //     ),
                                //   ),
                                // ),



                              ],
                            )
// ---------------------------------------------------------------------------
                            // State of Cordination
                                :
                            value5 == "State Office Staff" ?
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
                                      String? selectedState;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                          // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return  MyInputField(
                                        title: "State",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedState,
                                            onChanged: (value) {
                                              setState(() {
                                                stateName = value!;
                                                facilityStateName = value;
                                                disableddropdown = false;
                                              });
                                            },

                                          ),
                                        ),
                                      );

                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                                // Facility List
                                stateName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchLocationsFromIsar(stateName,"State Office"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedLocation;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                          // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return MyInputField(
                                        title: "Office",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedLocation,
                                            onChanged: (value) {
                                              setState(() {
                                                locationName = value!;
                                                //selectedLocation = value;
                                              });
                                            },

                                          ),
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
                                    padding: EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
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
                                      String? selectedDepartment;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                          // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return MyInputField(
                                        title: "Department",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedDepartment,
                                            onChanged: (value) {
                                              setState(() {
                                                departmentName = value!;
                                                facilitydepartmentName = value;
                                                disableddropdown = false;
                                              });
                                            },

                                          ),
                                        ),
                                      );


                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                                // Designations
                                departmentName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchDesignationsFromIsar(departmentName,"Office Staff"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDesignation;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                          // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return MyInputField(
                                        title: "Designation",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedDesignation,
                                            onChanged: (value) {
                                              setState(() {
                                                designation = value!;
                                                facilitydesignationName = value;
                                                disableddropdown = false;
                                              });
                                            },

                                          ),
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
                                    padding: EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
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
                                departmentName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchSupervisorsFromIsar(departmentName,stateName),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDesignation;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                          // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return MyInputField(
                                        title: "Name of Supervisor",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedDesignation,
                                            onChanged: (value) {
                                              setState(() {
                                                supervisorName = value!;
                                                //facilitydesignationName = value;
                                                disableddropdown = false;
                                              });
                                            },

                                          ),
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
                                    padding: EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
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
                                supervisorName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchSupervisorEmailFromIsar(departmentName,supervisorName),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDesignation;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                          // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return  MyInputField(
                                        title: "Email of Supervisor",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedDesignation,
                                            onChanged: (value) {
                                              setState(() {
                                                supervisorEmail = value!;
                                                //facilitydesignationName = value;
                                                disableddropdown = false;
                                              });
                                            },

                                          ),
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
                                    padding: EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
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
                                      String? selectedState;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                          // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return  MyInputField(
                                        title: "HQ State",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedState,
                                            onChanged: (value) {
                                              setState(() {
                                                stateName = value!;
                                                facilityStateName = value;
                                                disableddropdown = false;
                                              });
                                            },

                                          ),
                                        ),
                                      );

                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                                // Facility List
                                stateName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchLocationsFromIsar(stateName,"HQ"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedLocation;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                          // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return MyInputField(
                                        title: "Office",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedLocation,
                                            onChanged: (value) {
                                              setState(() {
                                                locationName = value!;
                                                selectedLocation = value;
                                              });
                                            },

                                          ),
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
                                    padding: EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
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
                                      String? selectedDepartment;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                          // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return MyInputField(
                                        title: "Department",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedDepartment,
                                            onChanged: (value) {
                                              setState(() {
                                                departmentName = value!;
                                                facilitydepartmentName = value;
                                                disableddropdown = false;
                                              });
                                            },

                                          ),
                                        ),
                                      );


                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                                // Designations
                                departmentName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchDesignationsFromIsar(departmentName,"Office Staff"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDesignation;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                          // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return MyInputField(
                                        title: "Designation",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedDesignation,
                                            onChanged: (value) {
                                              setState(() {
                                                designation = value!;
                                                facilitydesignationName = value;
                                                disableddropdown = false;
                                              });
                                            },

                                          ),
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
                                    padding: EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
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
                                departmentName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchSupervisorsFromIsar(departmentName,stateName),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDesignation;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                          // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return MyInputField(
                                        title: "Name of Supervisor",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedDesignation,
                                            onChanged: (value) {
                                              setState(() {
                                                supervisorName = value!;
                                                //facilitydesignationName = value;
                                                disableddropdown = false;
                                              });
                                            },

                                          ),
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
                                    padding: EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
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
                                supervisorName.isNotEmpty
                                    ?FutureBuilder<List<DropdownMenuItem<String>>>(
                                  future: _fetchSupervisorEmailFromIsar(departmentName,supervisorName),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                      // Check if facilityStateName is in the list of dropdown values
                                      String? selectedDesignation;

                                      // If there's no valid state selected, set the first item as the default
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          //facilityStateName = snapshot.data!.first.value!;
                                          // facilityStateName = "Select your state";
                                        });
                                      });
                                    
                                      return MyInputField(
                                        title: "Email of Supervisor",
                                        hint: "",
                                        widget: SizedBox(
                                          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              iconColor: Colors.blue,
                                              labelText: "",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),

                                            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                            dropdownColor: Colors.white,
                                            elevation: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "NexaBold",
                                            ),
                                            items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                              value: item.value,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                                child: Text(
                                                  (item.child as Text).data!,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )).toList(),
                                            isExpanded: true, // Allow dropdown to expand and use available width
                                            value: selectedDesignation,
                                            onChanged: (value) {
                                              setState(() {
                                                supervisorEmail = value!;
                                                //facilitydesignationName = value;
                                                disableddropdown = false;
                                              });
                                            },

                                          ),
                                        ),
                                      );


                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                )
                                    :const MyInputField(
                                  title: "Email of Supervisor",
                                  hint: "",
                                  widget: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.0),// Adjust padding as needed
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
                              String? selectedProject;

                              // If there's no valid state selected, set the first item as the default
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  //facilityStateName = snapshot.data!.first.value!;
                                  // facilityStateName = "Select your state";
                                });
                              });
                            
                              return MyInputField(
                                title: "Project",
                                hint: "",
                                widget: SizedBox(
                                  width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      iconColor: Colors.blue,
                                      labelText: "",
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),

                                    icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                    dropdownColor: Colors.white,
                                    elevation: 4,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: "NexaBold",
                                    ),
                                    items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                      value: item.value,
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                        child: Text(
                                          (item.child as Text).data!,
                                          softWrap: true,
                                        ),
                                      ),
                                    )).toList(),
                                    isExpanded: true, // Allow dropdown to expand and use available width
                                    value: selectedProject,
                                    onChanged: (value) {
                                      setState(() {
                                        projectName = value!;
                                        //staffingCategory = value!;
                                        disableddropdown = false;
                                      });
                                    },

                                  ),
                                ),
                              );


                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),

                        //Roles
                        MyInputField(
                          title: "Role",
                          hint: "",
                          widget: SizedBox(
                            width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.9), // Make container occupy 90% of screen width
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                iconColor: Colors.blue,
                                labelText: "",
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                              dropdownColor: Colors.white,
                              elevation: 4,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "NexaBold",
                              ),
                              items: roles.map((role) => DropdownMenuItem<String>(
                                value: role,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.8 : 0.8), // Control dropdown item width based on screen size
                                  child: Text(
                                    role,
                                    softWrap: true,
                                  ),
                                ),
                              )).toList(),
                              isExpanded: true, // Allow dropdown to expand and use available width
                              value: roles.first, // Set the first role as the default selected value
                                onChanged: (value4) =>
                                    setState(() => this.value4 = value4!),
                            ),
                          ),
                        ),


                        //Roles
                        // MyInputField(
                        //   title: "Role",
                        //   hint: "${value4}",
                        //   widget: Row(
                        //     children: <Widget>[
                        //       SizedBox(
                        //         height: 100,
                        //         child: DropdownButton<String>(
                        //           //value: value,
                        //           icon: Icon(
                        //             Icons.keyboard_arrow_down,
                        //             color: Colors.grey,
                        //           ),
                        //           iconSize: 32,
                        //           elevation: 4,
                        //           style: TextStyle(
                        //               color: Colors.black,
                        //               fontSize: 15,
                        //               fontFamily: "NexaBold"),
                        //           underline: Container(
                        //             height: 0,
                        //           ),
                        //           items: Roles.map(buildMenuItem).toList(),
                        //           onChanged: (value4) =>
                        //               setState(() => this.value4 = value4!),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(height: 20.0),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Password**",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
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
                                InkWell( // Make the whole row tappable
                                  onTap: _showTermsAndConditionsDialog,
                                  child: Row(
                                    children: <Widget>[
                                      Checkbox(
                                        value: checkboxValue,
                                        onChanged: (value) {
                                          // Instead of directly changing checkboxValue here,
                                          // the _showTermsAndConditionsDialog will handle it.
                                          _showTermsAndConditionsDialog(); // Show dialog on tap
                                        },
                                      ),
                                      const Text(
                                        "I accept all terms and conditions.",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.errorText ?? '',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
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
                        const SizedBox(height: 20.0),

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
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              // if (_formKey.currentState!.validate())
                              // {
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
                                  String supervsorName = value5 == "Facility Supervisor"?_supervisorNameControl.text:supervisorName;
                                  String supervsorEmail = value5 == "Facility Supervisor"?_supervisorEmailControl.text:supervisorEmail;
                                  String gender = staffGender;
                                  String maritalStatus = staffMaritalStatus;

                                  if(firstName == "" ||lastName == "" ||emailAddress == "" ||mobile == "" ||staffCategory == "" ||state == "" ||location == "" ||department == "" ||designatn == "" ||project == "" ||role == "" ||password == "" ||supervsorName == "" ||supervsorEmail == ""){
                                    Fluttertoast.showToast(
                                      msg: "Kindly fill all missing fields",
                                      toastLength: Toast.LENGTH_SHORT,
                                      backgroundColor: Colors.black54,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );

                                  }else{
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
                                      'gender':gender,
                                      'maritalStatus': maritalStatus,
                                    }).then((value) async {

                                      try{}catch(e){}
                                      // Replace "your-bucket-name" with your actual Google Cloud Storage bucket name
                                      //String bucketName = "AttendanceApp";
                                      String bucketName = "attendanceapp-a6853.appspot.com";

                                      // Specify the path where you want to store the image in the bucket
                                      //String storagePath = "profile_pics/${DateTime.now().millisecondsSinceEpoch}.jpg";
                                      String storagePath =
                                          "profile_pics/${firstName.toLowerCase()}_${lastName.toLowerCase()}_${user?.uid}_profilepic.jpg";



                                      if (images.isNotEmpty) {
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

                                      } else{
                                        // Handle the case where no image is selected (e.g., skip image upload)
                                        print("No image selected. Skipping image upload.");
                                        Fluttertoast.showToast(
                                          msg: "No image selected. Skipping image upload.",
                                          toastLength: Toast.LENGTH_SHORT,
                                          backgroundColor: Colors.black54,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      }

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
                                  }


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
                                    msg: e.toString(),
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor: Colors.black54,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                             // }
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
