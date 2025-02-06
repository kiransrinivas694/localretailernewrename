import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';

final ThemeController themeController = Get.find();

class AppSearchBox extends StatelessWidget {
  const AppSearchBox(
      {super.key,
      required this.textEditingController,
      this.hintText = "Search",
      this.onChange,
      this.boxShadow,
      this.showSuffixIcon = false,
      this.boxHeight,
      this.onSuffixIconTap,
      this.enabled,
      this.focusNode});

  final TextEditingController textEditingController;
  final String hintText;
  final BoxShadow? boxShadow;
  final double? boxHeight;
  final bool showSuffixIcon;
  final bool? enabled;
  final Function(String)? onChange;
  final VoidCallback? onSuffixIconTap;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: boxHeight ?? 50,
      // margin: EdgeInsets.fromLTRB(20, 16, 20, 10),
      padding: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        boxShadow: [
          boxShadow ??
              const BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.15),
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(0, 0),
              ),
        ],
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: TextField(
        onChanged: onChange,
        enabled: enabled,
        focusNode: focusNode ?? null,
        controller: textEditingController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          prefixIcon: Icon(
            Icons.search,
            color: themeController.black100Color,
            size: 22,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16,
            color: themeController.black100Color,
            fontWeight: FontWeight.w400,
            fontFamily: AppFont.poppins,
          ),
          suffixIcon: showSuffixIcon
              ? GestureDetector(
                  onTap: onSuffixIconTap,
                  child: const Icon(
                    Icons.close,
                    color: Colors
                        .black, // Replace with your themeController.black75Color
                    size: 26,
                  ),
                )
              : null,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
