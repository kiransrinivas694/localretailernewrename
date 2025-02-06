import 'package:flutter/material.dart';

class AppVerifyScreen extends StatelessWidget {
  const AppVerifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/image/verify_bg.png"),
            ),
          ),
          child: Center(
            child: Image.asset("assets/image/success.png", scale: 2),
          ),
        ),
      ),
    );
  }
}
