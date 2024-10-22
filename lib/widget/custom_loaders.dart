// ignore_for_file: prefer_const_constructors_in_immutables, use_super_parameters, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../const/app_colors.dart';

class CustomLoader extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  CustomLoader({Key? key, required this.isLoading, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      color: AppColors.kPrimaryColor,
      opacity: 0.5,
      progressIndicator: SpinKitFoldingCube(
        //trackColor: AppColors.kSecondary,
        //waveColor: AppColors.kPrimary,

        color: AppColors.kBgColor,

        duration: Duration(seconds: 3),
        size: 50,
      ),
      child: child,
    );
  }
}
