import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller_new.dart';
import 'package:store_app_b2b/new_module/utils/app_utils_new.dart';

ThemeController themeController = Get.find();

class AppTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController textEditingController;
  final FloatingLabelBehavior? floatingLabelBehaviour;
  final Color borderColor;
  final double borderWidth;
  final double? labelSize;
  final Color? labelColor;
  final TextInputType? textKeyboardtype;
  final Function()? onTap;
  final bool readOnly;
  final int? maxlenght;
  final List<TextInputFormatter>? formattersList;

  const AppTextField(
      {super.key,
      required this.labelText,
      required this.textEditingController,
      this.floatingLabelBehaviour,
      this.borderColor = const Color.fromRGBO(176, 176, 176, 1),
      this.borderWidth = 0.5,
      this.labelColor,
      this.labelSize,
      this.textKeyboardtype,
      this.onTap,
      this.formattersList,
      this.readOnly = false,
      this.maxlenght});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: textKeyboardtype,
      controller: textEditingController,
      inputFormatters: formattersList ??
          [
            LengthLimitingTextInputFormatter(maxlenght),
          ],
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: labelColor ?? themeController.textSecondaryColor,
          fontFamily: AppFont.poppins,
          fontSize: labelSize ?? 13,
        ),
        floatingLabelBehavior:
            floatingLabelBehaviour ?? FloatingLabelBehavior.always,
        floatingLabelStyle: TextStyle(
          color: themeController.textSecondaryColor,
          fontFamily: AppFont.poppins,
          fontSize: 16,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(
            //hexcode - #B0B0B0
            color: borderColor,
            width: borderWidth,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(
            //hexcode - #B0B0B0
            color: borderColor,
            width: borderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(
            //hexcode - #B0B0B0
            color: borderColor,
            width: borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(
            //hexcode - #B0B0B0
            color: borderColor,
            width: borderWidth,
          ),
        ),
      ),
    );
  }
}
