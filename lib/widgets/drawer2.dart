
import 'package:attendanceapp/Pages/Attendance/attendance_home.dart';
import 'package:attendanceapp/Pages/Attendance/button.dart';
import 'package:attendanceapp/Pages/OffDays/days_off.dart';
import 'package:attendanceapp/Pages/forgot_password.dart';
import 'package:attendanceapp/Pages/login_page.dart';
import 'package:attendanceapp/model/user_query.dart';
import 'package:attendanceapp/services/database_adapter.dart';
import 'package:attendanceapp/services/hive_service.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:refreshable_widget/refreshable_widget.dart';

import '../Pages/Dashboard/admin_dashboard.dart';
import '../Pages/Timesheet/timesheet.dart';
import '../Pages/registration_updated.dart';

Widget drawer2(
    BuildContext context,
    IsarService service,
    ) {
  final IsarService service = IsarService();

  //final DataBaseService _dataBaseService = DataBaseService();
  double drawerIconSize = 24;
  double drawerFontSize = 17;
  //final _taskController = Get.put(TaskController());

  return Drawer(
    child: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                0.0,
                1.0
              ],
              colors: [
                Colors.white,
                Colors.white,
              ])),
      child: ListView(
        children: [
          // Row(children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Get.isDarkMode ? Colors.white : Colors.black,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
                colors: [Colors.red, Colors.black],
              ),
            ),
            child: Container(
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: [
                    const Text(
                      "Dashboard",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontFamily: "NexaBold"),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Container(
                        margin: const EdgeInsets.only(
                          top: 20,
                          bottom: 24,
                        ),
                        height: 100,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.redAccent,
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
                        )),
                  ],
                )),
          ),

          // ],
          // ),

          ListTile(
              leading: Icon(
                Icons.screen_lock_landscape_rounded,
                size: drawerIconSize,
                color: Colors.red,
              ),
              title: Text(
                'DashBoard',
                style: TextStyle(
                    fontSize: drawerFontSize,
                    color: Get.isDarkMode ? Colors.white : Colors.brown),
              ),
              onTap: () async {
                //onTap();
                // await _dataBaseService.loadDB();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminDashBoard(
                        service: IsarService(),
                      )),
                );
              }),
          const Divider(
            color: Colors.grey,
            height: 1,
          ),
          ListTile(
            leading:
            Icon(Icons.work, size: drawerIconSize, color: Colors.orange),
            title: Text(
              'Attendance',
              style: TextStyle(fontSize: drawerFontSize, color: Colors.brown),
            ),
            onTap: () {
              // _taskController.getTasks();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AttendanceHomeScreen(
                      service: IsarService(),
                    )),
              );
            },
          ),
          const Divider(
            color: Colors.grey,
            height: 1,
          ),
          ListTile(
            leading: Icon(Icons.person_add_alt_1,
                size: drawerIconSize, color: Colors.red),
            title: Text(
              'Create Account',
              style: TextStyle(fontSize: drawerFontSize, color: Colors.brown),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const RegistrationPageUpdated();
              }));
            },
          ),

          const Divider(
            color: Colors.grey,
            height: 1,
          ),
          ListTile(
            leading: Icon(
              Icons.local_post_office,
              size: drawerIconSize,
              color: Colors.blue,
            ),
            title: Text(
              'Out Of Office',
              style: TextStyle(
                  fontSize: drawerFontSize,
                  color: Get.isDarkMode ? Colors.white : Colors.brown),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DaysOffPage(
                      service: IsarService(),
                    )),
              );
            },
          ),

          const Divider(
            color: Colors.grey,
            height: 1,
          ),
          ListTile(
            leading: Icon(
              Icons.local_post_office,
              size: drawerIconSize,
              color: Colors.blue,
            ),
            title: Text(
              'TimeSheet',
              style: TextStyle(
                  fontSize: drawerFontSize,
                  color: Get.isDarkMode ? Colors.white : Colors.brown),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TimesheetScreen()),
              );
            },
          ),

          const Divider(
            color: Colors.grey,
            height: 1,
          ),
          ListTile(
            leading: Icon(
              Icons.password_rounded,
              size: drawerIconSize,
              color: Colors.purple,
            ),
            title: Text(
              'Forgot Password',
              style: TextStyle(fontSize: drawerFontSize, color: Colors.brown),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                //MaterialPageRoute(builder: (context) => MyFlutterApp()),
              );
            },
          ),

          const Divider(
            color: Colors.grey,
            height: 1,
          ),
          ListTile(
            leading: Icon(
              Icons.report,
              size: drawerIconSize,
              color: Colors.blue,
            ),
            title: Text(
              'Report',
              style: TextStyle(fontSize: drawerFontSize, color: Colors.brown),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserQueryScreen()),
              );

              //_showBottomSheet2(context);
            },
          ),

          const Divider(
            color: Colors.grey,
            height: 1,
          ),
          ListTile(
            leading: Icon(
              Icons.logout_rounded,
              size: drawerIconSize,
              color: Colors.red,
            ),
            title: Text(
              'Logout',
              style: TextStyle(fontSize: drawerFontSize, color: Colors.brown),
            ),
            onTap: () {
              _displayDialog(context);
            },
          ),
        ],
      ),
    ),
  );
}

Future<List<Uint8List>?> _readImagesFromDatabase() async {
  DatabaseAdapter adapter = HiveService();
  return adapter.getImages();
}

_displayDialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Do you want to Log-Out?'),
          content: const Text("Kindly Choose your Log-Out Option"
            //controller: _textFieldController,
            //decoration: InputDecoration(hintText: "TextField in Dialog"),
          ),
          actions: <Widget>[
            MyButton(
                label: "Exit",
                onTap: () {
                  Navigator.of(context).pop();
                  SystemNavigator.pop();
                }),
            MyButton(
                label: "Switch Account",
                onTap: () {
                  Navigator.of(context).pop();
                  _displayDialogForDiffAcount(context);
                  //Navigator.of(context).pop();
                })
          ],
        );
      });
}

_displayDialogForDiffAcount(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Have you synced all attendance?'),
          content: const Text("Kindly Sync all data before switching account"
            //controller: _textFieldController,
            //decoration: InputDecoration(hintText: "TextField in Dialog"),
          ),
          actions: <Widget>[
            MyButton(
                label: "Yes",
                onTap: () {
                  _switchAccountValidation(context);

                  Navigator.of(context).pop();
                }),
            MyButton(
                label: "No",
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AttendanceHomeScreen(
                            service: IsarService(),
                          )));
                  Fluttertoast.showToast(
                      msg: "Sync data before switching account",
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.black54,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      fontSize: 16.0);
                })
          ],
        );
      });
}

void _switchAccountValidation(BuildContext context) async {
  final attendanceNotSynced = await IsarService().getAttendanceForUnSynced();
  // SharedPreferences preferences = await SharedPreferences.getInstance();

  if (attendanceNotSynced.isEmpty) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) {
        return LoginPage(
          service: IsarService(),
        );
      }),
          (route) => false, // Remove all previous routes
    );
    Fluttertoast.showToast(
        msg: "Login to switch account",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  } else {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AttendanceHomeScreen(
              service: IsarService(),
            )));
    Fluttertoast.showToast(
        msg: "Sync data before switching account",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

_showBottomSheet2(BuildContext context) {
  return showBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 4),
          height: MediaQuery.of(context).size.height * 0.32,
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.deepOrange,
                ),
              ),
              const Spacer(),
              _bottomSheetButton(
                label: "Local Backup",
                onTap: () async {
                  // final feedback =
                  //     await widget.service.getSpecificFeedback(id);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ModifySheetsPage(feedback:feedback,)));
                  //_updateFeedback(context, id);
                  //_taskController.markTaskCompleted(task.id!);
                  //Navigator.of(context).pop();
                },
                clr: Colors.red,
                context: context,
              ),
              _bottomSheetButton(
                label: "Restore from Local DB",
                onTap: () async {
                  // await widget.service.deleteFeedback(id);
                  // Navigator.of(context).pop();
                },
                clr: Colors.orange,
                context: context,
              ),
              const SizedBox(
                height: 20,
              ),
              _bottomSheetButton(
                label: "Restore from Server",
                onTap: () {
                  //Navigator.of(context).pop();
                },
                clr: Colors.red,
                isClose: true,
                context: context,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      });
}

_bottomSheetButton(
    {required String label,
      required Function()? onTap,
      required Color clr,
      bool isClose = false,
      required BuildContext context}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      height: 55,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: isClose == true ? Colors.red : Colors.blue,
        border: Border.all(
          width: 2,
          color: Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(20),
        //color: Colors.transparent,
      ),
      child: Center(
        child: Text(label,
            style: const TextStyle(
                fontSize: 16, color: Colors.white, fontFamily: "NexaBold")),
      ),
    ),
  );
}

