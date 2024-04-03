import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login_system/utils/Validations.dart';
import 'package:firebase_login_system/utils/customSnackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../LoginUtils/google_signin.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordNode = FocusNode();

  var isLoading = false.obs;
  var isValidating = false.obs;

  @override
  void initialize() {
    super.initialized;
  }

  signWithGoogle() async {
    isLoading(true);
    var loggedIn = await GoogleLogin().signInWithGoogle();
    if (loggedIn) {
      Get.toNamed("/homepage");
    }
    isLoading(false);
  }

  void validateAndLogin(BuildContext context) {
    if (emailController.value.text.isEmpty) {
      CustomSnackbar().showSnackbar("Please enter email!", context);
      emailNode.requestFocus();
    } else if (!Validations().emailValidator(emailController.text)) {
      CustomSnackbar().showSnackbar("Please enter valid email", context);
      emailNode.requestFocus();
    } else if(passwordController.value.text.isEmpty){
      CustomSnackbar().showSnackbar("Please enter password", context);
      passwordNode.requestFocus();
    } else {
      loginWithEmailPassword(context);
    }
  }

  void loginWithEmailPassword(BuildContext context) async {
    isValidating(true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.value.text,
          password: passwordController.value.text
      );
      Get.toNamed("/homepage");
      isValidating(false);
    } catch(signInError) {
      if(signInError is FirebaseAuthException) {
        print("LoginWithEmailPassword Exception ---> ${signInError.code}");
        if(signInError.code == 'INVALID_LOGIN_CREDENTIALS') {
          CustomSnackbar().showSnackbar("Invalid Login Credentials", context);
        } else if (signInError.code == "too-many-requests"){
          CustomSnackbar().showSnackbar("Too many times tried to login with wrong credentials, Try again later!", context);
        }
      }
      isValidating(false);
    }
  }
}
