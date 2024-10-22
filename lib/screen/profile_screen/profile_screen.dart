// ignore_for_file: unnecessary_import, unused_import

import 'package:cric_trax/const/app_colors.dart';
import 'package:cric_trax/screen/edit_profile_screen/edit_profile_screen.dart';
import 'package:cric_trax/widget/custom_text.dart';
import 'package:cric_trax/widget/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../login_screen/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          image: DecorationImage(fit: BoxFit.contain, image: AssetImage('assets/images/afridi.png'))),
                      child: Column(
                        children: [
                          const SizedBox(height: kToolbarHeight * 1.5),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) =>
                                //     ));
                              },
                              color: AppColors.kWhiteColor,
                              icon: const Icon(Icons.edit),
                            ),
                          ),
                          const CircleAvatar(
                            radius: 35,
                            backgroundImage: AssetImage('assets/images/profile_pic.png'),
                          ),
                          const CustomText(
                            text: 'Shahid Afridi',
                            color: AppColors.kWhiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          const CustomText(
                            text: '03123456778',
                            color: AppColors.kWhiteColor,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    color: AppColors.kWhiteColor,
                  )),
                ],
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(right: 20, left: 20, top: 100),
                  decoration: BoxDecoration(color: AppColors.kTextFieldColor, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        trailing: Icon(Icons.phone),
                        title: CustomText(
                          text: 'Phone Number',
                        ),
                      ),
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        trailing: Icon(Icons.email),
                        title: CustomText(
                          text: 'Email',
                        ),
                      ),
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        trailing: Icon(Icons.key),
                        title: CustomText(
                          text: 'Password',
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        trailing: Transform.scale(
                          scale: 0.8,
                          child: Switch(
                              value: isSwitched,
                              onChanged: (v) {
                                setState(() {
                                  isSwitched = v;
                                });
                              }),
                        ),
                        title: const CustomText(
                          text: 'Notification',
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          FirebaseAuth.instance.signOut().then((value) {
                            return Get.offAll(() => LoginScreen());
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                        trailing: const Icon(Icons.logout),
                        title: const CustomText(
                          text: 'Logout',
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  bool isSwitched = false;
}
