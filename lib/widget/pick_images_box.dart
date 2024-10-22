// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/app_colors.dart';
import 'custom_button.dart';

class PickImagesBox extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  const PickImagesBox({super.key, required this.onCamera, required this.onGallery});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 222,
      width: double.infinity,
      child: Card(
        color: AppColors.kGreyColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: onCamera,
                          child: Container(
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.kWhiteColor),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              color: AppColors.kBgColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Camera',
                          style: context.textTheme.labelLarge!.copyWith(color: AppColors.kWhiteColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: onGallery,
                          child: Container(
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.kWhiteColor,
                            ),
                            child: Icon(
                              Icons.photo_camera_back_rounded,
                              color: AppColors.kBgColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Gallery',
                          style: context.textTheme.labelLarge!.copyWith(color: AppColors.kWhiteColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              CustomButton(
                text: 'Cancel',
                onTapp: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
