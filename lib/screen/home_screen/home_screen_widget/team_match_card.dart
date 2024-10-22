// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../const/app_colors.dart';
import '../../../widget/custom_text.dart';

class TeamMatchCards extends StatelessWidget {
  final String teamA;
  final String teamB;
  final String date;

  TeamMatchCards({
    super.key,
    required this.teamA,
    required this.teamB,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.kGreyColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.sports_cricket, color: AppColors.kPrimaryColor),
          Spacer(),
          CustomText(
            text: '$teamA\t\t',
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          CustomText(
            text: 'VS',
            fontWeight: FontWeight.w400,
          ),
          CustomText(
            text: '\t\t$teamB',
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
          Spacer(),
          Card(
            color: AppColors.kPrimaryColor,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CustomText(
                text: date,
                fontSize: 12,
                color: AppColors.kWhiteColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
