// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../const/app_colors.dart';
import '../../widget/custom_text.dart';
import '../edit_profile_screen/edit_profile_screen.dart';
import '../live_mateches_screen/my_videos_screen.dart';
import '../login_screen/login_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColors.kPrimaryColor,
        title: const CustomText(
          text: 'Setting',
          fontSize: 16,
          color: AppColors.kWhiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: kToolbarHeight / 2,
              ),
              Row(
                children: [
                  image == ''
                      ? const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/images/p2.jpeg'),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                            imageUrl: image.toString(),
                            placeholder: (context, url) => Container(
                              width: 10,
                              height: 10,

                              color: AppColors.kBgColor.withOpacity(0.2), // Placeholder background color
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.kPrimaryColor,
                                  // Loader color
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.downloading),
                          ),
                        ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name ?? 'User Name',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          email ?? 'user@gmail.com',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Get.to(
                          () => EditProfileScreen(
                            image: image.toString(),
                            name: name.toString(),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit)),
                ],
              ),
              Divider(),
              SizedBox(height: 20),
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tileColor: AppColors.kBgColor,
                title: Text('Logout'),
                trailing: Icon(Icons.logout_outlined),
                onTap: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    return Get.offAll(() => LoginScreen());
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tileColor: AppColors.kBgColor,
                title: Text('My Videos'),
                trailing: Icon(Icons.video_camera_front_rounded),
                onTap: () {
                  Get.to(() => MyVideoScreen());
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  String? email;

  String? name;
  String? image;

  getCurrentUser() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      setState(() {});
      name = documentSnapshot.get('name');
      email = documentSnapshot.get('email');
      image = documentSnapshot.get('image');
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
}
