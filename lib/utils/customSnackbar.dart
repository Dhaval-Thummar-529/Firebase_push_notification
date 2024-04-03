import 'package:flutter/material.dart';

class CustomSnackbar {
  void showSnackbar(label, context) {
    final snackbar = SnackBar(
      backgroundColor: Colors.blue.shade300,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      behavior: SnackBarBehavior.floating,
      content: Center(child: Text(label, style: const TextStyle(color: Colors.black,), textAlign: TextAlign.center,)),
      duration: const Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
