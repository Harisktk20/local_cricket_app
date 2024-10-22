// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cric_trax/const/app_colors.dart';
import 'package:cric_trax/screen/create_fixture_screen/create_fixture-screen.dart';
import 'package:cric_trax/screen/create_tournment/create_tournment.dart';
import 'package:cric_trax/screen/edit_profile_screen/edit_profile_screen.dart';
import 'package:cric_trax/screen/home_screen/home_screen_widget/team_match_card.dart';
import 'package:cric_trax/screen/setting_screen/setting_screen.dart';
import 'package:cric_trax/widget/custom_text.dart';
import 'package:cric_trax/widget/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../live_matches_screen/live_matches_screen.dart';
import '../match_fixture_screen/match_fixture_screen.dart';
import '../searxh_screen/search_screen.dart';
import '../upload_video_screen/upload_video_screen.dart';
import '../watch_screen/watch_screen.dart';
import 'home_screen_widget/menu_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _regPlayerID();
  }

  final storage = FlutterSecureStorage();

  _regPlayerID() async {
    final tokenID = OneSignal.User.pushSubscription.id;
    if (tokenID != null) {
      String palyeriD = await storage.read(key: "playerID") ?? "";
      if (palyeriD != tokenID) {
        ///update token in firebase
        FirebaseFirestore.instance.collection('tokens').doc(FirebaseAuth.instance.currentUser!.uid).set({
          'id': tokenID,
        }, SetOptions(merge: true)).then((value) {
          storage.write(key: "playerID", value: tokenID);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
        backgroundColor: AppColors.kPrimaryColor,
        centerTitle: true,
        title: const CustomText(
          text: 'Home',
          fontSize: 16,
          color: AppColors.kWhiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: kToolbarHeight,
                ),
                CustomTextField(
                  controller: searchedController,
                  hinText: 'Search Fixture',
                  onFieldSubmitted: (v) {
                    searchedController.text = v;
                    if (searchedController.text.isNotEmpty) {
                      Get.to(() => SearchScreen(
                        searchField : searchedController.text,
                      ));
                    }
                  },

                ),
                // CustomTextField(
                //   suffixIcon: Icons.search_sharp,
                //   hinText: 'Search',
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: 'Upcoming Match',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => MatchFixturesScreen());
                      },
                      child: const Text('View All'),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('fixtures').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // var fixtures = snapshot.data!.docs;
                    // var now = DateTime.now();
                    // var formatter = DateFormat('yyyy-MM-dd HH:mm');
                    //
                    // var filteredFixtures = fixtures.where((fixture) {
                    //   try {
                    //     var fixtureDate = formatter.parse(fixture['date']);
                    //     var difference = fixtureDate.difference(now).inDays;
                    //     return difference <= 3 && difference >= 0;
                    //   } catch (e) {
                    //     print('Error parsing date: $e');
                    //     return false;
                    //   }
                    // }).toList();
                    DateTime now = DateTime.now();
                    DateTime threeDaysFromNow = now.add(Duration(days: 3));
                    List<QueryDocumentSnapshot> filteredDocs = snapshot.data!.docs.where((doc) {
                      String eventDateString = doc['date'];
                      DateTime eventDate = DateTime.parse(eventDateString);
                      return eventDate.isAfter(now) && eventDate.isBefore(threeDaysFromNow);
                    }).toList();
                    if (filteredDocs.isEmpty) {
                      return Center(
                        child: Text(
                          'No Upcoming Tournaments within the next 3 days!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                //color: dark ? Colors.white54 : Colors.black,
                              ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredDocs.length,
                      itemBuilder: (context, index) {
                        var fixture = filteredDocs[index];
                        return TeamMatchCards(
                          teamA: fixture['teamAName'],
                          teamB: fixture['teamBName'],
                          date: fixture['date'],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const CustomText(
                  text: 'Menu',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    MenuCard(
                      iconData: Icons.sports_cricket,
                      menuName: 'Create Tournament',
                      onTapp: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateTournamentScreen(),
                            ));
                      },
                    ),
                    MenuCard(
                      iconData: Icons.sports_basketball,
                      menuName: 'Create Fixture',
                      onTapp: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateFixtureScreen(),
                            ));
                      },
                    ),
                    MenuCard(
                      iconData: Icons.live_tv,
                      menuName: 'Live\nMatch',
                      onTapp: () {
                        Get.to(() => LiveMatcheScreen());
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    MenuCard(
                      iconData: Icons.man,
                      menuName: 'Match Fixture',
                      onTapp: () {
                        Get.to(() => MatchFixturesScreen());
                      },
                    ),
                    MenuCard(
                      iconData: Icons.video_call,
                      menuName: 'Watch Videos',
                      onTapp: () {
                        Get.to(() => WatchScreen());
                      },
                    ),
                    MenuCard(
                      iconData: Icons.upload,
                      menuName: 'Upload Video',
                      onTapp: () {
                        Get.to(() => UploadVideoScreen());
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    MenuCard(
                      iconData: Icons.account_circle,
                      menuName: 'My Profile',
                      onTapp: () {
                        Get.to(() => EditProfileScreen(image: '', name: ''));
                      },
                    ),
                    MenuCard(
                      iconData: Icons.settings,
                      menuName: 'Settings',
                      onTapp: () {
                        Get.to(() => SettingScreen());
                      },
                    ),
                    Expanded(child: SizedBox()),
                    // MenuCard(iconData: Icons.notifications, menuName: 'Notification'),
                  ],
                ),
                SizedBox(
                  height: kToolbarHeight / 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



