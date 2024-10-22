// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../const/app_colors.dart';
import '../../controller/login_controller.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text.dart';
import '../../widget/custom_textfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  TextEditingController email = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: kToolbarHeight),
                const CustomText(
                  text: 'Forgot Password?',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(
                  height: 10,
                ),
                const CustomText(
                  text: 'Please enter the email address linked with your account.',
                  color: AppColors.kGreyColor,
                  fontWeight: FontWeight.w400,
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
                SizedBox(
                  height: 20,
                ),
                CustomButton(
                    onTapp: () {
                      if (formkey.currentState!.validate()) {
                        controller.sendEmailResetPassword(email.text.toString());
                      }
                    },
                    text: 'Reset Password'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
