// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors

import 'package:cric_trax/const/app_colors.dart';
import 'package:cric_trax/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../login_screen/login_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: onBoadringList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 120,
                            backgroundColor: AppColors.kGreyColor.withOpacity(0.2),
                          ),
                          Image.asset(
                            onBoadringList[index],
                            width: 200,
                            height: MediaQuery.of(context).size.height * 0.5,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SmoothPageIndicator(
            controller: controller,
            count: 2,
            effect: const WormEffect(
                dotHeight: 12,
                dotWidth: 12,
                dotColor: AppColors.kTextFieldColor,
                activeDotColor: AppColors.kBlackColor),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomButton(
              onTapp: () {
                controller.page == 1
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ))
                    : controller.nextPage(
                        duration: Duration(milliseconds: 600),
                        curve: Curves.easeIn,
                      );
              },
              color: AppColors.kBlackColor,
              text: 'Next',
              
            ),
          ),
          const SizedBox(
            height: kToolbarHeight,
          ),
        ],
      ),
    );
  }

  List onBoadringList = [
    // 'assets/images/on_one.png',
    'assets/images/on_two.png',
    'assets/images/on_three.png',
  ];
}
