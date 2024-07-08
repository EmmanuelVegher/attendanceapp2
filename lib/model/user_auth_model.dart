import 'package:flutter/material.dart';

class UserAuthModel {
  String user;
  String password;

  UserAuthModel({required this.user, required this.password});

  static UserAuthModel fromDB(String dbuser) {
    return new UserAuthModel(
        user: dbuser.split(':')[0], password: dbuser.split(':')[1]);
  }
}
