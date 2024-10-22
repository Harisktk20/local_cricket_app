// ignore_for_file: unnecessary_import, prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cric_trax/const/app_colors.dart';
import 'package:cric_trax/widget/custom_button.dart';
import 'package:cric_trax/widget/custom_loaders.dart';
import 'package:cric_trax/widget/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../controller/login_controller.dart';
import '../../widget/custom_textfield.dart';
import '../forgot_password_screen/forgot_pasword_screen.dart';
import '../navigation_screen/navigation_screen.dart';
import '../signup_screen/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

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
                key: controller.loginKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: kToolbarHeight),
                    const CustomText(
                      text: 'Welcome Back!',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    CustomTextField(
                      controller: controller.email,
                      validator: (v) {
                        if (v.isEmpty) {
                          return 'Enter Email';
                        }
                      },
                      hinText: 'Enter your email',
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen(),
                              ));
                        },
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomButton(
                        onTapp: () {
                          if (controller.loginKey.currentState!.validate()) {
                            controller.login();

                            //Navigator.push(context, MaterialPageRoute(builder: (context) => const NavigationView()));
                          }
                        },
                        text: 'Login'),
                    const SizedBox(
                      height: 30,
                    ),
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: CustomText(
                            text: 'Or Login with',
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
                        const CustomText(text: "Don't have an Account\t\t"),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  SignUpScreen(),
                              ),
                            );
                          },
                          child: const CustomText(
                            text: "SignUp",
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
