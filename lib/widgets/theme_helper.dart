import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ThemeHelper {
  InputDecoration textInputDecoration([
    String lableText = "",
    String hintText = "",
    IconButton? icon,
  ]) {
    return InputDecoration(
      labelText: lableText,
      hintText: hintText,
      suffixIcon: icon,
      fillColor: Colors.white,
      filled: true,
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.black38)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.black38)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey, width: 2.0)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.red, width: 2.0)),
    );
  }

  BoxDecoration inputBoxDecorationShaddow() {
    return BoxDecoration(boxShadow: [
      BoxShadow(
        color: Colors.brown.withOpacity(0.1),
        //Colors.black.withOpacity(0.1),
        blurRadius: 20,
        offset: const Offset(0, 5),
      )
    ]);
  }

  BoxDecoration buttonBoxDecoration(BuildContext context,
      [String color1 = "", String color2 = ""]) {
    // Get.isDarkMode?Static.PrimaryColor.withOpacity(0.4):Static.PrimaryColor..withOpacity(0.4),
    //Colors.white..withOpacity(0.4),
    Color c1 = Colors.red;
    Color c2 = Colors.black;
    if (color1.isEmpty == false) {
      c1 = HexColor(color1);
    }
    if (color2.isEmpty == false) {
      c2 = HexColor(color2);
    }

    return BoxDecoration(
      boxShadow: [
        BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
      ],
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 1.0],
        colors: [
          c1,
          c2,
        ],
      ),
      color: Colors.deepPurple.shade300,
      borderRadius: BorderRadius.circular(30),
    );
  }

  ButtonStyle buttonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      minimumSize: MaterialStateProperty.all(Size(50, 50)),
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      shadowColor: MaterialStateProperty.all(Colors.transparent),
    );
  }

  AlertDialog alartDialog(String title, String content, BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

// class LoginFormStyle {}
