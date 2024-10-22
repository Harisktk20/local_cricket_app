// ignore_for_file: unnecessary_import, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/firebase_const.dart';
import '../screen/navigation_screen/navigation_screen.dart';

class SignupController extends GetxController {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmpassword = TextEditingController();
  var isLoading = false.obs;
  final signUpKey = GlobalKey<FormState>();


  Future<void> signUp() async {
    try {
      isLoading(true);
      await auth.createUserWithEmailAndPassword(email: email.text, password: password.text);

      await firebaseFirestore.collection('users').doc(auth.currentUser!.uid).set({
        'uid': auth.currentUser!.uid,
        'name': name.text,
        'email': email.text,
        'password': password.text,
        'image': '',
      });

      isLoading(false);
      Get.to(NavigationScreen());
      Get.snackbar('Account Created', 'Congratulation account is created');
    } on FirebaseAuthException catch (e) {
      isLoading(false);
      Get.snackbar('Error', e.toString(), backgroundColor: CupertinoColors.destructiveRed);
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', 'An unexpected error occurred', backgroundColor: CupertinoColors.destructiveRed);
    }
  }
}
