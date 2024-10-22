// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../const/firebase_const.dart';
import '../screen/navigation_screen/navigation_screen.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  final loginKey = GlobalKey<FormState>();
  // text controller
  final email = TextEditingController();
  final password = TextEditingController();

  // functions
  Future<void> login() async {
    try {
      isLoading(true);

      await auth.signInWithEmailAndPassword(email: email.text, password: password.text).then((value) {
        isLoading(false);
        Get.offAll(
          () => NavigationScreen(),
        );
        clearField();
        Get.snackbar('Login Successfully', value.user!.email.toString());
      }).onError((error, stackTrace) {
        isLoading(false);
        Get.snackbar('Error', error.toString(), backgroundColor: CupertinoColors.destructiveRed);
      });
    } on FirebaseAuthException catch (e) {
      throw '$e';
    }
  }

  Future<void> sendEmailResetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      Get.back();
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message.toString(), backgroundColor: CupertinoColors.destructiveRed);
    } on FirebaseException catch (e) {
      Get.snackbar('Error', e.message.toString(), backgroundColor: CupertinoColors.destructiveRed);
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: CupertinoColors.destructiveRed);
    }
  }

  clearField() {
    email.clear();
    password.clear();
    update();
  }
}
