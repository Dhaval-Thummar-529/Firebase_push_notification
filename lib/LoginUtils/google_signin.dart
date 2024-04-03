import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLogin {

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  signInWithGoogle() async {
    try {
      final googleSingInAccount = await _googleSignIn.signIn();
      if(googleSingInAccount == null){
        return false;
      }
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSingInAccount.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      var currentUser = FirebaseAuth.instance.currentUser;

      var users = FirebaseFirestore.instance.collection("TestUsers");
      var utoken;

      FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance; // Change here
      utoken = await _firebaseMessaging.getToken();

      await users.doc(currentUser!.email).set({
        'deviceToken': utoken,
        'email': currentUser.email,
        'userId': currentUser.uid,
        'createdAt': DateTime.now()
      });

      if (kDebugMode) {
        print("--------Sign In With--------");
        print(currentUser!.email);
        print(currentUser.uid);
        print(currentUser.displayName);
        print("----------------------------");
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("SignIn Exception ---> $e");
      }
      return false;
    }

  }

}
