import 'package:b2c/components/common_primary_button_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'package:b2c/screens/auth/login_screen_new.dart';
import 'package:b2c/screens/auth/sign_up_2_screen_new.dart';
import 'package:b2c/screens/dashboard_screen/dashboard_screen_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({super.key, this.message = ""});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.symmetric(vertical: 3),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      contentPadding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      content: SizedBox(
        height: 180,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Spacer(),
                const SizedBox(width: 50),
                const AppText(
                  'Login Please',
                  color: AppColors.appblack,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                const Spacer(),
                GestureDetector(
                    // onTap: () => Get.offAll(() => const DashboardScreen()),
                    onTap: () => Get.back(),
                    child: const Icon(Icons.close, color: AppColors.appblack)),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 10),
            AppText(
              "$message You haven't logged in inside of the app.\nTo use this functionality please login the app",
              color: AppColors.appblack,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 25),
              child: CommonPrimaryButton(
                onTap: () => Get.offAll(() => const LoginScreen()),
                text: 'Login',
              ),
            )
          ],
        ),
      ),
    );
  }
}
