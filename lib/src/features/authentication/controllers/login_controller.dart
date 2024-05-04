

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();

   void login() {
    String userEmail = email.text.trim();
    String userPassword = password.text.trim();
    AuthRepository.instance.loginUserWithEmailAndPassword(userEmail, userPassword);
  }
  
}