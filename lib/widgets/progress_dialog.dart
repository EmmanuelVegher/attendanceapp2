import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  String message;
  ProgressDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    Color primary = const Color(0xffeef444c);
    return Dialog(
      //backgroundColor: primary,
      child: Container(
        margin: EdgeInsets.all(0.0),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 1.0],
            colors: [Colors.red, Colors.black],
          ),
          //color:  Get.isDarkMode?Colors.white:Colors.red,
          //borderRadius: BorderRadius.circular(6.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              SizedBox(
                width: 6.0,
              ),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(
                width: 26.0,
              ),
              Text(
                message,
                style: TextStyle(color: Colors.white, fontFamily: "NexaBold"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
