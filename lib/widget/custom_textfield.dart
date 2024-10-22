// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';

import '../const/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hinText;
  final TextEditingController? controller;
  bool obsecureText;
  final ValueChanged<String>? onValueChanged;
  final Function(String)? validator;
  bool isPasswordField;
  final IconData? suffixIcon;
  final ValueChanged<String>? onFieldSubmitted;

  CustomTextField(
      {super.key,
        this.validator,
        this.onValueChanged,
      required this.hinText,
      this.controller,
      this.obsecureText = false,
      this.isPasswordField = false,
        this.onFieldSubmitted,
      this.suffixIcon});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        onFieldSubmitted: widget.onFieldSubmitted,
        onChanged: widget.onValueChanged,
        validator: (val) => widget.validator!(val!),
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        cursorHeight: 25,
        cursorColor: AppColors.kGreyColor,
        obscureText: widget.obsecureText,
        controller: widget.controller,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: AppColors.kTextFieldColor,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.kGreyColor.withOpacity(0.2))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.kGreyColor.withOpacity(0.2))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.kGreyColor.withOpacity(0.4))),
          hintText: widget.hinText,
          hintStyle: const TextStyle(color: AppColors.kGreyColor, fontWeight: FontWeight.w400),
          suffixIcon: widget.isPasswordField
              ? InkWell(
                  onTap: () {
                    setState(() {
                      widget.obsecureText = !widget.obsecureText;
                    });
                  },
                  child: Icon(
                    widget.obsecureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.kGreyColor,
                  ),
                )
              : Icon(
                  widget.suffixIcon,
                  size: 24,
                ),
        ),
      ),
    );
  }
}
