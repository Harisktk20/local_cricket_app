// ignore_for_file: unnecessary_import, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../const/app_colors.dart';
import '../../../widget/custom_text.dart';

class MenuCard extends StatelessWidget {
  final String menuName;
  final IconData iconData;
  final VoidCallback? onTapp;

  const MenuCard({super.key, required this.menuName, required this.iconData, this.onTapp});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 125,
        child: InkWell(
          onTap: onTapp,
          child: Card(
            color: AppColors.kTextFieldColor,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    iconData,
                    color: AppColors.kBlackColor,
                    size: 40,
                  ),
                  CustomText(
                    text: menuName,
                    fontSize: 14,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
