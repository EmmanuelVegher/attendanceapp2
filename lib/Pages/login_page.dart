import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:attendanceapp/Pages/Dashboard/super_admin_dashboard.dart';
import 'package:attendanceapp/Pages/auth_exceptions.dart';
import 'package:attendanceapp/Pages/forgot_password.dart';
import 'package:attendanceapp/Pages/register_page.dart';
import 'package:attendanceapp/Pages/routing.dart';
import 'package:attendanceapp/controllers/login_controller.dart';
import 'package:attendanceapp/model/attendancemodel.dart';
import 'package:attendanceapp/model/bio_model.dart';
import 'package:attendanceapp/model/locationmodel.dart';
import 'package:attendanceapp/model/statemodel.dart';
import 'package:attendanceapp/services/database_adapter.dart';
import 'package:attendanceapp/services/hive_service.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:attendanceapp/widgets/constants.dart';
import 'package:attendanceapp/widgets/header_widget.dart';
import 'package:attendanceapp/widgets/progress_dialog.dart';
import 'package:attendanceapp/widgets/show_error_dialog.dart';
import 'package:attendanceapp/widgets/theme_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore_for_file: avoid_print

class LoginPage extends StatelessWidget {
  final IsarService service;

  LoginPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    // Access screen width and height
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final LoginController loginController = Get.put(LoginController()); // Correct initialization
    loginController.service = service; // Pass 'service' in onInit

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.35, // 35% of screen height
              child: HeaderWidget(screenHeight * 0.35, true, Icons.login_rounded),
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // 5% horizontal padding
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02), // 5% horizontal, 2% vertical margin
                child: Column(
                  children: [
                    Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: screenWidth * 0.08, // Responsive font size
                        fontWeight: FontWeight.bold,
                        fontFamily: "NexaBold",
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01), // Responsive SizedBox height
                    Text(
                      "Sign-In into your account",
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "NexaBold",
                        fontSize: screenWidth * 0.04, // Responsive font size
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03), // Responsive SizedBox height
                    Form(
                      key: loginController.formKey,
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Email Address",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: screenWidth * 0.035, // Responsive font size
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01), // Responsive SizedBox height
                              Container(
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextFormField(
                                  controller: loginController.emailAddressController,
                                  decoration: ThemeHelper().textInputDecoration(
                                    "",
                                    "Enter your email",
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.email,
                                        color: Colors.black54,
                                        size: screenWidth * 0.05, // Responsive icon size
                                      ),
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (val) {
                                    // ... (Email validation logic remains the same)
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02), // Responsive SizedBox height
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Password**",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: screenWidth * 0.035, // Responsive font size
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01), // Responsive SizedBox height
                              Obx(() => Container(
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextFormField(
                                  controller: loginController.passwordController,
                                  obscureText: loginController.isObscure.value,
                                  decoration: ThemeHelper().textInputDecoration(
                                    "",
                                    "Enter your Password**",
                                    IconButton(
                                      onPressed: loginController.togglePasswordVisibility,
                                      icon: Icon(
                                        loginController.isObscure.value ? Icons.visibility : Icons.visibility_off,
                                        color: Colors.black54,
                                        size: screenWidth * 0.05, // Responsive icon size
                                      ),
                                    ),
                                  ),
                                  validator: (value) => value != null && value.isEmpty
                                      ? 'Enter Password'
                                      : null,
                                ),
                              )),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: screenHeight * 0.01, right: screenWidth * 0.025),
                            alignment: Alignment.topRight,
                            child: TextButton(
                              child: Text(
                                "Forgot your password?",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: screenWidth * 0.035
                                ),
                              ),
                              onPressed: () => Get.to(() => ForgotPasswordPage()),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02), // Responsive SizedBox height
                          Container(
                            decoration: ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              onPressed: () => loginController.handleLogin(context, service),
                              style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding:  EdgeInsets.symmetric(vertical: screenHeight * 0.015, horizontal: screenWidth * 0.1), // Responsive padding
                                child: Text(
                                  "Sign In".toUpperCase(),
                                  style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin:  EdgeInsets.fromLTRB(10, screenHeight * 0.02, 10, screenHeight * 0.04), // Responsive margin
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(text: "Don't have an account? "),
                                  TextSpan(
                                    text: "Register",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Get.to(() => RegistrationPage()),
                                    style: TextStyle(
                                      fontFamily: "NexaBold",
                                      color: Colors.red,
                                      fontSize: screenWidth * 0.035, // Responsive font size
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}