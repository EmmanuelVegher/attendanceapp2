
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Pages/Attendance/button.dart';
import '../controllers/task_controller.dart';
import '../model/task.dart';
import '../services/isar_service.dart';
import '../widgets/input_field.dart';


class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.find<TaskController>(); // Use Get.find
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "12:00 PM"; // Initialize with a default value
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  final List<int> remindList = [5, 10, 15, 20];

  String _selectedRepeat = "None";
  final List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
  int _selectedColor = 0;
  double screenHeight = 0;
  double screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    double screenHeight = 0;
    double screenWidth = 0;
    screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: context.theme.backgroundColor,
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios,size: 20,color: Get.isDarkMode?Colors.white:Colors.black87,),
        ),

        elevation: 0.5,
        iconTheme: IconThemeData(color: Get.isDarkMode?Colors.white:Colors.black87),
        /*flexibleSpace:Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.white, Colors.white,]
              )
          ),
        ),*/

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
      body: Container(
        padding: const EdgeInsets.only(left: 20,right: 20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text("Add Task",
                style: TextStyle(
                  color: Get.isDarkMode?Colors.white:Colors.black87,
                  fontFamily: "NexaBold",
                  fontSize: screenWidth / 15,
                ),),
              MyInputField(title: "Title", hint: "Enter title here",controller: _titleController,),
              MyInputField(title: "Note", hint: "Enter your note",controller: _noteController,),
              MyInputField(title: "Date", hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: (){
                    _getDateFromUser();
                  },
                  icon: const Icon(Icons.calendar_today_outlined,color: Colors.grey,),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                        title: "Start Date",
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: (){
                            _getTimeFromUser(isStartTime:true);
                          } ,
                          icon: const Icon(Icons.access_time_rounded,color: Colors.grey,),
                        ),
                      )
                  ),
                  const SizedBox(width: 12,),
                  Expanded(
                      child: MyInputField(
                        title: "End Date",
                        hint: _endTime,
                        widget: IconButton(
                          onPressed: (){
                            _getTimeFromUser(isStartTime:false);
                          } ,
                          icon: const Icon(Icons.access_time_rounded,color: Colors.grey,),
                        ),
                      )
                  )
                ],
              ),
              MyInputField(title: "Remind", hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  icon: const Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                  iconSize: 32,
                  elevation: 4,
                  style: TextStyle(
                      color: Get.isDarkMode?Colors.white:Colors.black,
                      fontSize: screenWidth / 25,
                      fontFamily: "NexaBold"
                  ),
                  underline: Container(height: 0,),
                  items: remindList.map<DropdownMenuItem<String>>((int value){
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  },
                  ).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                ),),
              MyInputField(title: "Repeat", hint: _selectedRepeat,
                widget: DropdownButton(
                  icon: const Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                  iconSize: 32,
                  elevation: 4,
                  style: TextStyle(
                      color: Get.isDarkMode?Colors.white:Colors.black,
                      fontSize: screenWidth / 25,
                      fontFamily: "NexaBold"
                  ),
                  underline: Container(height: 0,),
                  items: repeatList.map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                        style:TextStyle(
                            color: Get.isDarkMode?Colors.white:Colors.black,
                            fontSize: screenWidth / 25,
                            fontFamily: "NexaBold"
                        ),),
                    );
                  },
                  ).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                ),),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Color",style: TextStyle(
                          color: Get.isDarkMode?Colors.white:Colors.black,
                          fontSize: screenWidth / 21,
                          fontFamily: "NexaBold"
                      ),),
                      const SizedBox(height: 8.0,),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: List<Widget>.generate(
                            3, (int index){
                          return GestureDetector(
                            onTap: (){
                              setState(() {
                                _selectedColor = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: index==0?Colors.red:index==1?Colors.blue:Colors.yellow,
                                child: _selectedColor ==index?const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                  size: 16,):Container(),
                              ),
                            ),
                          );
                        }
                        ),
                      )
                    ],
                  ),
                  MyButton(label: "Create Task", onTap: ()=>_ValidateData()),
                ],
              ),
              const SizedBox(height: 40,)
            ],
          ),
        ),
      ),
    );
  }

  // _ValidateData(){
  //   if(_titleController.text.isNotEmpty && _noteController.text.isNotEmpty){
  //     //Add to database by firstt sending it to the task controller that would then hand it to the task model and then to the database
  //     _addTaskToDb();
  //     Get.back();
  //   }else if(_titleController.text.isEmpty || _noteController.text.isEmpty){
  //     Get.snackbar("Required", "All Fields are required !",
  //         colorText: Get.isDarkMode?Colors.black:Colors.white,
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Get.isDarkMode?Colors.white:Colors.black87,
  //         icon: Icon(Icons.warning_amber_rounded,color: Get.isDarkMode?Colors.black:Colors.white,)
  //     );
  //   }
  // }

  _ValidateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb(); // Call _addTaskToDb directly
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.isDarkMode ? Colors.white : Colors.black87,
        colorText: Get.isDarkMode ? Colors.black : Colors.white,
        icon: const Icon(Icons.warning_amber_rounded), // Use const for the icon
      );
    }
  }



  /*int getTotalTask() async{
    var res = 0;
    for (int i = 0; i < _titleController.text.length; i++){
      if(_titleController.text[i].)
    }
  }*/
  _addTaskToDb() async {
    try {

      var newTask = Task()
        ..note= _noteController.text
        ..title= _titleController.text
        ..date= DateFormat.yMd().format(_selectedDate)
        ..startTime= _startTime
        ..endTime= _endTime
        ..remind= _selectedRemind
        ..repeat= _selectedRepeat
        ..color= _selectedColor
        ..isCompleted= false // Use boolean for isCompleted
      ;

      await IsarService().saveTask(newTask);  // Use your controller method
      Get.back(); // Navigate back after adding task


    } catch (e) {
      print("Error adding task: $e"); // Handle any potential errors
    }
  }


  _getDateFromUser() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2100)); // Fix date range

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    } else {
      print("It's null or something is wrong");
    }
  }
  // _getTimeFromUser({required bool isStartTime})async{
  //   var pickedTime =  await _showTimePicker();
  //   String _formatedTime = pickedTime.format(context);
  //   if(pickedTime==null){
  //     print("Time Canceled");
  //   }else if(isStartTime == true){
  //     setState(() {
  //       _startTime = _formatedTime;
  //     });
  //
  //   }else if(isStartTime ==false){
  //     setState(() {
  //       _endTime = _formatedTime;
  //     });
  //   }
  // }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.now()
          : const TimeOfDay(hour: 12, minute: 0), // Default to 12:00 PM for end time
    );
    if (pickedTime != null) {
      final now = DateTime.now();
      final selectedTime = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
      final formattedTime = DateFormat("hh:mm a").format(selectedTime);

      setState(() {
        if (isStartTime) {
          _startTime = formattedTime;
        } else {
          _endTime = formattedTime;
        }
      });
    }
  }

  _showTimePicker(){
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          //_startTime --> 12:00 AM
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        )
    );
  }


}
