import 'package:attendanceapp/services/isar_service.dart';
import 'package:attendanceapp/widgets/drawer.dart';
import 'package:attendanceapp/widgets/drawer3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../widgets/drawer2.dart';

class SuperAdminUserDashBoard extends StatefulWidget {
  const SuperAdminUserDashBoard({super.key});

  @override
  State<SuperAdminUserDashBoard> createState() =>
      _SuperAdminUserDashBoardState();
}

class _SuperAdminUserDashBoardState extends State<SuperAdminUserDashBoard> {
  var firstName;
  var lastName;
  var firebaseAuthId;
  var role;

  @override
  void initState() {
    _getUserDetail();
    super.initState();
  }

  void _getUserDetail() async {
    final userDetail = await IsarService().getBioInfoWithFirebaseAuth();
    setState(() {
      role = userDetail?.role;
      firstName = userDetail?.firstName;
      lastName = userDetail?.lastName;
      firebaseAuthId = userDetail?.firebaseAuthId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Super Admin Interface",
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
        ),
        drawer:
            // role == "User"
            //     ? drawer(this.context, IsarService())
            //     : role == "Admin"
            //         ? drawer2(this.context, IsarService())
            //         :
            drawer3(this.context, IsarService()),
        body: Center(
          child: Text("This is the Super-Admin Page"),
        ));
  }
}
