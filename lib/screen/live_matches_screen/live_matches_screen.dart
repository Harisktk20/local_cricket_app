// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cric_trax/const/app_colors.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../widget/custom_text.dart';
//
// class LiveMatcheScreen extends StatelessWidget {
//   const LiveMatcheScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
//         backgroundColor: AppColors.kPrimaryColor,
//         centerTitle: true,
//         title: CustomText(
//           text: 'Live Matches/ Tournments',
//           fontSize: 16,
//           color: AppColors.kWhiteColor,
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('tournaments').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           var tournaments = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: tournaments.length,
//             itemBuilder: (context, index) {
//               var tournament = tournaments[index];
//               return Card(
//                 margin: const EdgeInsets.all(10),
//                 child: ListTile(
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   tileColor: AppColors.kPrimaryColor,
//                   title: Text(
//                     tournament['name'],
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text.rich(TextSpan(children: [
//                         TextSpan(text: 'City :', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white38)),
//                         TextSpan(
//                             text: '${tournament['city']}',
//                             style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.kWhiteColor)),
//                       ])),
//                       Text.rich(TextSpan(children: [
//                         TextSpan(
//                             text: 'Country :', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white38)),
//                         TextSpan(
//                             text: '${tournament['country']}',
//                             style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.kWhiteColor)),
//                       ])),
//                       Text.rich(TextSpan(children: [
//                         TextSpan(
//                             text: 'Start Date :', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white38)),
//                         TextSpan(
//                             text: '${tournament['startDate']}',
//                             style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.kWhiteColor)),
//                       ])),
//                     ],
//                   ),
//                   trailing: IconButton(
//                     icon: Icon(
//                       CupertinoIcons.play_circle,
//                       color: Colors.red,
//                     ),
//                     onPressed: () {
//                       _launchURL(tournament['youtubeLink']);
//                     },
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   void _launchURL(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
// }
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cric_trax/const/app_colors.dart';

import '../../widget/custom_text.dart';

class LiveMatcheScreen extends StatelessWidget {
  const LiveMatcheScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
        backgroundColor: AppColors.kPrimaryColor,
        centerTitle: true,
        title: const CustomText(
          text: 'Tournaments',
          fontSize: 16,
          color: AppColors.kWhiteColor,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tournaments').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var tournaments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tournaments.length,
            itemBuilder: (context, index) {
              var tournament = tournaments[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: AppColors.kBlackColor,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(TextSpan(children: [
                        const TextSpan(
                            text: 'City :', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white38)),
                        TextSpan(
                            text: '${tournament['city']}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.kWhiteColor)),
                      ])),
                      Text.rich(TextSpan(children: [
                        const TextSpan(
                            text: 'Country :', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white38)),
                        TextSpan(
                            text: '${tournament['country']}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.kWhiteColor)),
                      ])),
                      Text.rich(TextSpan(children: [
                        const TextSpan(
                            text: 'Start Date :', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white38)),
                        TextSpan(
                            text: '${tournament['startDate']}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.kWhiteColor)),
                      ])),
                    ],
                  ),
                  title: Text(tournament['name']),
                  trailing: IconButton(
                    icon: const Icon(Icons.video_library, color: AppColors.kBgColor),
                    onPressed: () {
                      _launchURL(tournament['youtubeLink']);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
