// import 'dart:io';
// import 'package:attendanceapp/model/user_model.dart';
// import 'package:attendanceapp/pages/auth_exceptions.dart';
// import 'package:attendanceapp/pages/login_page.dart';
// import 'package:attendanceapp/services/database_adapter.dart';
// import 'package:attendanceapp/services/hive_service.dart';
// import 'package:attendanceapp/services/isar_service.dart';
// import 'package:attendanceapp/widgets/drawer.dart';
// import 'package:attendanceapp/widgets/drawer2.dart';
// import 'package:attendanceapp/widgets/header_widget.dart';
// import 'package:attendanceapp/widgets/input_field.dart';
// import 'package:attendanceapp/widgets/locations.dart';
// import 'package:attendanceapp/widgets/progress_dialog.dart';
// import 'package:attendanceapp/widgets/show_error_dialog.dart';
// import 'package:attendanceapp/widgets/theme_helper.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/services.dart';
// import 'package:refreshable_widget/refreshable_widget.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class Registration extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _RegistrationState();
//   }
// }
//
// class _RegistrationState extends State<Registration> {
//   var role;
//   late TextEditingController _firstNameControl;
//   late TextEditingController _lastNameControl;
//   late TextEditingController _emailAddressControl;
//   late TextEditingController _mobileNumberControl;
//   late TextEditingController _passwordControl;
//
//   String stateName = "";
//   String staffStateName = "";
//   String facilityStateName = "";
//   String locationName = "";
//   String staffLocationName = "";
//   String facilityLocationName = "";
//   String departmentName = "";
//   String staffdepartmentName = "";
//   String facilitydepartmentName = "";
//   String designation = "";
//   String staffdesignationName = "";
//   String facilitydesignationName = "";
//   String projectName = "";
//   bool? isVeriffied;
//   DatabaseAdapter adapter = HiveService();
//   // Assuming 'Roles' is a list of strings representing roles
//   List<String> Roles = ["User"];
//
//   List<DropdownMenuItem<String>> menuitems = [];
//   List<DropdownMenuItem<String>> menuitems2 = [];
//   bool disableddropdown = true;
//   bool disableddropdown2 = true;
//   bool disableddropdown3 = true;
//   bool disableddropdown4 = true;
//   String value = "";
//   String value2 = "";
//   String value3 = "";
//   String value4 = "";
//   String value5 = "";
//   final _formKey = GlobalKey<FormState>();
//   final _formKey1 = GlobalKey<FormState>();
//   bool checkedValue = false;
//   bool checkboxValue = false;
//   bool _isObscure3 = true;
//
//   double screenHeight = 0;
//   double screenWidth = 0;
//   late SharedPreferences sharedPreferences;
//   var firstName;
//   var lastName;
//   var firebaseAuthId;
//   var staffCategory;
//   var state;
//   var emailAddress;
//   var location;
//   var department;
//   var mobile;
//   var project;
//
//   @override
//   void initState() {
//     _firstNameControl = TextEditingController();
//     _lastNameControl = TextEditingController();
//     _emailAddressControl = TextEditingController();
//     _mobileNumberControl = TextEditingController();
//     _passwordControl = TextEditingController();
//     _getUserDetail();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _firstNameControl.dispose();
//     _lastNameControl.dispose();
//     _emailAddressControl.dispose();
//     _mobileNumberControl.dispose();
//     _passwordControl.dispose();
//     super.dispose();
//   }
//
//   Future<List<Uint8List>?> _readImagesFromDatabase() async {
//     return adapter.getImages();
//   }
//
//   void _getUserDetail() async {
//     final userDetail = await IsarService().getBioInfoWithFirebaseAuth();
//     setState(() {
//       firebaseAuthId = userDetail?.firebaseAuthId;
//       state = userDetail?.state;
//       project = userDetail?.project;
//       firstName = userDetail?.firstName;
//       lastName = userDetail?.lastName;
//       // designation = userDetail?.designation;
//       department = userDetail?.department;
//       location = userDetail?.location;
//       staffCategory = userDetail?.staffCategory;
//       mobile = userDetail?.mobile;
//       emailAddress = userDetail?.emailAddress;
//       role = userDetail?.role;
//     });
//   }
//
//   Future<void> _pickImage() async {
//     try {
//       ImagePicker imagePicker = ImagePicker();
//       XFile? image = await imagePicker.pickImage(
//         source: ImageSource.gallery,
//         maxHeight: 512,
//         maxWidth: 512,
//         imageQuality: 90,
//       );
//       if (image == null) return;
//
//       Uint8List imageBytes = await image.readAsBytes();
//       adapter.storeImage(imageBytes);
//     } catch (e) {
//       Fluttertoast.showToast(
//           msg: "Error:${e.toString()}",
//           toastLength: Toast.LENGTH_LONG,
//           backgroundColor: Colors.black54,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           textColor: Colors.white,
//           fontSize: 16.0);
//     }
//   }
//
//   void pickUpLoadProfilePic() async {
//     //Function for Picking and Uploading Profile Picture
//     final image = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//       maxHeight: 512,
//       maxWidth: 512,
//       imageQuality: 90,
//     );
//
//     Reference ref = FirebaseStorage.instance.ref().child(
//         "${firstName.toLowerCase()}_${lastName.toLowerCase()}_profilepic.jpg");
//
//     await ref.putFile(File(image!.path));
//
//     ref.getDownloadURL().then((value) async {
//       setState(() {
//         //Save Profile pic URL in User class
//         UserModel.profilePicLink = value;
//       });
//       //Save Profile Pic link to firebase
//       await FirebaseFirestore.instance
//           .collection("Staff")
//           .doc(firebaseAuthId)
//           .update({
//         "photoUrl": value,
//       });
//     });
//   }
//
//   // Future<List<DropdownMenuItem<String>>> _fetchStatesFromIsar() async {
//   //   // Query Isar database for states
//   //   List<String?> states = await IsarService().getStatesFromIsar();
//   //
//   //   // Convert the states list to DropdownMenuItem list
//   //   return states.map((state) => DropdownMenuItem<String>(
//   //     value: state,
//   //     child: Text(state!),
//   //   )).toList();
//   // }
//
//   Future<List<DropdownMenuItem<String>>> _fetchStatesFromIsar() async {
//     List<String?> states = await IsarService().getStatesFromIsar();
//     // Remove duplicates:
//     Set<String?> uniqueStates = Set.from(states);
//     // Convert to DropdownMenuItem list:
//     return uniqueStates.map((state) => DropdownMenuItem<String>(
//       value: state,
//       child: Text(state!),
//     )).toList();
//   }
//
//   Future<List<DropdownMenuItem<String>>> _fetchLocationsFromIsar(String state) async {
//     // Query Isar database for locations based on the selected state
//     List<String?> locations = await IsarService().getLocationsFromIsar(state);
//
//     // Convert the locations list to DropdownMenuItem list
//     return locations.map((location) => DropdownMenuItem<String>(
//       value: location,
//       child: Text(location!),
//     )).toList();
//   }
//
//   Future<List<DropdownMenuItem<String>>> _fetchDepartmentsFromIsar() async {
//     // Query Isar database for departments based on the selected location
//     List<String?> departments = await IsarService().getDepartmentsFromIsar();
//
//     // Convert the departments list to DropdownMenuItem list
//     return departments.map((department) => DropdownMenuItem<String>(
//       value: department,
//       child: Text(department!),
//     )).toList();
//   }
//
//   Future<List<DropdownMenuItem<String>>> _fetchDesignationsFromIsar(String department,String category) async {
//     // Query Isar database for designations based on the selected department
//     List<String?> designations = await IsarService().getDesignationsFromIsar(department,category);
//
//     // Convert the designations list to DropdownMenuItem list
//     return designations.map((designation) => DropdownMenuItem<String>(
//       value: designation,
//       child: Text(designation!),
//     )).toList();
//   }
//
//   // Helper function to build a DropdownMenuItem
//   DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
//     value: item,
//     child: Text(
//       item,
//       style: TextStyle(fontSize: 13, fontFamily: "NexaLight"),
//     ),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Registration Page",
//           style: TextStyle(color: Colors.red, fontFamily: "NexaBold"),
//         ),
//         elevation: 0.5,
//         iconTheme: const IconThemeData(color: Colors.red),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: <Color>[
//                     Colors.white,
//                     Colors.white,
//                   ])),
//         ),
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(top: 15, right: 15, bottom: 15),
//             child: Stack(
//               children: <Widget>[
//                 Image.asset("./assets/image/ccfn_logo.png"),
//               ],
//             ),
//           )
//         ],
//       ),
//       drawer: role == "User"
//           ? drawer(this.context, IsarService())
//           : drawer2(this.context, IsarService()),
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//           child: Stack(
//             children: [
//             Container(
//             height: 150,
//             child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
//           ),
//           Container(
//               margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
//               padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//               alignment: Alignment.center,
//               child: Column(
//                 children: [
//                 Form(
//                 key: _formKey1,
//                 child: Column(
//                     children: [
//                     // Profile Picture
//                     GestureDetector(
//                     onTap: () {
//               _pickImage();
//               },
//                 child: Container(
//                   margin: const EdgeInsets.only(top: 20, bottom: 24),
//                   height: 120,
//                   width: 120,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: Colors.red,
//                   ),
//                   child: RefreshableWidget<List<Uint8List>?>(
//                     refreshCall: () async {
//                       return await _readImagesFromDatabase();
//                     },
//                     refreshRate: const Duration(seconds: 1),
//                     errorWidget: Icon(
//                       Icons.person,
//                       size: 80,
//                       color: Colors.grey.shade300,
//                     ),
//                     loadingWidget: Icon(
//                       Icons.person,
//                       size: 80,
//                       color: Colors.grey.shade300,
//                     ),
//                     builder: ((context, value) {
//                       if (value != null && value.isNotEmpty) {
//                         return Image.memory(value.first);
//                       } else {
//                         return Icon(
//                           Icons.person,
//                           size: 80,
//                           color: Colors.grey.shade300,
//                         );
//                       }
//                     }),
//                   ),
//                 ),
//               ),
//
//               // First Name
//               MyInputField(
//                 title: "First Name",
//                 hint: "Enter your First Name",
//                 controller: _firstNameControl,
//                 keyboardType: TextInputType.text,
//                 validator: (value) =>
//                 value != null && value.isEmpty
//                     ? 'Enter First Name'
//                     : null,
//                 icon: Icons.person,
//               ),
//
//               // Last Name
//               MyInputField(
//                 title: "Last Name",
//                 hint: "Enter your Last Name",
//                 controller: _lastNameControl,
//                 keyboardType: TextInputType.text,
//                 validator: (value) =>
//                 value != null && value.isEmpty
//                     ? 'Enter Last Name'
//                     : null,
//                 icon: Icons.person,
//               ),
//
//               // Email Address
//               MyInputField(
//                 title: "Email Address",
//                 hint: "Enter your email",
//                 controller: _emailAddressControl,
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (val) {
//                   if ((!(val!.isEmpty) &&
//                       !RegExp(
//                           r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
//                           .hasMatch(val)) ||
//                       (val != null && val.isEmpty)) {
//                     return "Enter a valid email address";
//                   }
//                   return null;
//                 },
//                 icon: Icons.email,
//               ),
//
//               // Mobile Number
//               MyInputField(
//                 title: "Mobile Number",
//                 hint: "Enter your Mobile Number",
//                 controller: _mobileNumberControl,
//                 keyboardType: TextInputType.number,
//                 validator: (val) {
//                   if ((!(val!.isEmpty) &&
//                       !RegExp(r"^(\d+)*$").hasMatch(val)) ||
//                       (val != null && val.isEmpty)) {
//                     return "Enter a valid phone number";
//                   }
//                   return null;
//                 },
//                 icon: Icons.phone_android,
//               ),
//
//               // Staff Category
//               MyInputField(
//                 title: "Staff Category",
//                 hint: "${value5}",
//                 widget: DropdownButton<String>(
//                   value: value5,
//                   icon: const Icon(Icons.keyboard_arrow_down),
//                   iconSize: 32,
//                   elevation: 4,
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 15,
//                       fontFamily: "NexaBold"),
//                   underline: Container(
//                     height: 0,
//                   ),
//                   items: StaffCategory.map(buildMenuItem).toList(),
//                   onChanged: (value5) =>
//                       setState(() => this.value5 = value5!),
//                 ),
//               ),
//
//               // Dynamic Dropdowns based on Staff Category
//               if (value5 != "")
//           Column(
//       mainAxisSize:MainAxisSize.max,
//
//       children: [
//       // State of Implementation
//
//         SizedBox(
//           height: 50,
//           width: 200,// Provide a specific height
//           child:  FutureBuilder<List<DropdownMenuItem<String>>>(
//             future: _fetchStatesFromIsar(),
//             builder: (context, snapshot) {
//               if (snapshot.hasError) {
//                 return Text('Error: ${snapshot.error}');
//               } else if (snapshot.hasData) {
//                 // --- Debugging: Print values to check for inconsistencies ---
//                 print("facilityStateName: $facilityStateName");
//                 print("Dropdown Items: ${snapshot.data}");
//
//                 // --- Handle initial value if needed ---
//                 if (facilityStateName == null || facilityStateName.isEmpty) {
//                   setState(() {
//                     facilityStateName = snapshot.data!.first.value!;
//                   });
//                 }
//
//                 return MyInputField(
//                   title: "State Of Implementation",
//                   hint: "${facilityStateName}",
//                   widget: DropdownButtonFormField<String>(
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.zero,
//                     ),
//                     value: facilityStateName, // Make sure this matches a value in snapshot.data
//                     icon: const Icon(Icons.keyboard_arrow_down),
//                     iconSize: 32,
//                     elevation: 4,
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 15,
//                         fontFamily: "NexaBold"
//                     ),
//                     items: snapshot.data,
//                     onChanged: (_value) {
//                       setState(() {
//                         stateName = _value!;
//                         facilityStateName = _value;
//                         disableddropdown = false;
//                       });
//                     },
//                   ),
//                 );
//               } else {
//                 return CircularProgressIndicator();
//               }
//             },
//           ),
//         ),
//
//
//     // Facility
//     FutureBuilder<List<DropdownMenuItem<String>>>(
//     future: _fetchLocationsFromIsar(stateName),
//     builder: (context, snapshot) {
//     if (snapshot.hasError) {
//     return Text('Error: ${snapshot.error}');
//     } else if (snapshot.hasData) {
//     return MyInputField(
//     title: "Facility",
//     hint: "${facilityLocationName}",
//     widget: DropdownButtonFormField<String>(
//     decoration: InputDecoration(
//     border: InputBorder.none,
//     contentPadding: EdgeInsets.zero,
//     ),
//     value: facilityLocationName,
//     icon: const Icon(Icons.keyboard_arrow_down),
//     iconSize: 32,
//     elevation: 4,
//     style: TextStyle(
//     color: Colors.black,
//     fontSize: 15,
//     fontFamily: "NexaBold"),
//     // underline: Container(
//     // height: 0,
//     // ),
//     items: snapshot.data,
//     disabledHint: Text(
//     "First Select your state",
//     style: TextStyle(fontSize: 14),
//     ),
//     onChanged: (_value) {
//     setState(() {
//     locationName = _value!;
//     facilityLocationName = _value;
//     disableddropdown2 = false;
//     });
//     },
//     ),
//     );
//     } else {
//     return CircularProgressIndicator();
//     }
//     },
//     ),
//
//     // Department
//     // FutureBuilder<List<DropdownMenuItem<String>>>(
//     // future: _fetchDepartmentsFromIsar(),
//     // builder: (context, snapshot) {
//     // if (snapshot.hasError) {
//     // return Text('Error: ${snapshot.error}');
//     // } else if (snapshot.hasData) {
//     // return MyInputField(
//     // title: "Department",
//     // hint: "${facilitydepartmentName}",
//     // widget: DropdownButtonFormField<String>(
//     // decoration: InputDecoration(
//     // border: InputBorder.none,
//     // contentPadding: EdgeInsets.zero,
//     // ),
//     // value: facilitydepartmentName,
//     // icon: const Icon(Icons.keyboard_arrow_down),
//     // iconSize: 32,
//     // elevation: 4,
//     // style: TextStyle(
//     // color: Colors.black,
//     // fontSize: 15,
//     // fontFamily: "NexaBold"),
//     // // underline: Container(
//     // // height: 0,
//     // // ),
//     // items: snapshot.data,
//     // disabledHint: Text(
//     // "First Select your Facility",
//     // style: TextStyle(fontSize: 14),
//     // ),
//     // onChanged: (_value2) {
//     // setState(() {
//     // departmentName = _value2!;
//     // facilitydepartmentName = value2;
//     // disableddropdown3 = false;
//     // });
//     // },
//     // ),
//     // );
//     // } else {
//     // return CircularProgressIndicator();
//     // }
//     // },
//     // ),
//     //
//     // // Designation
//     // FutureBuilder<List<DropdownMenuItem<String>>>(
//     // future: _fetchDesignationsFromIsar(departmentName,"Facility Staff"),
//     // builder: (context, snapshot) {
//     // if (snapshot.hasError) {
//     // return Text('Error: ${snapshot.error}');
//     // } else if (snapshot.hasData) {
//     // return MyInputField(
//     // title: "Designation",
//     // hint: "${facilitydesignationName}",
//     // widget: DropdownButtonFormField<String>(
//     // decoration: InputDecoration(
//     // border: InputBorder.none,
//     // contentPadding: EdgeInsets.zero,
//     // ),
//     // value: facilitydesignationName,
//     // icon: const Icon(Icons.keyboard_arrow_down),
//     // iconSize: 32,
//     // elevation: 4,
//     // style: TextStyle(
//     // color: Colors.black,
//     // fontSize: 15,
//     // fontFamily: "NexaBold"),
//     // // underline: Container(
//     // // height: 0,
//     // // ),
//     // items: snapshot.data,
//     // disabledHint: Text(
//     // "First Select your Department",
//     // style: TextStyle(fontSize: 14),
//     // ),
//     // onChanged: (_value2) {
//     // setState(() {
//     // designation = _value2!;
//     // facilitydesignationName = _value2;
//     // });
//     // },
//     // ),
//     // );
//     // } else {
//     // return CircularProgressIndicator();
//     // }
//     // },
//     // ),
//     ],
//     )
//     else if (value5 == "Staff of Coordination")
//     Column(
//     children: [
//     // State of Implementation
//     // FutureBuilder<List<DropdownMenuItem<String>>>(
//     // future: _fetchStatesFromIsar(),
//     // builder: (context, snapshot) {
//     // if (snapshot.hasError) {
//     // return Text('Error: ${snapshot.error}');
//     // } else if (snapshot.hasData) {
//     // return MyInputField(
//     // title: "State Of Implementation",
//     // hint: "${staffStateName}",
//     // widget: DropdownButtonFormField<String>(
//     // decoration: InputDecoration(
//     // border: InputBorder.none,
//     // contentPadding: EdgeInsets.zero,
//     // ),
//     // value: staffStateName,
//     // icon: const Icon(Icons.keyboard_arrow_down),
//     // iconSize: 32,
//     // elevation: 4,
//     // style: TextStyle(
//     // color: Colors.black,
//     // fontSize: 15,
//     // fontFamily: "NexaBold"),
//     // // underline: Container(
//     // // height: 0,
//     // // ),
//     // items: snapshot.data,
//     // onChanged: (_value) {
//     // setState(() {
//     // stateName = _value!;
//     // staffStateName = _value;
//     // disableddropdown = false;
//     // });
//     // },
//     // ),
//     // );
//     // } else {
//     // return CircularProgressIndicator();
//     // }
//     // },
//     // ),
//
//     // Office Location
//     // FutureBuilder<List<DropdownMenuItem<String>>>(
//     // future: _fetchLocationsFromIsar(stateName),
//     // builder: (context, snapshot) {
//     // if (snapshot.hasError) {
//     // return Text('Error: ${snapshot.error}');
//     // } else if (snapshot.hasData) {
//     // return MyInputField(
//     // title: "Office Location",
//     // hint: "${staffLocationName}",
//     // widget: DropdownButtonFormField<String>(
//     // decoration: InputDecoration(
//     // border: InputBorder.none,
//     // contentPadding: EdgeInsets.zero,
//     // ),
//     // value: staffLocationName,
//     // icon: const Icon(Icons.keyboard_arrow_down),
//     // iconSize: 32,
//     // elevation: 4,
//     // style: TextStyle(
//     // color: Colors.black,
//     // fontSize: 15,
//     // fontFamily: "NexaBold"),
//     // // underline: Container(
//     // // height: 0,
//     // // ),
//     // items: snapshot.data,
//     // disabledHint: Text(
//     // "First Select your state",
//     // style: TextStyle(fontSize: 14),
//     // ),
//     // onChanged: (_value) {
//     // setState(() {
//     // locationName = _value!;
//     // staffLocationName = _value;
//     // disableddropdown2 = false;
//     // });
//     // },
//     // ),
//     // );
//     // } else {
//     // return CircularProgressIndicator();
//     // }
//     // },
//     // ),
//     //
//     // // Department
//     // FutureBuilder<List<DropdownMenuItem<String>>>(
//     // future: _fetchDepartmentsFromIsar(),
//     // builder: (context, snapshot) {
//     // if (snapshot.hasError) {
//     // return Text('Error: ${snapshot.error}');
//     // } else if (snapshot.hasData) {
//     // return MyInputField(
//     // title: "Department",
//     // hint: "${staffdepartmentName}",
//     // widget: DropdownButtonFormField<String>(
//     // decoration: InputDecoration(
//     // border: InputBorder.none,
//     // contentPadding: EdgeInsets.zero,
//     // ),
//     // value: staffdepartmentName,
//     // icon: const Icon(Icons.keyboard_arrow_down),
//     // iconSize: 32,
//     // elevation: 4,
//     // style: TextStyle(
//     // color: Colors.black,
//     // fontSize: 15,
//     // fontFamily: "NexaBold"),
//     // // underline: Container(
//     // // height: 0,
//     // // ),
//     // items: snapshot.data,
//     // disabledHint: Text(
//     // "First Select your Location",
//     // style: TextStyle(fontSize: 14),
//     // ),
//     // onChanged: (_value2) {
//     // setState(() {
//     // departmentName = _value2!;
//     // staffdepartmentName = value2;
//     // disableddropdown3 = false;
//     // });
//     // },
//     // ),
//     // );
//     // } else {
//     // return CircularProgressIndicator();
//     // }
//     // },
//     // ),
//     //
//     // // Designation
//     // FutureBuilder<List<DropdownMenuItem<String>>>(
//     // future: _fetchDesignationsFromIsar(departmentName,"Facility Staff"),
//     // builder: (context, snapshot) {
//     // if (snapshot.hasError) {
//     // return Text('Error: ${snapshot.error}');
//     // } else if (snapshot.hasData) {
//     // return MyInputField(
//     // title: "Designation",
//     // hint: "${staffdesignationName}",
//     // widget: DropdownButtonFormField<String>(
//     // decoration: InputDecoration(
//     // border: InputBorder.none,
//     // contentPadding: EdgeInsets.zero,
//     // ),
//     // value: staffdesignationName,
//     // icon: const Icon(Icons.keyboard_arrow_down),
//     // iconSize: 32,
//     // elevation: 4,
//     // style: TextStyle(
//     // color: Colors.black,
//     // fontSize: 15,
//     // fontFamily: "NexaBold"),
//     // // underline: Container(
//     // // height: 0,
//     // // ),
//     // items: snapshot.data,
//     // disabledHint: Text(
//     // "First Select your Department",
//     // style: TextStyle(fontSize: 14),
//     // ),
//     // onChanged: (_value2) {
//     // setState(() {
//     // designation = _value2!;
//     // staffdesignationName = _value2;
//     // });
//     // },
//     // ),
//     // );
//     // } else {
//     // return CircularProgressIndicator();
//     // }
//     // },
//     // ),
//     ],
//     ),
//
//     // // Project
//     // MyInputField(
//     // title: "Project",
//     // hint: "${value3}",
//     // widget: DropdownButton<String>(
//     // value: value3,
//     // icon: const Icon(Icons.keyboard_arrow_down),
//     // iconSize: 32,
//     // elevation: 4,
//     // style: TextStyle(
//     // color: Colors.black,
//     // fontSize: 15,
//     // fontFamily: "NexaBold"),
//     // underline: Container(
//     // height: 0,
//     // ),
//     // items: Projects.map(buildMenuItem).toList(),
//     // onChanged: (value3) => setState(() {
//     // this.value3 = value3!;
//     // }),
//     // ),
//     // ),
//     //
//     // Role
//     // MyInputField(
//     // title: "Role",
//     // hint: "${value4}",
//     // widget: DropdownButton<String>(
//     // value: value4,
//     // icon: const Icon(Icons.keyboard_arrow_down),
//     // iconSize: 32,
//     // elevation: 4,
//     // style: TextStyle(
//     // color: Colors.black,
//     // fontSize: 15,
//     // fontFamily: "NexaBold"),
//     // underline: Container(
//     // height: 0,
//     // ),
//     // items: Roles.map(buildMenuItem).toList(),
//     // onChanged: (value4) =>
//     // setState(() => this.value4 = value4!),
//     // ),
//     // ),
// // Role
// //                       MyInputField(
// //                         title: "Role",
// //                         hint: "${value4}",
// //                         widget: DropdownButton<String>(
// //                           value: value4, // Make sure 'value4' is initialized to a valid role
// //                           icon: const Icon(Icons.keyboard_arrow_down),
// //                           iconSize: 32,
// //                           elevation: 4,
// //                           style: TextStyle(
// //                               color: Colors.black,
// //                               fontSize: 15,
// //                               fontFamily: "NexaBold"),
// //                           underline: Container(
// //                             height: 0,
// //                           ),
// //                           items: Roles.map(buildMenuItem).toList(),
// //                           onChanged: (value4) => setState(() => this.value4 = value4!),
// //                         ),
// //                       ),
//
//
//
//     // Password
//     MyInputField(
//     title: "Password**",
//     hint: "Enter your Password**",
//     controller: _passwordControl,
//     // obscureText: _isObscure3,
//     validator: (value) =>
//     value != null && value.isEmpty
//     ? 'Enter Password'
//         : null,
//     // icon: _isObscure3
//     // ? Icons.visibility
//     //     : Icons.visibility_off,
//     // onPressed: () {
//     // setState(() {
//     // _isObscure3 = !_isObscure3;
//     // });
//     // },
//     ),
//
//     // Terms and Conditions Checkbox
//     FormField<bool>(
//     builder: (state) {
//     return Column(
//     children: <Widget>[
//     Row(
//     children: <Widget>[
//     Checkbox(
//     value: checkboxValue,
//     onChanged: (value) {
//     setState(() {
//     checkboxValue = value!;
//     state.didChange(value);
//     });
//     }),
//     Text(
//     "I accept all terms and conditions.",
//     style: TextStyle(color: Colors.grey),
//     ),
//     ],
//     ),
//     Container(
//     alignment: Alignment.centerLeft,
//     child: Text(
//     state.errorText ?? '',
//     textAlign: TextAlign.left,
//     style: TextStyle(
//     //color: Color.red,
//     fontSize: 12,
//     ),
//     ),
//     )
//     ],
//     );
//     },
//     validator: (value) {
//     if (!checkboxValue) {
//     return 'You need to accept terms and conditions';
//     } else {
//     return null;
//     }
//     },
//     ),
//
//     // Register Button
//     Container(
//     decoration: ThemeHelper().buttonBoxDecoration(context),
//     child: ElevatedButton(
//     style: ThemeHelper().buttonStyle(),
//     child: Padding(
//     padding:
//     const EdgeInsets.fromLTRB(40, 10, 40, 10),
//     child: Text(
//     "Register".toUpperCase(),
//     style: TextStyle(
//     fontSize: 20,
//     fontWeight: FontWeight.bold,
//     color: Colors.white,
//     ),
//     ),
//     ),
//     onPressed: () async {
//    // if (_formKey.currentState!.validate()) {
//     final email = _emailAddressControl.text;
//     final password = _passwordControl.text;
//     // Retrieve images
//     List<Uint8List> images =
//     await adapter.getImages() ?? [];
//
//     HiveService hiveService = HiveService();
//
//     try {
//     String firstName = _firstNameControl.text;
//     String lastName = _lastNameControl.text;
//     String emailAddress =
//     _emailAddressControl.text;
//     String mobile = _mobileNumberControl.text;
//     String staffCategory = value5;
//     String state = stateName;
//     String location = locationName;
//     String department = departmentName;
//     String designatn = designation;
//     String project = value3;
//     String role = value4 == ""?"User":value4;
//     String password = _passwordControl.text;
//
//     showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//     return ProgressDialog(
//     message: "Please wait...",
//     );
//     });
//     //Create a user email and password in Firebase Authentication
//     await FirebaseAuth.instance
//         .createUserWithEmailAndPassword(
//     email: email, password: password);
//
//     //Check to see if there is a collection created and input the records
//     final User? user =
//     FirebaseAuth.instance.currentUser;
//     final isVeriffied = user?.emailVerified;
//     final CollectionReference<
//     Map<String, dynamic>> usersRef =
//     FirebaseFirestore.instance
//         .collection('Staff');
//     usersRef.doc(user?.uid).set({
//     'id': user?.uid,
//     'firstName': firstName,
//     'lastName': lastName,
//     'photoUrl': user?.photoURL,
//     'emailAddress': emailAddress,
//     'password': password,
//     'mobile': mobile,
//     'staffCategory': staffCategory,
//     'state': state,
//     'location': location,
//     'department': department,
//     'designation': designatn,
//     'project': project,
//     'role': role,
//     'isVerified': isVeriffied,
//     }).then((value) async {
//
//     try{}catch(e){}
//     // Replace "your-bucket-name" with your actual Google Cloud Storage bucket name
//     //String bucketName = "AttendanceApp";
//     String bucketName = "attendanceapp-a6853.appspot.com";
//
//     // Specify the path where you want to store the image in the bucket
//     //String storagePath = "profile_pics/${DateTime.now().millisecondsSinceEpoch}.jpg";
//     String storagePath =
//     "profile_pics/${firstName.toLowerCase()}_${lastName.toLowerCase()}_${user?.uid}_profilepic.jpg";
//
//     await FirebaseStorage
//         .instance
//         .ref('$bucketName/$storagePath')
//         .putData(images.first)
//         .then((value) async {
//     String downloadURL =
//     await FirebaseStorage
//         .instance
//         .ref('$bucketName/$storagePath')
//         .getDownloadURL();
//     //Save Profile Pic link to firebase
//     await FirebaseFirestore.instance
//         .collection("Staff")
//         .doc(user?.uid)
//         .update({
//     "photoUrl": downloadURL,
//     });
//     });
//     });
//     // Clear images in Hive box
//     await hiveService.clearImages();
//
//     Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(
//             builder: (context) => LoginPage(
//                 service: IsarService())),
//             (Route<dynamic> route) => false);
//
//     Fluttertoast.showToast(
//       msg: "Registration Completed",
//       toastLength: Toast.LENGTH_LONG,
//       backgroundColor: Colors.black54,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );
//     } on EmailAlreadyInUseAuthException {
//       await showErrorDialog(
//           context, "Email Already in Use");
//       Fluttertoast.showToast(
//         msg: "Email Already in Use",
//         toastLength: Toast.LENGTH_LONG,
//         backgroundColor: Colors.black54,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//     } on WeakPasswordAuthException {
//       await showErrorDialog(
//           context, "Weak Password");
//       Fluttertoast.showToast(
//         msg: "Weak Password",
//         toastLength: Toast.LENGTH_LONG,
//         backgroundColor: Colors.black54,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//     } on InvalidEmailAuthException {
//       await showErrorDialog(
//           context, "Invalid Email");
//       Fluttertoast.showToast(
//         msg: "Invalid Email",
//         toastLength: Toast.LENGTH_LONG,
//         backgroundColor: Colors.black54,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//     } on GenericAuthException {
//       await showErrorDialog(
//           context, "Authentication Error");
//       Fluttertoast.showToast(
//         msg: "Authentication Error",
//         toastLength: Toast.LENGTH_LONG,
//         backgroundColor: Colors.black54,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//     } catch (e) {
//       await showErrorDialog(context, e.toString());
//       Fluttertoast.showToast(
//         msg: "${e.toString()}",
//         toastLength: Toast.LENGTH_LONG,
//         backgroundColor: Colors.black54,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//     }
//     //}
//     },
//     ),
//     ),
//                     ],
//                 ),
//                 ),
//                 ],
//               ),
//           ),
//             ],
//           ),
//       ),
//     );
//   }
//
// // DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
// //     value: item,
// //     child: Text(
// //       item,
// //       style: TextStyle(fontSize: 13, fontFamily: "NexaLight"),
// //     ));
// }
//
// Widget textField(
//     ThemeHelper label, ThemeHelper hint, TextEditingController controller) {
//   return Container(
//     child: TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label.toString(),
//         hintText: hint.toString(),
//       ),
//     ),
//   );
// }