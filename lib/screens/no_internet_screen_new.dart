import 'package:b2c/components/common_text_new.dart';
import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color.fromRGBO(236, 240, 243, 1),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/image/no_internet.png",
                    scale: 4,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const CommonText(
                    content: "Oops!",
                    textSize: 24,
                    textColor: Color.fromRGBO(139, 136, 136, 1),
                  ),
                  const CommonText(
                    content: "No Internet Connection",
                    textSize: 24,
                    textAlign: TextAlign.center,
                    textColor: Color.fromRGBO(139, 136, 136, 1),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
