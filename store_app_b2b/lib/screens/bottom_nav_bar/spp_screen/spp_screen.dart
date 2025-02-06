import 'package:flutter/material.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen.dart';

class SppScreen extends StatelessWidget {
  const SppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConst.bgColor,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff2F394B),
                Color(0xff090F1A),
              ],
            ),
          ),
        ),
        title: AppText(
          'SPP',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      body: Image.asset(
        'assets/image/spp_coming_soon.png',
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
