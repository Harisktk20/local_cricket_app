// ignore_for_file: prefer_const_constructors

import 'package:cric_trax/const/app_colors.dart';
import 'package:cric_trax/screen/login_screen/login_screen.dart';
import 'package:cric_trax/screen/onboarding_screen/onboarding_screen.dart';
import 'package:flutter/material.dart';

import '../../widget/custom_button.dart';

class StartedScreen extends StatelessWidget {
  const StartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 120,
                      backgroundColor: AppColors.kGreyColor.withOpacity(0.2),
                    ),
                    Image.asset(
                      'assets/images/on_one.png',
                      width: 200,
                      height: MediaQuery.of(context).size.height * 0.5,
                    ),
                  ],
                ),
                SizedBox(height: kToolbarHeight *2),
                CustomButton(
                  text: 'Get Started',
                  onTapp: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OnBoardingScreen(),
                      ),
                    );
                  },
                  color: AppColors.kBlackColor,
                ),
                SizedBox(height: 10),
                CustomButton(
                  text: 'Login',
                  onTapp: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  color: AppColors.kBlackColor,
                ),
                SizedBox(height: kToolbarHeight / 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
