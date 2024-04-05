import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login_system/controller/my_home_page_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final MyHomePageController controller = Get.put(MyHomePageController());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Login App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            buildUserList(),
            /*ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade100),
              onPressed: () async {
                await signOut();
              },
              child: Text(
                "Sign Out",
                style: TextStyle(
                    color: Colors.blue.shade800,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            )*/
          ],
        ),
      ),
    );
  }

  signOut() async {
    try {
      await GoogleSignIn().disconnect();
      await FirebaseAuth.instance.signOut();
      Get.offAndToNamed("/loginScreen");
    } catch (e) {
      if (kDebugMode) {
        print("SignOut Exception ---> $e");
      }
    }
  }

  buildUserList() {
    return Obx(() => controller.userList.value.isNotEmpty
        ? ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.userList.value[index],
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  GestureDetector(
                      onTap: () {
                        controller.getDocumentData(controller.userList.value[index]);
                      }, child: const Icon(Icons.notifications)),
                ],
              );
            },
            itemCount: controller.userList.value.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                thickness: 1,
              );
            },
          )
        : Container());
  }
}
