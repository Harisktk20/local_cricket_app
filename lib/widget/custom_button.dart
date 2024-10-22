import 'package:flutter/material.dart';

import '../const/app_colors.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTapp;
  final String text;
  final Color? color;

  const CustomButton({super.key, required this.onTapp, required this.text, this.color=AppColors.kPrimaryColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.kWhiteColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: color),
        onPressed: onTapp,
        child: CustomText(
          text: text,
          fontSize: 15,
          color: AppColors.kWhiteColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
