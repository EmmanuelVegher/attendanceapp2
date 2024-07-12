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

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
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
  String staffdepartmentName = "";
  String facilitydepartmentName = "";
  String designation = "";
  String staffdesignationName = "";
  String facilitydesignationName = "";
  String projectName = "";
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

  void _getUserDetail() async {
    final userDetail = await IsarService().getBioInfoWithFirebaseAuth();
    setState(() {
      firebaseAuthId = userDetail?.firebaseAuthId;
      state = userDetail?.state;
      project = userDetail?.project;
      firstName = userDetail?.firstName;
      lastName = userDetail?.lastName;
      // designation = userDetail?.designation;
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

// Populate State List for facility staffs
  void populateAbia() {
    for (String key in Abia.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Abia[key],
          child: Center(
            child: Text(
              Abia[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateEnugu() {
    for (String key in Enugu.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Enugu[key],
          child: Center(
            child: Text(
              Enugu[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateImo() {
    for (String key in Imo.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Imo[key],
          child: Center(
            child: Text(
              Imo[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateAdamawa() {
    for (String key in Adamawa.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Adamawa[key],
          child: Center(
            child: Text(
              Adamawa[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateAkwaIbom() {
    for (String key in AkwaIbom.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: AkwaIbom[key],
          child: Center(
            child: Text(
              AkwaIbom[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateAnambra() {
    for (String key in Anambra.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Anambra[key],
          child: Center(
            child: Text(
              Anambra[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateBauchi() {
    for (String key in Bauchi.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Bauchi[key],
          child: Center(
            child: Text(
              Bauchi[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateBayelsa() {
    for (String key in Bayelsa.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Bayelsa[key],
          child: Center(
            child: Text(
              Bayelsa[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateBenue() {
    for (String key in Benue.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Benue[key],
          child: Center(
            child: Text(
              Benue[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateBorno() {
    for (String key in Borno.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Borno[key],
          child: Center(
            child: Text(
              Borno[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateCrossRiver() {
    for (String key in CrossRiver.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: CrossRiver[key],
          child: Center(
            child: Text(
              CrossRiver[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateDelta() {
    for (String key in Delta.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Delta[key],
          child: Center(
            child: Text(
              Delta[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateEbonyi() {
    for (String key in Ebonyi.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Ebonyi[key],
          child: Center(
            child: Text(
              Ebonyi[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateEdo() {
    for (String key in Edo.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Edo[key],
          child: Center(
            child: Text(
              Edo[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateEkiti() {
    for (String key in Ekiti.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Ekiti[key],
          child: Center(
            child: Text(
              Ekiti[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateFCT() {
    for (String key in FCT.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: FCT[key],
          child: Center(
            child: Text(
              FCT[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateGombe() {
    for (String key in Gombe.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Gombe[key],
          child: Center(
            child: Text(
              Gombe[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateJigawa() {
    for (String key in Jigawa.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Jigawa[key],
          child: Center(
            child: Text(
              Jigawa[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateKaduna() {
    for (String key in Kaduna.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Kaduna[key],
          child: Center(
            child: Text(
              Kaduna[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateKano() {
    for (String key in Kano.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Kano[key],
          child: Center(
            child: Text(
              Kano[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateKatsina() {
    for (String key in Katsina.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Katsina[key],
          child: Center(
            child: Text(
              Katsina[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateKebbi() {
    for (String key in Kebbi.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Kebbi[key],
          child: Center(
            child: Text(
              Kebbi[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateKogi() {
    for (String key in Kogi.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Kogi[key],
          child: Center(
            child: Text(
              Kogi[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateKwara() {
    for (String key in Kwara.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Kwara[key],
          child: Center(
            child: Text(
              Kwara[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateLagos() {
    for (String key in Lagos.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Lagos[key],
          child: Center(
            child: Text(
              Lagos[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateNasarawa() {
    for (String key in Nasarawa.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Nasarawa[key],
          child: Center(
            child: Text(
              Nasarawa[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateNiger() {
    for (String key in Niger.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Niger[key],
          child: Center(
            child: Text(
              Niger[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateOgun() {
    for (String key in Ogun.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Ogun[key],
          child: Center(
            child: Text(
              Ogun[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateOndo() {
    for (String key in Ondo.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Ondo[key],
          child: Center(
            child: Text(
              Ondo[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateOsun() {
    for (String key in Osun.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Osun[key],
          child: Center(
            child: Text(
              Osun[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateOyo() {
    for (String key in Oyo.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Oyo[key],
          child: Center(
            child: Text(
              Oyo[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateRivers() {
    for (String key in Rivers.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Rivers[key],
          child: Center(
            child: Text(
              Rivers[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populatePlateau() {
    for (String key in Plateau.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Plateau[key],
          child: Center(
            child: Text(
              Plateau[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateSokoto() {
    for (String key in Sokoto.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Sokoto[key],
          child: Center(
            child: Text(
              Sokoto[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateTaraba() {
    for (String key in Taraba.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Taraba[key],
          child: Center(
            child: Text(
              Taraba[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateYobe() {
    for (String key in Yobe.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Yobe[key],
          child: Center(
            child: Text(
              Yobe[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateZamfara() {
    for (String key in Zamfara.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Zamfara[key],
          child: Center(
            child: Text(
              Zamfara[key]!,
            ),
          ),
        ),
      );
    }
  }

// Populate State List for facility staffs
  void populateAbiaState() {
    for (String key in Abia_State.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Abia_State[key],
          child: Center(
            child: Text(
              Abia_State[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateEnuguState() {
    for (String key in Enugu_State.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Enugu_State[key],
          child: Center(
            child: Text(
              Enugu_State[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateImoState() {
    for (String key in Imo_State.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Imo_State[key],
          child: Center(
            child: Text(
              Imo_State[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateAbuja() {
    for (String key in Abuja.keys) {
      menuitems.add(
        DropdownMenuItem<String>(
          value: Abuja[key],
          child: Center(
            child: Text(
              Abuja[key]!,
            ),
          ),
        ),
      );
    }
  }

  // Populate the different department
  void populateState_Management() {
    for (String key in State_Management.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: State_Management[key],
          child: Center(
            child: Text(
              State_Management[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateCareAndTreatment() {
    for (String key in CareAndTreatment.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: CareAndTreatment[key],
          child: Center(
            child: Text(
              CareAndTreatment[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populatePreventionServices() {
    for (String key in Prevention.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Prevention[key],
          child: Center(
            child: Text(
              Prevention[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateOrphansAndVulnerableChildren() {
    for (String key in OVC.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: OVC[key],
          child: Center(
            child: Text(
              OVC[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateGender_And_Protection() {
    for (String key in Gender_And_Protection.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Gender_And_Protection[key],
          child: Center(
            child: Text(
              Gender_And_Protection[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateLaboratoryServices() {
    for (String key in Laboratory.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Laboratory[key],
          child: Center(
            child: Text(
              Laboratory[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populatePharmacyAndSupplyChainManagement() {
    for (String key in Pharmacy.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Pharmacy[key],
          child: Center(
            child: Text(
              Pharmacy[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateStrategic_Information() {
    for (String key in Strategic_Information.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Strategic_Information[key],
          child: Center(
            child: Text(
              Strategic_Information[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateComplianceManagement() {
    for (String key in Compliance.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Compliance[key],
          child: Center(
            child: Text(
              Compliance[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateInternal_Audit() {
    for (String key in Internal_Audit.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Internal_Audit[key],
          child: Center(
            child: Text(
              Internal_Audit[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateProgram_Management() {
    for (String key in Program_Management.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Program_Management[key],
          child: Center(
            child: Text(
              Program_Management[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateSustainability() {
    for (String key in Sustainability.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Sustainability[key],
          child: Center(
            child: Text(
              Sustainability[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateHealth_Systems_Strengthening() {
    for (String key in Health_Systems_Strengthening.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Health_Systems_Strengthening[key],
          child: Center(
            child: Text(
              Health_Systems_Strengthening[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateProgram_Accountability() {
    for (String key in Program_Accountability.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Program_Accountability[key],
          child: Center(
            child: Text(
              Program_Accountability[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populatePrograms() {
    for (String key in Programs.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Programs[key],
          child: Center(
            child: Text(
              Programs[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateCommunications() {
    for (String key in Communications.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Communications[key],
          child: Center(
            child: Text(
              Communications[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateKnowledge_Management() {
    for (String key in Knowledge_Management.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Knowledge_Management[key],
          child: Center(
            child: Text(
              Knowledge_Management[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateFinance() {
    for (String key in Finance.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Finance[key],
          child: Center(
            child: Text(
              Finance[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateHuman_Resource() {
    for (String key in Human_Resource.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Human_Resource[key],
          child: Center(
            child: Text(
              Human_Resource[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateAdministration() {
    for (String key in Administration.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Administration[key],
          child: Center(
            child: Text(
              Administration[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateProcurement() {
    for (String key in Procurement.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Procurement[key],
          child: Center(
            child: Text(
              Procurement[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateTransport_Management() {
    for (String key in Transport_Management.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Transport_Management[key],
          child: Center(
            child: Text(
              Transport_Management[key]!,
            ),
          ),
        ),
      );
    }
  }

//Adhoc Departmens
  void populateCT() {
    for (String key in Care_and_Treatment.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Care_and_Treatment[key],
          child: Center(
            child: Text(
              Care_and_Treatment[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populatePreventions() {
    for (String key in Preventions.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Preventions[key],
          child: Center(
            child: Text(
              Preventions[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateLab() {
    for (String key in Lab.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: Lab[key],
          child: Center(
            child: Text(
              Lab[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populatePharmLogistics() {
    for (String key in PharmLogistics.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: PharmLogistics[key],
          child: Center(
            child: Text(
              PharmLogistics[key]!,
            ),
          ),
        ),
      );
    }
  }

  void populateSI() {
    for (String key in SI.keys) {
      menuitems2.add(
        DropdownMenuItem<String>(
          value: SI[key],
          child: Center(
            child: Text(
              SI[key]!,
            ),
          ),
        ),
      );
    }
  }

// States
  void valueChanged(_value) {
    if (_value == "Abia") {
      menuitems = [];
      populateAbia();
    } else if (_value == "Enugu") {
      menuitems = [];
      populateEnugu();
    } else if (_value == "Imo") {
      menuitems = [];
      populateImo();
    } else if (_value == "Adamawa") {
      menuitems = [];
      populateAdamawa();
    } else if (_value == "AkwaIbom") {
      menuitems = [];
      populateAkwaIbom();
    } else if (_value == "Anambra") {
      menuitems = [];
      populateAnambra();
    } else if (_value == "Bauchi") {
      menuitems = [];
      populateBauchi();
    } else if (_value == "Bayelsa") {
      menuitems = [];
      populateBayelsa();
    } else if (_value == "Benue") {
      menuitems = [];
      populateBenue();
    } else if (_value == "Borno") {
      menuitems = [];
      populateBorno();
    } else if (_value == "CrossRiver") {
      menuitems = [];
      populateCrossRiver();
    } else if (_value == "Delta") {
      menuitems = [];
      populateDelta();
    } else if (_value == "Ebonyi") {
      menuitems = [];
      populateEbonyi();
    } else if (_value == "Edo") {
      menuitems = [];
      populateEdo();
    } else if (_value == "Ekiti") {
      menuitems = [];
      populateEkiti();
    } else if (_value == "FCT") {
      menuitems = [];
      populateFCT();
    } else if (_value == "Gombe") {
      menuitems = [];
      populateGombe();
    } else if (_value == "Jigawa") {
      menuitems = [];
      populateJigawa();
    } else if (_value == "Kaduna") {
      menuitems = [];
      populateKaduna();
    } else if (_value == "Kano") {
      menuitems = [];
      populateKano();
    } else if (_value == "Katsina") {
      menuitems = [];
      populateKatsina();
    } else if (_value == "Kebbi") {
      menuitems = [];
      populateKebbi();
    } else if (_value == "Kogi") {
      menuitems = [];
      populateKogi();
    } else if (_value == "Kwara") {
      menuitems = [];
      populateKwara();
    } else if (_value == "Lagos") {
      menuitems = [];
      populateLagos();
    } else if (_value == "Nasarawa") {
      menuitems = [];
      populateNasarawa();
    } else if (_value == "Niger") {
      menuitems = [];
      populateNiger();
    } else if (_value == "Ogun") {
      menuitems = [];
      populateOgun();
    } else if (_value == "Ondo") {
      menuitems = [];
      populateOndo();
    } else if (_value == "Osun") {
      menuitems = [];
      populateOsun();
    } else if (_value == "Oyo") {
      menuitems = [];
      populateOyo();
    } else if (_value == "Plateau") {
      menuitems = [];
      populatePlateau();
    } else if (_value == "Rivers") {
      menuitems = [];
      populateRivers();
    } else if (_value == "Sokoto") {
      menuitems = [];
      populateSokoto();
    } else if (_value == "Taraba") {
      menuitems = [];
      populateTaraba();
    } else if (_value == "Yobe") {
      menuitems = [];
      populateYobe();
    } else if (_value == "Zamfara") {
      menuitems = [];
      populateZamfara();
    } else if (_value == "Abia_State") {
      menuitems = [];
      populateAbiaState();
    } else if (_value == "Imo_State") {
      menuitems = [];
      populateImoState();
    } else if (_value == "Enugu_State") {
      menuitems = [];
      populateEnuguState();
    } else if (_value == "Abuja") {
      menuitems = [];
      populateAbuja();
    }
    setState(() {
      value = _value;
      disableddropdown = false;
    });
  }

  void secondValueChanged(_value) {
    setState(() {
      value = _value;
    });
  }

  // Departments

  void valueChanged2(_value2) {
    if (_value2 == "Administration") {
      menuitems2 = [];
      populateAdministration();
    } else if (_value2 == "CareAndTreatment") {
      menuitems2 = [];
      populateCareAndTreatment();
    } else if (_value2 == "Communications") {
      menuitems2 = [];
      populateCommunications();
    } else if (_value2 == "Compliance") {
      menuitems2 = [];
      populateComplianceManagement();
    } else if (_value2 == "Finance") {
      menuitems2 = [];
      populateFinance();
    } else if (_value2 == "Sustainability") {
      menuitems2 = [];
      populateSustainability();
    } else if (_value2 == "Gender_And_Protection") {
      menuitems2 = [];
      populateGender_And_Protection();
    } else if (_value2 == "Health_Systems_Strengthening") {
      menuitems2 = [];
      populateHealth_Systems_Strengthening();
    } else if (_value2 == "Human_Resource") {
      menuitems2 = [];
      populateHuman_Resource();
    } else if (_value2 == "Internal_Audit") {
      menuitems2 = [];
      populateInternal_Audit();
    } else if (_value2 == "Knowledge_Management") {
      menuitems2 = [];
      populateKnowledge_Management();
    } else if (_value2 == "Laboratory") {
      menuitems2 = [];
      populateLaboratoryServices();
    } else if (_value2 == "OVC") {
      menuitems2 = [];
      populateOrphansAndVulnerableChildren();
    } else if (_value2 == "Pharmacy") {
      menuitems2 = [];
      populatePharmacyAndSupplyChainManagement();
    } else if (_value2 == "Prevention") {
      menuitems2 = [];
      populatePreventionServices();
    } else if (_value2 == "Procurement") {
      menuitems2 = [];
      populateProcurement();
    } else if (_value2 == "Programs") {
      menuitems2 = [];
      populatePrograms();
    } else if (_value2 == "Program_Accountability") {
      menuitems2 = [];
      populateProgram_Accountability();
    } else if (_value2 == "Program_Management") {
      menuitems2 = [];
      populateProgram_Management();
    } else if (_value2 == "State_Management") {
      menuitems2 = [];
      populateState_Management();
    } else if (_value2 == "Strategic_Information") {
      menuitems2 = [];
      populateStrategic_Information();
    } else if (_value2 == "Transport_Management") {
      menuitems2 = [];
      populateTransport_Management();
    } else if (_value2 == "Care_and_Treatment") {
      menuitems2 = [];
      populateCT();
    } else if (_value2 == "Preventions") {
      menuitems2 = [];
      populatePreventions();
    } else if (_value2 == "Lab") {
      menuitems2 = [];
      populateLab();
    } else if (_value2 == "PharmLogistics") {
      menuitems2 = [];
      populatePharmLogistics();
    } else if (_value2 == "SI") {
      menuitems2 = [];
      populateSI();
    }

    setState(() {
      value2 = _value2;
      disableddropdown2 = false;
    });
  }

  void secondValueChanged2(_value2) {
    setState(() {
      value2 = _value2;
    });
  }

  // void _getUserDetail() async {
  //   final userDetail = await IsarService().getBioInfoWithFirebaseAuth();
  //   setState(() {
  //     role = userDetail?.role;
  //   });
  // }

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
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // GestureDetector(
                        //   onTap: () {
                        //     //pickUpLoadProfilePic();

                        //     _pickImage();
                        //   },
                        //   child: Stack(
                        //     children: [
                        //       Container(
                        //         padding: EdgeInsets.all(10),
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(100),
                        //           border:
                        //               Border.all(width: 5, color: Colors.white),
                        //           color: Colors.white,
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color: Colors.black12,
                        //               blurRadius: 20,
                        //               offset: const Offset(5, 5),
                        //             ),
                        //           ],
                        //         ),
                        //         child: Icon(
                        //           Icons.person,
                        //           color: Colors.grey.shade300,
                        //           size: 80.0,
                        //         ),
                        //       ),
                        //       Container(
                        //         padding: EdgeInsets.fromLTRB(80, 80, 0, 0),
                        //         child: Icon(
                        //           Icons.add_circle,
                        //           color: Colors.grey.shade700,
                        //           size: 25.0,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

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

                        //Staff Category
                        MyInputField(
                          title: "Staff Category",
                          hint: "${value5}",
                          widget: Row(
                            children: <Widget>[
                              SizedBox(
                                height: 100,
                                child: DropdownButton<String>(
                                  //value: value,
                                  icon: const Icon(
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
                                  items:
                                      StaffCategory.map(buildMenuItem).toList(),
                                  onChanged: (value5) =>
                                      setState(() => this.value5 = value5!),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Container that displays State of Implementation,Location,Department and designation based on staff category selection
                        Container(
                          child: value5 == ""
                              ? Container()
                              :
                              //State List
                              Container(
                                  child: value5 == "Facility Staff"
                                      ? Column(
                                          children: [
                                            MyInputField(
                                              title: "State Of Implementation",
                                              hint: "${facilityStateName}",
                                              widget: DropdownButton(
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.grey,
                                                ),
                                                iconSize: 32,
                                                elevation: 4,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            22,
                                                    fontFamily: "NexaBold"),
                                                underline: Container(
                                                  height: 0,
                                                ),
                                                items: [
                                                  DropdownMenuItem<String>(
                                                    value: "Abia",
                                                    child: Center(
                                                      child: Text("Abia"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Adamawa",
                                                    child: Center(
                                                      child: Text("Adamawa"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "AkwaIbom",
                                                    child: Center(
                                                      child: Text("AkwaIbom"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Anambra",
                                                    child: Center(
                                                      child: Text("Anambra"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Bauchi",
                                                    child: Center(
                                                      child: Text("Bauchi"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Bayelsa",
                                                    child: Center(
                                                      child: Text("Bayelsa"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Benue",
                                                    child: Center(
                                                      child: Text("Benue"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Borno",
                                                    child: Center(
                                                      child: Text("Borno"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "CrossRiver",
                                                    child: Center(
                                                      child: Text("CrossRiver"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Delta",
                                                    child: Center(
                                                      child: Text("Delta"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Ebonyi",
                                                    child: Center(
                                                      child: Text("Ebonyi"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Edo",
                                                    child: Center(
                                                      child: Text("Edo"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Ekiti",
                                                    child: Center(
                                                      child: Text("Ekiti"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Enugu",
                                                    child: Center(
                                                      child: Text("Enugu"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "FCT",
                                                    child: Center(
                                                      child: Text("FCT"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Gombe",
                                                    child: Center(
                                                      child: Text("Gombe"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Imo",
                                                    child: Center(
                                                      child: Text("Imo"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Jigawa",
                                                    child: Center(
                                                      child: Text("Jigawa"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Kaduna",
                                                    child: Center(
                                                      child: Text("Kaduna"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Kano",
                                                    child: Center(
                                                      child: Text("Kano"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Katsina",
                                                    child: Center(
                                                      child: Text("Katsina"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Kebbi",
                                                    child: Center(
                                                      child: Text("Kebbi"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Kogi",
                                                    child: Center(
                                                      child: Text("Kogi"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Kwara",
                                                    child: Center(
                                                      child: Text("Kwara"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Lagos",
                                                    child: Center(
                                                      child: Text("Lagos"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Nasarawa",
                                                    child: Center(
                                                      child: Text("Nasarawa"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Niger",
                                                    child: Center(
                                                      child: Text("Niger"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Ogun",
                                                    child: Center(
                                                      child: Text("Ogun"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Ondo",
                                                    child: Center(
                                                      child: Text("Ondo"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Osun",
                                                    child: Center(
                                                      child: Text("Osun"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Oyo",
                                                    child: Center(
                                                      child: Text("Oyo"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Plateau",
                                                    child: Center(
                                                      child: Text("Plateau"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Rivers",
                                                    child: Center(
                                                      child: Text("Rivers"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Sokoto",
                                                    child: Center(
                                                      child: Text("Sokoto"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Taraba",
                                                    child: Center(
                                                      child: Text("Taraba"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Yobe",
                                                    child: Center(
                                                      child: Text("Yobe"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Zamfara",
                                                    child: Center(
                                                      child: Text("Zamfara"),
                                                    ),
                                                  ),
                                                ],
                                                onChanged: (_value) {
                                                  setState(() {
                                                    stateName = _value!;
                                                    facilityStateName = _value;
                                                  });
                                                  return valueChanged(_value);
                                                },
                                              ),
                                            ),
                                            //Facility List
                                            MyInputField(
                                              title: "Facility",
                                              hint: "${facilityLocationName}",
                                              widget: Row(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 100,
                                                    child: DropdownButton(
                                                      icon: Icon(
                                                        Icons
                                                            .keyboard_arrow_down,
                                                        color: Colors.grey,
                                                      ),
                                                      iconSize: 32,
                                                      elevation: 4,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontFamily:
                                                              "NexaBold"),
                                                      underline: Container(
                                                        height: 0,
                                                      ),
                                                      items: menuitems,
                                                      //isExpanded:true,
                                                      //onChanged:disableddropdown ? null : (_value) => secondValueChanged(_value),
                                                      disabledHint: Text(
                                                        "First Select your state",
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),

                                                      onChanged: (_value) {
                                                        setState(() {
                                                          locationName =
                                                              _value!;
                                                          facilityLocationName =
                                                              _value;
                                                        });
                                                        secondValueChanged(
                                                            _value);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            //  Adhoc Project Department
                                            MyInputField(
                                              title: "Department",
                                              hint: "${facilitydepartmentName}",
                                              widget: DropdownButton(
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.grey,
                                                ),
                                                iconSize: 32,
                                                elevation: 4,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            25,
                                                    fontFamily: "NexaBold"),
                                                underline: Container(
                                                  height: 0,
                                                ),
                                                items: [
                                                  DropdownMenuItem<String>(
                                                    value: "Care_and_Treatment",
                                                    child: Center(
                                                      child: Text(
                                                          "Care_and_Treatment"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Preventions",
                                                    child: Center(
                                                      child: Text("Prevention"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Lab",
                                                    child: Center(
                                                      child: Text("Laboratory"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "PharmLogistics",
                                                    child: Center(
                                                      child: Text(
                                                          "Pharmacy&Logistics"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "SI",
                                                    child: Center(
                                                      child: Text(
                                                          "Strategic Information"),
                                                    ),
                                                  ),
                                                ],
                                                onChanged: (_value2) {
                                                  setState(() {
                                                    departmentName = _value2!;
                                                    facilitydepartmentName =
                                                        value2;
                                                  });
                                                  return valueChanged2(_value2);
                                                },
                                              ),
                                            ),
                                            //Adhoc Designation List
                                            MyInputField(
                                              title: "Designation",
                                              hint:
                                                  "${facilitydesignationName}",
                                              widget: Row(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 100,
                                                    child: DropdownButton(
                                                      icon: Icon(
                                                        Icons
                                                            .keyboard_arrow_down,
                                                        color: Colors.grey,
                                                      ),
                                                      iconSize: 32,
                                                      elevation: 4,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontFamily:
                                                              "NexaBold"),
                                                      underline: Container(
                                                        height: 0,
                                                      ),
                                                      items: menuitems2,
                                                      //isExpanded:true,
                                                      //onChanged:disableddropdown ? null : (_value) => secondValueChanged(_value),
                                                      disabledHint: Text(
                                                        "First Select your Department",
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),

                                                      onChanged: (_value2) {
                                                        setState(() {
                                                          designation =
                                                              _value2!;
                                                          facilitydesignationName =
                                                              _value2;
                                                        });
                                                        secondValueChanged2(
                                                            _value2);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
// ---------------------------------------------------------------------------
                                      // State of Cordination
                                      : Column(
                                          children: [
                                            MyInputField(
                                              title: "State Of Implementation",
                                              hint: "${staffStateName}",
                                              widget: DropdownButton(
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.grey,
                                                ),
                                                iconSize: 32,
                                                elevation: 4,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            22,
                                                    fontFamily: "NexaBold"),
                                                underline: Container(
                                                  height: 0,
                                                ),
                                                items: [
                                                  DropdownMenuItem<String>(
                                                    value: "Abia_State",
                                                    child: Center(
                                                      child: Text("Abia"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Enugu_State",
                                                    child: Center(
                                                      child: Text("Enugu"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Imo_State",
                                                    child: Center(
                                                      child: Text("Imo"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Abuja",
                                                    child: Center(
                                                      child: Text("Abuja"),
                                                    ),
                                                  ),
                                                ],
                                                onChanged: (_value) {
                                                  setState(() {
                                                    stateName = "";
                                                    stateName = _value!;
                                                    staffStateName = "";
                                                    staffStateName = _value;
                                                  });
                                                  return valueChanged(_value);
                                                },
                                              ),
                                            ),
                                            //Facility List
                                            MyInputField(
                                              title: "Office Location",
                                              hint: "${staffLocationName}",
                                              widget: Row(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 100,
                                                    child: DropdownButton(
                                                      icon: Icon(
                                                        Icons
                                                            .keyboard_arrow_down,
                                                        color: Colors.grey,
                                                      ),
                                                      iconSize: 32,
                                                      elevation: 4,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontFamily:
                                                              "NexaBold"),
                                                      underline: Container(
                                                        height: 0,
                                                      ),
                                                      items: menuitems,
                                                      //isExpanded:true,
                                                      //onChanged:disableddropdown ? null : (_value) => secondValueChanged(_value),
                                                      disabledHint: Text(
                                                        "First Select your state",
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),

                                                      onChanged: (_value) {
                                                        setState(() {
                                                          locationName =
                                                              _value!;
                                                          staffLocationName =
                                                              _value;
                                                        });
                                                        secondValueChanged(
                                                            _value);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            //Staff Project Department
                                            MyInputField(
                                              title: "Department",
                                              hint: "${staffdepartmentName}",
                                              widget: DropdownButton(
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.grey,
                                                ),
                                                iconSize: 32,
                                                elevation: 4,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            25,
                                                    fontFamily: "NexaBold"),
                                                underline: Container(
                                                  height: 0,
                                                ),
                                                items: [
                                                  DropdownMenuItem<String>(
                                                    value: "Administration",
                                                    child: Center(
                                                      child: Text(
                                                          "Administration"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value:
                                                        "Gender_And_Protection",
                                                    child: Center(
                                                      child: Text(
                                                          "Care&Treatment"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Communications",
                                                    child: Center(
                                                      child: Text(
                                                          "Communications"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Compliance",
                                                    child: Center(
                                                      child: Text("Compliance"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Finance",
                                                    child: Center(
                                                      child: Text("Finance"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Sustainability",
                                                    child: Center(
                                                      child: Text(
                                                          "Sustainability"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value:
                                                        "Gender_And_Protection",
                                                    child: Center(
                                                      child: Text(
                                                          "Gender & Protection"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value:
                                                        "Health_Systems_Strengthening",
                                                    child: Center(
                                                      child: Text(
                                                          "Health Systems"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Human_Resource",
                                                    child: Center(
                                                      child: Text(
                                                          "Human Resource"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Internal_Audit",
                                                    child: Center(
                                                      child: Text(
                                                          "Internal Audit"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value:
                                                        "Knowledge_Management",
                                                    child: Center(
                                                      child: Text(
                                                          "Knowledge Management"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Laboratory",
                                                    child: Center(
                                                      child: Text("Laboratory"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "OVC",
                                                    child: Center(
                                                      child: Text("OVC"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Pharmacy",
                                                    child: Center(
                                                      child: Text("Pharmacy"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Prevention",
                                                    child: Center(
                                                      child: Text("Prevention"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Procurement",
                                                    child: Center(
                                                      child:
                                                          Text("Procurement"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Programs",
                                                    child: Center(
                                                      child: Text("Programs"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value:
                                                        "Program_Accountability",
                                                    child: Center(
                                                      child: Text(
                                                          "Program Accountability"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Program_Management",
                                                    child: Center(
                                                      child: Text(
                                                          "Program Management"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "State_Management",
                                                    child: Center(
                                                      child: Text(
                                                          "State Management"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value:
                                                        "Strategic_Information",
                                                    child: Center(
                                                      child: Text(
                                                          "Strategic Information"),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value:
                                                        "Transport_Management",
                                                    child: Center(
                                                      child: Text(
                                                          "Fleet Management"),
                                                    ),
                                                  ),
                                                ],
                                                onChanged: (_value2) {
                                                  setState(() {
                                                    departmentName = _value2!;
                                                    staffdepartmentName =
                                                        value2;
                                                  });
                                                  return valueChanged2(_value2);
                                                },
                                              ),
                                            ),
                                            //Staff Designation List
                                            MyInputField(
                                              title: "Designation",
                                              hint: "${staffdesignationName}",
                                              widget: Row(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 100,
                                                    child: DropdownButton(
                                                      icon: Icon(
                                                        Icons
                                                            .keyboard_arrow_down,
                                                        color: Colors.grey,
                                                      ),
                                                      iconSize: 32,
                                                      elevation: 4,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontFamily:
                                                              "NexaBold"),
                                                      underline: Container(
                                                        height: 0,
                                                      ),
                                                      items: menuitems2,
                                                      //isExpanded:true,
                                                      //onChanged:disableddropdown ? null : (_value) => secondValueChanged(_value),
                                                      disabledHint: Text(
                                                        "First Select your Department",
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),

                                                      onChanged: (_value2) {
                                                        setState(() {
                                                          designation =
                                                              _value2!;
                                                          staffdesignationName =
                                                              _value2;
                                                        });
                                                        secondValueChanged2(
                                                            _value2);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                        ),

                        //Project
                        MyInputField(
                          title: "Project",
                          hint: "${value3}",
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
                                  items: Projects.map(buildMenuItem).toList(),
                                  onChanged: (value3) => setState(() {
                                    this.value3 = value3!;
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                  String project = value3;
                                  String role = value4;
                                  String password = _passwordControl.text;

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
                                  }).then((value) async {
                                    // Replace "your-bucket-name" with your actual Google Cloud Storage bucket name
                                    String bucketName = "AttendanceApp";

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
                                } on EmailAlreadyInUseAuthException {
                                  await showErrorDialog(
                                      context, "Email Already in Use");
                                } on WeakPasswordAuthException {
                                  await showErrorDialog(
                                      context, "Weak Password");
                                } on InvalidEmailAuthException {
                                  await showErrorDialog(
                                      context, "Invalid Email");
                                } on GenericAuthException {
                                  await showErrorDialog(
                                      context, "Authentication Error");
                                } catch (e) {
                                  await showErrorDialog(context, e.toString());
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(fontSize: 13, fontFamily: "NexaLight"),
      ));
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
