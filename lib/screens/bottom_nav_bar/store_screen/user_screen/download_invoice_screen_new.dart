import 'package:flutter/material.dart';
import 'package:b2c/components/common_text_new.dart';

class DownloadInvoiceScreen extends StatelessWidget {
  const DownloadInvoiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: CommonText(
            content: "Download Invoice",
            boldNess: FontWeight.w600,
            textSize: width * 0.047,
          ),
          elevation: 0,
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
        ),
        body: Column(
          children: [
            SizedBox(height: height * 0.02),
            Center(
              child: Container(
                height: height / 1.5,
                child: Image.asset("assets/image/invoice.png"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  fixedSize: Size(width, 45),
                  side: const BorderSide(color: Colors.black),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.download, color: Colors.black),
                    SizedBox(width: width * 0.02),
                    CommonText(
                      content: "Download",
                      textSize: width * 0.035,
                      textColor: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
