import 'package:cric_trax/const/app_colors.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final Color? color;

  const CustomText(
      {super.key,
      required this.text,
      this.fontSize = 14,
      this.fontWeight = FontWeight.w400,
      this.textAlign = TextAlign.start,
      this.color = AppColors.kBlackColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
