import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_primary_button.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/new_module/screens/cart/cart_labtest_screen.dart';

class UnlistedSoonScreen extends StatefulWidget {
  const UnlistedSoonScreen({super.key});

  @override
  State<UnlistedSoonScreen> createState() => _UnlistedSoonScreenState();
}

class _UnlistedSoonScreenState extends State<UnlistedSoonScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Get.dialog(UnlistedSoonDialog());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          // child: CartLabTestScreen(),
        ),
      ),
    );
  }
}

class UnlistedSoonDialog extends StatelessWidget {
  const UnlistedSoonDialog({super.key, this.message = ""});

  final String message;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        titlePadding: const EdgeInsets.symmetric(vertical: 3),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        contentPadding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        content: Container(
          width: 400,
          padding: EdgeInsets.all(10),
          height: 475,
          child: Column(
            children: [
              CommonText(
                content: "Notification",
                textColor: Color.fromRGBO(255, 122, 0, 1),
                textSize: 20,
                boldNess: FontWeight.w600,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Color.fromRGBO(255, 122, 0, 1),
              ),
              SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/image/unlisted_soon_image.png",
                width: 250,
                height: 250,
                package: 'store_app_b2b',
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 20,
              ),
              CommonText(
                content:
                    '"Revamping for you! Exciting changes ahead for a better experience."',
                textColor: Color.fromRGBO(255, 122, 0, 1),
                textSize: 14,
                textAlign: TextAlign.center,
                boldNess: FontWeight.w600,
              ),
              SizedBox(
                height: 30,
              ),
              CommonPrimaryButton(
                // onTap: () => Get.offAll(() => const LoginScreen()),
                onTap: () {
                  Get.back();
                  Get.back();
                },
                text: 'Go to Home',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
