import 'package:flutter/material.dart';

class ValidationUtils {
  ValidationUtils._privateConstructor();

  static final ValidationUtils instance = ValidationUtils._privateConstructor();

  //     ======================= Regular Expressions =======================     //
  static const String emailRegExp = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String nameRegExp = r'^[a-zA-Z ]+$';
  static const String numRegExp = r'^[0-9.]+$';
  static const String passwordRegexp =
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{0,}$";

  //     ======================= Validation methods =======================     //
  bool validateEmptyController(TextEditingController textEditingController) {
    return textEditingController.text.trim().isEmpty;
  }

  bool lengthValidator(
      TextEditingController textEditingController, int length) {
    return textEditingController.text.trim().length < length;
  }

  bool regexValidator(
      TextEditingController textEditingController, String regex) {
    return RegExp(regex).hasMatch(textEditingController.text);
  }

  bool compareValidator(TextEditingController textEditingController,
      TextEditingController secondController) {
    return textEditingController.text != secondController.text;
  }
}
