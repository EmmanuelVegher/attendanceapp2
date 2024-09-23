// import 'dart:io';
// import 'package:attendanceapp/model/user_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   double screenHeight = 0;
//   double screenWidth = 0;

//   Color primary = const Color(0xffeef444c);
//   String birth = "Date of birth";

//   TextEditingController firstNameController = TextEditingController();
//   TextEditingController lastNameController = TextEditingController();
//   TextEditingController emailAddressController = TextEditingController();
//   TextEditingController projectNameController = TextEditingController();
//   TextEditingController stateNameController = TextEditingController();

//   void pickUpLoadProfilePic() async {
//     //Function for Picking and Uploading Profile Picture
//     final image = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//       maxHeight: 512,
//       maxWidth: 512,
//       imageQuality: 90,
//     );

//     Reference ref = FirebaseStorage.instance
//         .ref()
//         .child("${UserModel.staffId.toLowerCase()}_profilepic.jpg");

//     await ref.putFile(File(image!.path));

//     ref.getDownloadURL().then((value) async {
//       setState(() {
//         //Save Profile pic URL in User class
//         UserModel.profilePicLink = value;
//       });
//       //Save Profile Pic link to firebase
//       await FirebaseFirestore.instance
//           .collection("Staff")
//           .doc(UserModel.id)
//           .update({
//         "profilePic": value,
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
//         child: Column(
//           children: [
//             // Container for profile Picture
//             GestureDetector(
//               onTap: () {
//                 pickUpLoadProfilePic();
//               },
//               child: Container(
//                 margin: const EdgeInsets.only(
//                   top: 20,
//                   bottom: 24,
//                 ),
//                 height: 120,
//                 width: 120,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: primary,
//                 ),
//                 child: Center(
//                   //If Profile Pic url is available, show picture, else Icon
//                   child: UserModel.profilePicLink == " "
//                       ? const Icon(
//                           Icons.person,
//                           color: Colors.white,
//                           size: 80,
//                         )
//                       : ClipRRect(
//                           borderRadius: BorderRadius.circular(20),
//                           child: Image.network(UserModel
//                               .profilePicLink) //Wrapping with ClipRRect to create border radius
//                           ),
//                 ),
//               ),
//             ),

//             Align(
//               alignment: Alignment.center,
//               child: Column(
//                 children: [
//                   Text(
//                     "Staff ${UserModel.staffId}",
//                     style: const TextStyle(
//                       fontFamily: "NexaBold",
//                       fontSize: 18,
//                     ),
//                   ),
//                   const Padding(
//                     padding: EdgeInsets.only(top: 8.0),
//                     child: Image(
//                       image: AssetImage("assets/image/ccfn_logo.png"),
//                       width: 150,
//                       height: 40,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(
//               height: 24,
//             ),
//             UserModel.canEdit
//                 ? textField("First Name", "First Name", firstNameController)
//                 : field("First Name", UserModel.firstName),
//             UserModel.canEdit
//                 ? textField("Last Name", "Last Name", lastNameController)
//                 : field("Last Name", UserModel.lastName),

//             // User.canEdit ? GestureDetector(
//             //   onTap: (){
//             //     showDatePicker(
//             //       context: context,
//             //       initialDate: DateTime.now(),
//             //       firstDate: DateTime(1950),
//             //       lastDate: DateTime.now(),

//             //         builder: (context, child){
//             //           return Theme(
//             //             data:Theme.of(context).copyWith(
//             //               colorScheme: ColorScheme.light(
//             //                 primary: primary,
//             //                 secondary: primary,
//             //                 onSecondary: Colors.white,
//             //               ),
//             //               textButtonTheme: TextButtonThemeData(
//             //                 style: TextButton.styleFrom(
//             //                   foregroundColor: primary,

//             //                 ),
//             //               ),
//             //               textTheme: const TextTheme(
//             //                 headline4: TextStyle(
//             //                   fontFamily: "NexaBold",
//             //                 ),
//             //                 overline: TextStyle(
//             //                   fontFamily: "NexaBold",
//             //                 ),
//             //                 button: TextStyle(
//             //                   fontFamily: "NexaBold",
//             //                 ),
//             //               ),
//             //             ),
//             //             child: child!,
//             //           );
//             //         }

//             //     ).then((value) {
//             //       setState(() {
//             //         birth = DateFormat("dd/MM/yyyy").format(value!);
//             //       });
//             //     });
//             //   },
//             //   child:field("Date of Birth", birth),
//             // ):field("Date of Birth", UserModel.birthDate),
//             UserModel.canEdit
//                 ? textField(
//                     "Email Address", "Email Address", emailAddressController)
//                 : field("Email Address", UserModel.emailAddress),
//             UserModel.canEdit
//                 ? textField("Project", "Project", projectNameController)
//                 : field("Project", UserModel.project),
//             UserModel.canEdit
//                 ? textField("State", "State", stateNameController)
//                 : field("State", UserModel.state),

//             //Only show save button when user can edit
//             UserModel.canEdit
//                 ? GestureDetector(
//                     onTap: () async {
//                       String firstName = firstNameController.text;
//                       String lastName = lastNameController.text;
//                       String emailAddress = emailAddressController.text;
//                       String project = projectNameController.text;
//                       String state = stateNameController.text;

//                       if (UserModel.canEdit) {
//                         if (firstName.isEmpty) {
//                           showSnackBar("Please enter your first name!");
//                         } else if (lastName.isEmpty) {
//                           showSnackBar("Please enter your last name!");
//                           // } else if (birthDate.isEmpty) {
//                           //   showSnackBar("Please select your Date of Birth!");
//                         } else if (emailAddress.isEmpty) {
//                           showSnackBar("Please enter your email address!");
//                         } else if (project.isEmpty) {
//                           showSnackBar("Please select your project name!");
//                         } else if (state.isEmpty) {
//                           showSnackBar(
//                               "Please select your state of implementation!");
//                         } else {
//                           await FirebaseFirestore.instance
//                               .collection("Staff")
//                               .doc(UserModel.id)
//                               .update({
//                             "firstName": firstName,
//                             "lastName": lastName,
//                             "emailAddress": emailAddress,
//                             "project": project,
//                             "state": state,
//                             "canEdit": false,
//                           }).then((value) {
//                             setState(() {
//                               UserModel.canEdit = false;
//                               UserModel.firstName = firstName;
//                               UserModel.lastName = firstName;
//                               UserModel.emailAddress = emailAddress;
//                               UserModel.project = project;
//                               UserModel.state = state;
//                             });
//                           });
//                         }
//                       } else {
//                         //If User already saved once. to edit again they will need to contact the support team
//                         showSnackBar(
//                             "You can't edit anymore, please contact support team.");
//                       }
//                     },
//                     child: Container(
//                       height: kToolbarHeight,
//                       width: screenWidth,
//                       margin: const EdgeInsets.only(bottom: 12),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(4),
//                         color: primary,
//                       ),
//                       child: const Center(
//                         child: Text(
//                           "SAVE",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontFamily: "NexaBold",
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 : const SizedBox(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget field(String title, String text) {
//     return Column(
//       children: [
//         Align(
//           alignment: Alignment.centerLeft,
//           child: Text(
//             title,
//             style: const TextStyle(
//               fontFamily: "NexaBold",
//               color: Colors.black87,
//             ),
//           ),
//         ),
//         Container(
//           height: kToolbarHeight,
//           width: screenWidth,
//           margin: const EdgeInsets.only(bottom: 12),
//           padding: const EdgeInsets.only(left: 11),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(4),
//             border: Border.all(
//               color: Colors.black54,
//             ),
//           ),
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               text,
//               style: const TextStyle(
//                 color: Colors.black54,
//                 fontFamily: "NexaBold",
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget textField(
//       String title, String hint, TextEditingController controller) {
//     return Column(
//       children: [
//         Align(
//           alignment: Alignment.centerLeft,
//           child: Text(
//             title,
//             style: const TextStyle(
//               fontFamily: "NexaBold",
//               color: Colors.black87,
//             ),
//           ),
//         ),
//         Container(
//           margin: EdgeInsets.only(bottom: 12),
//           child: TextFormField(
//             controller: controller,
//             cursorColor: Colors.black54,
//             maxLines: 1,
//             decoration: InputDecoration(
//               hintText: hint,
//               hintStyle: const TextStyle(
//                 color: Colors.black54,
//                 fontFamily: "NexaBold",
//               ),
//               enabledBorder: const OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Colors.black54,
//                 ),
//               ),
//               focusedBorder: const OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Colors.black54,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void showSnackBar(String text) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         content: Text(
//           text,
//         ),
//       ),
//     );
//   }
// }
