import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DataBaseService {
  // singleton boilerplate
  static final DataBaseService _cameraServiceService =
      DataBaseService._internal();

  factory DataBaseService() {
    return _cameraServiceService;
  }
  // singleton boilerplate
  DataBaseService._internal();

  // file that stores the data on filesystem
  late File jsonFile;

  // Data learned on memory
  Map<String, dynamic> _db = Map<String, dynamic>();
  Map<String, dynamic> get db => this._db;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  //   void _getUserDetail() async {
  //   final userDetail = await IsarService().getBioInfoWithFirebaseAuth();
  //   setState(() {
  //     firstName = userDetail?.firstName;
  //     lastName = userDetail?.lastName;
  //   });
  // }

  Future<File> get _localFile async {
    final path = await _localPath;
    print('path ${path}');
    return File('$path//emb.json');
  }

  Future<int?> deleteFile() async {
    try {
      final file = await _localFile;

      await file.delete();
    } catch (e) {
      return 0;
    }
  }

  // loads a simple json file.
  Future loadDB() async {
    var tempDir = await getApplicationDocumentsDirectory();
    final filePath = tempDir.path + '/emb.json';
    final file = File(filePath);

    //jsonFile = new File(_embPath);

    if (file.existsSync()) {
      deleteFile();
    } else {
      // Reference ref = FirebaseStorage.instance
      //     .ref().child("${User.firstName.toLowerCase()}_${User.lastName
      //     .toLowerCase()}_jsonFilePredictedImage.json");

      // var tempDir = await getApplicationDocumentsDirectory();
      //final filePath = tempDir.path + '/emb.json';
      //final file = File(filePath);

      //final downloadTask = ref.writeToFile(file);
      //   await downloadTask.snapshotEvents.listen((taskSnapshot) {
      //     switch (taskSnapshot.state) {
      //       case TaskState.running:
      //         final progress =
      //             100.0 *
      //                 (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
      //         print("Download of Facial Predicted data is $progress% complete.");
      //         SnackBar(content: Text("Upload is $progress% complete."));
      //         break;
      //       case TaskState.paused:
      //         print("Download is paused");
      //         break;
      //       case TaskState.success:
      //         print("Download is completed");
      //         break;
      //       case TaskState.canceled:
      //         print("Download is canceled");
      //         break;
      //       case TaskState.error:
      //       // TODO: Handle this case.
      //         break;
      //     }
      //   });
      // }
      //ConvertBack to string in the directory path
      String _embPath = tempDir.path + '/emb.json';

      jsonFile = new File(_embPath);

      if (jsonFile.existsSync()) {
        _db = json.decode(jsonFile.readAsStringSync());
      }
    }

    // [Name]: name of the new user
    // [Data]: Face representation for Machine Learning model
    Future saveData(String user, String password, List modelData) async {
      String userAndPass = user + ':' + password;
      _db[userAndPass] = modelData;
      jsonFile.writeAsStringSync(json.encode(_db));

      var tempDir = await getApplicationDocumentsDirectory();
      String _embPath = tempDir.path + '/emb.json';
      File file = File(_embPath);

      try {
        // await mountainsRef.putFile(file);
        // Reference ref = FirebaseStorage.instance
        //     .ref().child("${User.firstName.toLowerCase()}_${User.lastName.toLowerCase()}_jsonFilePredictedImage.json");

        //await ref.putFile(File(file!.path));

        // await ref.putFile(File(file!.path)).snapshotEvents.listen((taskSnapshot) {
        //   switch (taskSnapshot.state) {
        //     case TaskState.running:
        //       final progress =
        //           100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
        //       print("Upload is $progress% complete.");
        //       SnackBar(content: Text("Upload is $progress% complete."));
        //       deleteFile();
        //       //cleanDB();
        //       break;
        //     case TaskState.paused:
        //       print("Upload is paused.");
        //       break;
        //     case TaskState.canceled:
        //       print("Upload was canceled");
        //       break;
        //     case TaskState.error:
        //     // Handle unsuccessful uploads
        //       break;
        //     case TaskState.success:
        //     // Handle successful uploads on complete
        //       cleanDB();

        //       break;
        //   }
        // });
      } catch (e) {
        // ...
      }

      /*
    ref.getDownloadURL().then((value) async {
      setState(() {
        //Save Profile pic URL in User class
        User.profilePicLink = value;
      });
      //Save Profile Pic link to firebase
      await FirebaseFirestore.instance.collection("Employee").doc(User.id).update(
          {
            "profilePic": value,
          });
    });

    setState(() {
      _bottomSheetVisible = true;
      pictureTaked = true;
    });*/
    }

    // deletes the created users
    cleanDB() {
      this._db = Map<String, dynamic>();
      jsonFile.writeAsStringSync(json.encode({}));
    }
  }
}
