// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cric_trax/controller/signup_controller.dart';
import 'package:cric_trax/screen/navigation_screen/navigation_screen.dart';
import 'package:cric_trax/widget/custom_loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../const/app_colors.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text.dart';
import '../../widget/custom_textfield.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Obx(
      () => CustomLoader(
        isLoading: controller.isLoading.value,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Form(
                key: controller.signUpKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: kToolbarHeight),
                    const CustomText(
                      text: 'Hello! Register to get started',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    CustomTextField(
                      controller: controller.name,
                      validator: (v) {
                        if (v.isEmpty) {
                          return 'Enter Name';
                        }
                      },
                      hinText: 'Enter your Name',
                    ),
                    CustomTextField(
                      controller: controller.email,
                      validator: (v) {
                        if (v.isEmpty) {
                          return 'Enter Email';
                        }
                      },
                      hinText: 'Enter your Email',
                    ),
                    CustomTextField(
                      controller: controller.password,
                      validator: (v) {
                        if (v.isEmpty) {
                          return 'Enter Password';
                        } else if (v.length < 6) {
                          return 'Password is too short';
                        }
                      },
                      isPasswordField: true,
                      obsecureText: true,
                      hinText: 'Enter your password',
                    ),
                    CustomTextField(
                      controller: controller.confirmpassword,
                      validator: (v) {
                        if (controller.password.text != controller.confirmpassword.text) {
                          return 'Password does not matched';
                        }
                      },
                      isPasswordField: true,
                      obsecureText: true,
                      hinText: 'Confirm Password',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      onTapp: () {
                        if (controller.signUpKey.currentState!.validate()) {
                          controller.signUp();
                        }
                      },
                      text: 'Register',
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: CustomText(
                            text: 'Or Register with',
                            fontSize: 15,
                            color: AppColors.kGreyColor,
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              _handleSignIn();
                            },
                            child: Container(
                              height: 60,
                              margin: const EdgeInsets.only(right: 10, left: 10),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.kGreyColor)),
                              child: Image.asset(
                                'assets/images/google.png',
                                scale: 5,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 60,
                            margin: const EdgeInsets.only(right: 10, left: 10),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.kGreyColor)),
                            child: Image.asset(
                              'assets/images/fb.png',
                              width: 100,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(text: "Already have an Account\t\t"),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: CustomText(
                            text: "Login",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential authResult = await _auth.signInWithCredential(credential);
        final User? user = authResult.user;
        await _storeUserData(user);
        Get.to(
          () => NavigationScreen(),
        );
      }
    } catch (error) {
      print("Error signing in with Google: $error");
    }
  }

  Future<void> _storeUserData(User? user) async {
    if (user != null) {
      try {
        final Map<String, dynamic> userData = {
          'uid': user.uid,
          'name': user.displayName,
          'email': user.email,
          'password': '',
          'image': '',
        };

        await usersCollection.doc(user.uid).set(userData);
      } catch (error) {
        print("Error storing user record: $error");
        // Handle error
      }
    }
  }
}
