import 'package:b2c/constants/colors_const_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget commonCheckBox(
    {Color? activeColor,
    required RxBool value,
    ValueChanged<bool?>? onChanged}) {
  return StatefulBuilder(
    builder: (context, newState) => Checkbox(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        activeColor: activeColor ?? AppColors.primaryColor,
        value: value.value,
        onChanged: onChanged ??
            (val) {
              newState(() {
                value.value = !value.value;
              });
            }),
  );
}
