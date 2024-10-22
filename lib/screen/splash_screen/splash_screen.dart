// ignore_for_file: unused_import, prefer_const_constructors

import 'dart:async';

import 'package:cric_trax/const/app_colors.dart';
import 'package:cric_trax/screen/onboarding_screen/onboarding_screen.dart';
import 'package:cric_trax/screen/started_screen/started_screen.dart';
import 'package:cric_trax/widget/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login_screen/login_screen.dart';
import '../navigation_screen/navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NavigationScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      checkUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.kBgColor,
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset('assets/images/splash_logo.png')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
