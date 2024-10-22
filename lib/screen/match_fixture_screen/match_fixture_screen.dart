import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../const/app_colors.dart';
import '../../widget/custom_text.dart';

class MatchFixturesScreen extends StatelessWidget {
  const MatchFixturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
        backgroundColor: AppColors.kPrimaryColor,
        centerTitle: true,
        title: const CustomText(
          text: 'Fixtures',
          fontSize: 16,
          color: AppColors.kWhiteColor,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('fixtures').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var fixtures = snapshot.data!.docs;

          return ListView.builder(
            itemCount: fixtures.length,
            itemBuilder: (context, index) {
              var fixture = fixtures[index];
              return Card(
                color: AppColors.kTextFieldColor,
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(fixture['teamAImage']),
                    radius: 30,
                  ),
                  trailing: CircleAvatar(
                    backgroundImage: NetworkImage(fixture['teamBImage']),
                    radius: 30,
                  ),
                  title: Center(
                    child: CustomText(
                      text: '${fixture['teamAName']} vs ${fixture['teamBName']}',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text: fixture['date'],
                          textAlign: TextAlign.center,
                          fontSize: 12,
                        ),
                        CustomText(
                          text: fixture['time'],
                          fontSize: 12,
                          textAlign: TextAlign.center,
                        ),
                        CustomText(
                          text: fixture['tournament'],
                          fontSize: 15,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
