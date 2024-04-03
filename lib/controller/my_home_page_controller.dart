import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MyHomePageController extends GetxController {

  var userList = [].obs;

  @override
  void onInit() {
    getCollectionData();
  }

  Future<void> getCollectionData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(
        'TestUsers').get();
    List<DocumentSnapshot> documents = querySnapshot.docs;
    for (var document in documents) {
      if (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser!.email != document.id) {
        userList.add(document.id);
      }
      print(document.id); // prints the document ID
    }
  }

}