// ignore_for_file: unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../const/app_colors.dart';
import '../../widget/custom_text.dart';
import '../../widget/custom_textfield.dart';

class LiveMatchesScreen extends StatelessWidget {
  const LiveMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
        backgroundColor: AppColors.kPrimaryColor,
        centerTitle: true,
        title: const CustomText(
          text: 'Watch',
          fontSize: 16,
          color: AppColors.kWhiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CustomTextField(
                suffixIcon: Icons.search_sharp,
                hinText: 'Search',
              ),
              for (int i = 0; i < 3; i++)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                          fit: BoxFit.cover, image: AssetImage('assets/images/watch_cric_image.png')),
                      color: AppColors.kGreyColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Spacer(),
                        Icon(
                          Icons.play_arrow,
                          size: 50,
                          color: AppColors.kBlackColor,
                        ),
                        Spacer(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            text: 'Kohat League',
                            fontSize: 14,
                            color: AppColors.kWhiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(
                height: kToolbarHeight * 1.4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
