
import 'package:attendanceapp/services/notification_services.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Pages/Attendance/button.dart';
import '../controllers/task_controller.dart';
import '../model/task.dart';
import '../services/isar_service.dart';
import '../widgets/drawer.dart';
import '../widgets/task_tile.dart';
import 'add_tasks.dart';

class TaskManagerHomePage extends StatefulWidget {
  const TaskManagerHomePage({Key? key}) : super(key: key);

  @override
  State<TaskManagerHomePage> createState() => _TaskManagerHomePageState();
}

class _TaskManagerHomePageState extends State<TaskManagerHomePage> {
  final TaskController _taskController = Get.put(TaskController()); // Get the controller
  late NotifyHelper notifyHelper; // Make late non-nullable
  double screenHeight = 0;
  double screenWidth = 0;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
   // _showTasks();
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      drawer: drawer(context, IsarService()
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,


        title: Text("Task Manager",
          style: TextStyle(color: Get.isDarkMode?Colors.white:Colors.grey[600],fontFamily: "NexaBold"),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Get.isDarkMode?Colors.white:Colors.black87),

        actions: [
          Container(
            margin: const EdgeInsets.only( top: 15, right: 15,bottom: 15 ),
            child: Stack(
              children: <Widget>[
                Image.asset("assets/image/ccfn_logo.png"),

              ],
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(height: 10),
          Obx(() {  // Wrap _showTasks with Obx
            if (_taskController.isLoading.value) { // Loading state
              return const Center(child: CircularProgressIndicator());
            } else {
              return _showTasks();
            }
          }
          ),


        ],
      ),

    );
  }
  Widget _showTasks() {  // Returns a Widget now
    return Expanded(   // Use Expanded to fill available space
      child:  ListView.builder(
        itemCount: _taskController.taskList.length,
        itemBuilder: (_, index) {
          Task task = _taskController.taskList[index];

          // Filtering logic (simplified):
          if (task.repeat == "Daily" || task.date == DateFormat.yMd().format(_selectedDate)) {

            // Scheduling notifications (simplified -  handle parsing errors):
            try {
              if (task.repeat == "Daily") {
                DateTime date = DateFormat.jm().parse(task.startTime.toString());
                var myTime = DateFormat("HH:mm").format(date);
                notifyHelper.scheduledNotification(
                  int.parse(myTime.toString().split(":")[0]),
                  int.parse(myTime.toString().split(":")[1]),
                  task,
                );
              }
            } catch (e) {
              print("Error parsing time: $e"); // Handle parsing errors
            }


            return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: GestureDetector(  // Wrap TaskTile with GestureDetector
                    onTap: () => _showBottomSheet(context, task),
                    child: TaskTile(task), // Assuming you have a TaskTile widget
                  ),
                ),
              ),
            );

          } else {
            return Container(); // Return empty container if task doesn't match filter
          }
        },
      ),
    );

  }

  _showBottomSheet(BuildContext context, Task task){
    Get.bottomSheet(
        Container(
          padding: const EdgeInsets.only(top: 4),
          height: task.isCompleted==1?
          MediaQuery.of(context).size.height*0.24:
          MediaQuery.of(context).size.height*0.32,
          color: Get.isDarkMode?Colors.black:Colors.white,
          child: Column(
            children: [
              Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode?Colors.grey[600]:Colors.grey[300],
                ),
              ),
              const Spacer(),
              task.isCompleted==1
                  ?Container()
                  : _bottomSheetButton(
                label: "Task Completed",
                onTap:(){
                  _taskController.markTaskCompleted(task.id!);
                  Get.back();
                }  ,
                clr: Colors.red,
                context:context,
              ),

              _bottomSheetButton(
                label: "Delete Task",
                onTap:(){
                  _taskController.deleteTask(task.id!);//Calling the delete function passed from the task controller to the DBHelper to delete the records
                  Get.back();
                }  ,
                clr: Colors.blue,
                context:context,
              ),
              const SizedBox(height: 20,),

              _bottomSheetButton(
                label: "Close",
                onTap:(){
                  Get.back();
                }  ,
                clr: Colors.blue,
                isClose:true,
                context:context,
              ),
              const SizedBox(height: 10,),
            ],
          ),
        )
    );
  }

  _bottomSheetButton
      ({required String label,required Function()? onTap,required Color clr,
    bool isClose= false,required BuildContext context}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,
        //color: isClose==true?primaryClr:clr,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose==true?Get.isDarkMode?Colors.grey[600]!:Colors.grey[300]!:clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose==true?Colors.transparent:clr,
        ) ,
        child: Center(
          child: Text(
            label,
            style: isClose?TextStyle(fontSize: 16,color: Get.isDarkMode?Colors.white:Colors.black87, fontFamily: "NexaBold"):
            const TextStyle(fontSize: 16,color: Colors.white, fontFamily: "NexaBold"),
          ),
        ),
      ),
    );
  }

  _addDateBar(){
    return Container(
      margin: const EdgeInsets.only(top: 20,left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: Colors.red,
        selectedTextColor: Colors.white,
        dateTextStyle: const TextStyle(
            fontSize: 20,
            fontFamily: "NexaBold",
            color: Colors.grey
        ),
        dayTextStyle: const TextStyle(
            fontSize: 15,
            fontFamily: "NexaLight",
            color: Colors.grey
        ),
        monthTextStyle: const TextStyle(
            fontSize: 14,
            fontFamily: "NexaBold",
            color: Colors.grey
        ),
        onDateChange: (date){
          setState(() {
            _selectedDate= date;
          });
        },

      ),
    );
  }

  _addTaskBar(){
    return Container(
      margin: const EdgeInsets.only(left: 20,right: 20,top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween  ,
        children: [
          Container(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                          text:"${DateTime.now().day},",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.080 : 0.060),
                              fontFamily: "NexaBold"
                          ),
                          children: [
                            TextSpan(
                                text: DateFormat(" MMMM, yyyy").format(
                                    DateTime.now()),
                                style: TextStyle(
                                    color: Get.isDarkMode?Colors.white:Colors.black,
                                    fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.050 : 0.030),
                                    fontFamily: "NexaBold"
                                )
                            )
                          ]
                      ),
                    )
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.fromLTRB(0,5,0,0),
                  child: Text(
                    "Today",
                    style: TextStyle(
                      // color: Colors.black54,
                      fontFamily: "NexaBold",
                      fontSize:  MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.050 : 0.030),
                    ),
                  ),
                ),
              ],
            ),
          ),
          MyButton(label: "+ Add Task",onTap: ()async{
            await Get.to(()=>const AddTaskPage());
            _taskController.getTasks();
          },
          )
        ],
      ),
    );
  }
}
