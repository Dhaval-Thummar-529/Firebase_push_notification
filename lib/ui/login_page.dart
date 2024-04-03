import 'package:firebase_login_system/LoginUtils/google_signin.dart';
import 'package:firebase_login_system/controller/loginController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text("Test Login App"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller.emailController,
              focusNode: controller.emailNode,
              style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                label: const Text("Email"),
                hintText: "jon.doe@gmail.com",
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              obscureText: true,
              controller: controller.passwordController,
              focusNode: controller.passwordNode,
              style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                label: const Text("Password"),
                hintText: "**********",
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => controller.isValidating.value
                  ? CircularProgressIndicator(
                      color: Colors.blue.shade800,
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(250, 50),
                      ),
                      onPressed: () {
                        controller.validateAndLogin(context);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  width: 2,
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      primary: Colors.transparent,
                      splashFactory: NoSplash.splashFactory),
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                        color: Colors.blue.shade800,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.blue.shade800,
                    height: 1,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "OR",
                  style: TextStyle(
                      color: Colors.blue.shade800,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    color: Colors.blue.shade800,
                    height: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => controller.isLoading.value
                  ? CircularProgressIndicator(
                      color: Colors.blue.shade800,
                    )
                  : SignInButton(
                      Buttons.google,
                      text: "Sign up with Google",
                      onPressed: () async {
                        await controller.signWithGoogle();
                      },
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
