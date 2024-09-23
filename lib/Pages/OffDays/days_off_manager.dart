// import 'package:attendanceapp/model/daysoffmodel.dart';
// import 'package:attendanceapp/services/isar_service.dart';
// import 'package:attendanceapp/services/notification_services.dart';
// import 'package:date_picker_timeline/date_picker_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:intl/intl.dart';

// class DaysOffManagerHomePage extends StatefulWidget {
//   final IsarService service;
//   const DaysOffManagerHomePage({Key? key, required this.service})
//       : super(key: key);

//   @override
//   State<DaysOffManagerHomePage> createState() => _DaysOffManagerHomePageState();
// }

// class _DaysOffManagerHomePageState extends State<DaysOffManagerHomePage> {
//   //final _taskController = Get.put(TaskController());
//   var notifyHelper;
//   double screenHeight = 0;
//   double screenWidth = 0;
//   DateTime _selectedDate = DateTime.now();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     //notifyHelper = NotifyHelper();
//     // notifyHelper.initializeNotification();
//     // notifyHelper.requestIOSPermissions();
//     _showTasks();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       // appBar: AppBar(
//       //   backgroundColor: Colors.red,
//       //   leading: GestureDetector(
//       //     onTap: (){
//       //       ThemeService().switchTheme();
//       //       notifyHelper.displayNotification(
//       //         title: "Theme Changed",
//       //         body:Get.isDarkMode?"Activated Light Theme":"Activated Dark Theme"
//       //       );

//       //       //notifyHelper.scheduledNotification(); //This is for Scheduled Notification
//       //     },
//       //     child: Icon(Get.isDarkMode? Icons.wb_sunny_outlined: Icons.nightlight_round, size: 20,),
//       //   ),
//       //   title: Text("Task Manager",
//       //     style: TextStyle(color: Get.isDarkMode?Colors.white:Colors.grey[600],fontFamily: "NexaBold"),
//       //   ),
//       //   elevation: 0.5,
//       //   iconTheme: IconThemeData(color: Get.isDarkMode?Colors.white:Colors.black87),
//       //   /*flexibleSpace:Container(
//       //     decoration: const BoxDecoration(
//       //         gradient: LinearGradient(
//       //             begin: Alignment.topLeft,
//       //             end: Alignment.bottomRight,
//       //             colors: <Color>[Colors.white, Colors.white,]
//       //         )
//       //     ),
//       //   ),*/

//       //   actions: [
//       //     Container(
//       //       margin: const EdgeInsets.only( top: 15, right: 15,bottom: 15 ),
//       //       child: Stack(
//       //         children: <Widget>[
//       //           Image.asset("./images/ccfn_logo.png"),

//       //         ],
//       //       ),
//       //     )
//       //   ],
//       // ),
//       // backgroundColor: context.theme.backgroundColor,
//       body: Column(
//         children: [
//           _addTaskBar(),
//           _addDateBar(),
//           SizedBox(
//             height: 10,
//           ),
//           _showTasks(),
//         ],
//       ),
//     );
//   }

//   _showTasks() {
//     return Expanded(
//       child: StreamBuilder<List<DaysOffModel>>(
//           stream: widget.service.searchAllDaysOff(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               final offday = snapshot.data;
//               if (offday!.isEmpty) {
//                 return const Center(child: Text('No Day Off found'));
//               }
//               return ListView.builder(
//                   itemCount: offday.length,
//                   itemBuilder: (context, index) {
//                     // Task task = _taskController.taskList[index];
//                     // if (task.repeat == "Daily") {
//                     //   //we need to split the StartTime and split the AM or PM and convert it to either seconds, hours etc
//                     //   DateTime date = DateFormat.jm().parse(task.startTime
//                     //       .toString()); //We need to parse the DateTime that is already a string to Datetime
//                     //   var myTime = DateFormat("HH:mm").format(
//                     //       date); //Now we format the dateformat to just HH:mm
//                     //   notifyHelper.scheduledNotification(
//                     //       int.parse(myTime.toString().split(":")[
//                     //           0]), //Here we convert back to string and get Parsed integer of  the First index of the splitted time(Been the hour)
//                     //       int.parse(myTime.toString().split(":")[
//                     //           1]), //Here we convert back to string and get Parsed integer of  the Second index of the splitted time(Been the hour)
//                     //       task);
//                     //   return AnimationConfiguration.staggeredList(
//                     //       position: index,
//                     //       child: SlideAnimation(
//                     //         child: FadeInAnimation(
//                     //           child: Row(
//                     //             children: [
//                     //               GestureDetector(
//                     //                 onTap: () {
//                     //                   _showBottomSheet(context, task);
//                     //                 },
//                     //                 child: TaskTile(task),
//                     //               )
//                     //             ],
//                     //           ),
//                     //         ),
//                     //       ));
//                     // }
//                     if (offday[index].date ==
//                         DateFormat('MMMM').format(_selectedDate)) {
//                       return AnimationConfiguration.staggeredList(
//                           position: index,
//                           child: SlideAnimation(
//                             child: FadeInAnimation(
//                               child: Row(
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {
//                                       //_showBottomSheet(context, task);
//                                     },
//                                     child: Container(
//                                       padding:
//                                           EdgeInsets.symmetric(horizontal: 20),
//                                       width: MediaQuery.of(context).size.width,
//                                       margin: EdgeInsets.only(bottom: 12),
//                                       child: Container(
//                                         padding: EdgeInsets.all(16),
//                                         //  width: SizeConfig.screenWidth * 0.78,
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(16),
//                                           color: Colors.red,
//                                         ),
//                                         child: Row(children: [
//                                           Expanded(
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   offday[index].date ?? "",
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontFamily: "NexaBold",
//                                                     fontSize: 16,
//                                                   ),
//                                                   /*GoogleFonts.lato(
//                     textStyle: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white),
//                   ),*/
//                                                 ),
//                                                 SizedBox(
//                                                   height: 12,
//                                                 ),
//                                                 Row(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.center,
//                                                   children: [
//                                                     Icon(
//                                                       Icons.access_time_rounded,
//                                                       color: Colors.grey[200],
//                                                       size: 18,
//                                                     ),
//                                                     SizedBox(width: 4),
//                                                     Text(
//                                                       "${offday[index].startTime} - ${offday[index].endTime}",
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           color:
//                                                               Colors.grey[100]),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 12),
//                                                 Text(
//                                                   offday[index]
//                                                           .reasonForDaysOff ??
//                                                       "",
//                                                   style: TextStyle(
//                                                       fontSize: 15,
//                                                       color: Colors.grey[100]),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           Container(
//                                             margin: EdgeInsets.symmetric(
//                                                 horizontal: 10),
//                                             height: 60,
//                                             width: 0.5,
//                                             color: Colors.grey[200]!
//                                                 .withOpacity(0.7),
//                                           ),
//                                           RotatedBox(
//                                             quarterTurns: 3,
//                                             child: Text(
//                                               offday[index].isSynced == true
//                                                   ? "SYNCED"
//                                                   : "NOT-SYNCED",
//                                               style: TextStyle(
//                                                   fontSize: 10,
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Colors.white),
//                                             ),
//                                           ),
//                                         ]),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ));
//                     } else {
//                       return Container();
//                     }
//                   });
//             } else {
//               return const Center(child: CircularProgressIndicator());
//             }
//           }),
//     );
//   }

//   // _showBottomSheet(
//   //   BuildContext context,
//   //   /*Task task*/
//   // ) {
//   //   Get.bottomSheet(Container(
//   //     padding: const EdgeInsets.only(top: 4),
//   //     height: task.isCompleted == 1
//   //         ? MediaQuery.of(context).size.height * 0.24
//   //         : MediaQuery.of(context).size.height * 0.32,
//   //     color: Get.isDarkMode ? Colors.black : Colors.white,
//   //     child: Column(
//   //       children: [
//   //         Container(
//   //           height: 6,
//   //           width: 120,
//   //           decoration: BoxDecoration(
//   //             borderRadius: BorderRadius.circular(10),
//   //             color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
//   //           ),
//   //         ),
//   //         Spacer(),
//   //         task.isCompleted == 1
//   //             ? Container()
//   //             : _bottomSheetButton(
//   //                 label: "Task Completed",
//   //                 onTap: () {
//   //                   // _taskController.markTaskCompleted(task.id!);
//   //                   Get.back();
//   //                 },
//   //                 clr: Colors.red,
//   //                 context: context,
//   //               ),
//   //         _bottomSheetButton(
//   //           label: "Delete Day Off Reason",
//   //           onTap: () {
//   //             //_taskController.delete(task);//Calling the delete function passed from the task controller to the DBHelper to delete the records
//   //             Get.back();
//   //           },
//   //           clr: Colors.blue,
//   //           context: context,
//   //         ),
//   //         SizedBox(
//   //           height: 20,
//   //         ),
//   //         _bottomSheetButton(
//   //           label: "Close",
//   //           onTap: () {
//   //             Get.back();
//   //           },
//   //           clr: Colors.blue,
//   //           isClose: true,
//   //           context: context,
//   //         ),
//   //         SizedBox(
//   //           height: 10,
//   //         ),
//   //       ],
//   //     ),
//   //   ));
//   // }

//   _bottomSheetButton(
//       {required String label,
//       required Function()? onTap,
//       required Color clr,
//       bool isClose = false,
//       required BuildContext context}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         height: 55,
//         width: MediaQuery.of(context).size.width * 0.9,
//         //color: isClose==true?primaryClr:clr,
//         decoration: BoxDecoration(
//           border: Border.all(
//             width: 2,
//             color: isClose == true
//                 ? Get.isDarkMode
//                     ? Colors.grey[600]!
//                     : Colors.grey[300]!
//                 : clr,
//           ),
//           borderRadius: BorderRadius.circular(20),
//           color: isClose == true ? Colors.transparent : clr,
//         ),
//         child: Center(
//           child: Text(
//             label,
//             style: isClose
//                 ? TextStyle(
//                     fontSize: 16,
//                     color: Get.isDarkMode ? Colors.white : Colors.black87,
//                     fontFamily: "NexaBold")
//                 : TextStyle(
//                     fontSize: 16, color: Colors.white, fontFamily: "NexaBold"),
//           ),
//         ),
//       ),
//     );
//   }

//   _addDateBar() {
//     return Container(
//       margin: const EdgeInsets.only(top: 20, left: 20),
//       child: DatePicker(
//         DateTime.now(),
//         height: 100,
//         width: 80,
//         initialSelectedDate: DateTime.now(),
//         selectionColor: Colors.red,
//         selectedTextColor: Colors.white,
//         dateTextStyle:
//             TextStyle(fontSize: 20, fontFamily: "NexaBold", color: Colors.grey),
//         dayTextStyle: TextStyle(
//             fontSize: 15, fontFamily: "NexaLight", color: Colors.grey),
//         monthTextStyle:
//             TextStyle(fontSize: 14, fontFamily: "NexaBold", color: Colors.grey),
//         onDateChange: (date) {
//           setState(() {
//             _selectedDate = date;
//           });
//         },
//       ),
//     );
//   }

//   _addTaskBar() {
//     return Container(
//       margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                     alignment: Alignment.centerLeft,
//                     child: RichText(
//                       text: TextSpan(
//                           text: DateTime.now().day.toString(),
//                           style: TextStyle(
//                               color: Colors.red,
//                               fontSize: screenWidth / 18,
//                               fontFamily: "NexaBold"),
//                           children: [
//                             TextSpan(
//                                 text: DateFormat(" MMMM, yyyy")
//                                     .format(DateTime.now()),
//                                 style: TextStyle(
//                                     color: Get.isDarkMode
//                                         ? Colors.white
//                                         : Colors.black,
//                                     fontSize: screenWidth / 20,
//                                     fontFamily: "NexaBold"))
//                           ]),
//                     )),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
//                   child: Text(
//                     "Today",
//                     style: TextStyle(
//                       // color: Colors.black54,
//                       fontFamily: "NexaBold",
//                       fontSize: screenWidth / 18,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // MyButton(
//           //   label: "+ Add Task",
//           //   onTap: () async {
//           //     await Get.to(() => AddTaskPage());
//           //     _taskController.getTasks();
//           //   },
//           // )
//         ],
//       ),
//     );
//   }
// }
