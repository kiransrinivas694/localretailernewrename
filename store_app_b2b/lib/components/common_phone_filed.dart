import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';

class CommonPhoneField extends StatelessWidget {
  const CommonPhoneField(
      {Key? key,
      required this.controller,
      required this.content,
      this.contentColor,
      this.countryCodeColor})
      : super(key: key);
  final TextEditingController controller;
  final String content;
  final Color? contentColor;
  final Color? countryCodeColor;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          content: content,
          textColor: contentColor ?? Colors.white,
        ),
        SizedBox(height: height * 0.01),
        Container(
          height: 45,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: ColorsConst.semiGreyColor),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: CommonText(
                  content: "+91",
                  textColor: countryCodeColor ?? Colors.white,
                ),
              ),
              SizedBox(width: width * 0.03),
              Container(
                width: 1,
                color: ColorsConst.semiGreyColor,
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.poppins(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "1234567890",
                    hintStyle:
                        GoogleFonts.poppins(color: ColorsConst.hintColor),
                    contentPadding: const EdgeInsets.only(bottom: 5, left: 10),
                    border: InputBorder.none,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
