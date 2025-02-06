import 'package:b2c/constants/colors_const.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Device.height,
      width: Device.width,
      decoration: BoxDecoration(color: AppColors.appWhite.withOpacity(0.6)),
      child:
          LoadingAnimationWidget.beat(color: AppColors.appWhite, size: 40.px),
    );
  }
}
