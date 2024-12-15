import 'package:get/get.dart';

import '../model/task.dart';
import '../services/isar_service.dart';

class TaskController extends GetxController{
  final IsarService _isarService = IsarService.instance; // Use your IsarService instance
  var taskList = <Task>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    getTasks(); // Fetch tasks initially
    super.onInit();
  }



  /// Save a new task to the Isar database
  Future<void> addTask(Task newTask) async {
    await _isarService.saveTask(newTask);
    getTasks(); // Refresh task list
  }



  /// Fetch all tasks from Isar and update the observable task list
  Future<void> getTasks() async {
    isLoading.value = true;
    try{
      List<Task> tasks = await _isarService.getAllTasks();
      taskList.assignAll(tasks);
    }finally {
      isLoading.value = false;
    }


  }

  Future<void> deleteAllTask() async {

    try{
      await _isarService.deleteAllTasks();
      getTasks();
    }finally {

    }


  }

  Stream<List<Task>> listenForTaskChanges() {
    return _isarService.listenToTasks();
  }





  /// Delete a task by its ID
  void deleteTask(int id) async {
    await _isarService.removeTask(id);
    getTasks(); // Refresh the list
  }

  /// Update the isCompleted status of a task by ID
  void markTaskCompleted(int id) async {
    final task = await _isarService.getTaskById(id);
    if (task != null) {
      task.isCompleted = !task.isCompleted; // Toggle completion status
      await _isarService.updateTask(task);
      getTasks(); // Refresh the list
    }
  }




  // These functions can be improved:

  int getTotalTask() {
    return taskList.length;


  }

  int getTotalDone(){
    return taskList.where((task) => task.isCompleted).length;

  }
}