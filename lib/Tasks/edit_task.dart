import 'package:attendanceapp/Tasks/task_manager_homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditTasks extends StatefulWidget {
  DocumentSnapshot docid;
  EditTasks({required this.docid});

  @override
  State<EditTasks> createState() => _EditTasksState();
}

class _EditTasksState extends State<EditTasks> {
  TextEditingController title = TextEditingController();

  @override
  void initState() {
    title = TextEditingController(text: widget.docid.get('title'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          MaterialButton(
            onPressed: () {
              widget.docid.reference.update({
                'title': title.text,
              }).whenComplete(() {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => TaskManagerHomePage()));
              });
            },
            child: Text("save"),
          ),
          MaterialButton(
            onPressed: () {
              widget.docid.reference.delete().whenComplete(() {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => TaskManagerHomePage()));
              });
            },
            child: Text("delete"),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(border: Border.all()),
                child: TextField(
                  controller: title,
                  expands: true,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'title',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
