import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller_new.dart';
import 'package:store_app_b2b/new_module/utils/app_utils_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';

class AppDropdown extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.themeController,
    required this.itemsWidth,
    required this.valuesList,
    required this.selectedValue,
    required this.onValueChanged,
    this.containerBorderRadius = 8,
    this.selectedTextAlignment = TextAlign.center,
    this.itemAlignment = Alignment.center,
    this.dropdownIconShowOnSelect = false,
    this.hintText,
    this.hintColor,
    this.borderColor,
    this.containerBorderColor = const Color.fromRGBO(201, 201, 201, 1),
    this.height,
  });

  final ThemeController themeController;
  final double itemsWidth;
  final List<String> valuesList;
  final String? selectedValue;
  final Function(String?) onValueChanged;
  final Color? borderColor;
  final Color containerBorderColor;
  final double containerBorderRadius;
  final Alignment itemAlignment;
  final TextAlign selectedTextAlignment;
  final bool dropdownIconShowOnSelect;
  final Color? hintColor;
  final String? hintText;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: AppText(
          hintText ?? "",
          textAlign: selectedTextAlignment,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          color: themeController.black500Color,
          fontWeight: FontWeight.w400,
        ),
        items: valuesList
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Align(
                      alignment: itemAlignment,
                      child: Text(
                        item,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: AppFont.poppins,
                          color: themeController.black500Color,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (String? value) {
          // selectedMonthValue = value!;
          onValueChanged(value);
        },
        buttonStyleData: ButtonStyleData(
          height: 50,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            border: Border.all(
              color: containerBorderColor,
              width: 1,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            color: themeController.textPrimaryColor,
          ),
          elevation: 0,
        ),
        customButton: Container(
          height: height ?? 50,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            border: Border.all(
              color: containerBorderColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(containerBorderRadius),
            color: borderColor ?? themeController.textPrimaryColor,
          ),
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: AppText(
                    selectedValue == null ? hintText ?? "" : selectedValue!,
                    textAlign: selectedTextAlignment,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    color: hintColor == null
                        ? themeController.black500Color
                        : hintColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                selectedValue == null
                    ? const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color.fromRGBO(156, 163, 175, 1),
                      )
                    : dropdownIconShowOnSelect
                        ? const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color.fromRGBO(156, 163, 175, 1),
                          )
                        : const SizedBox()
              ],
            ),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          elevation: 0,
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          maxHeight: 200,
          width: itemsWidth,
          offset: const Offset(10, 35),
          decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(14),
              color: themeController.textPrimaryColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    spreadRadius: 0,
                    color: Color.fromRGBO(0, 0, 0, 0.25))
              ]),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),

            //mysaa commented - cahgned WidgetStateProperty to MaterialStateProperty
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(
            left: 14,
            right: 14,
          ),
        ),
      ),
    );
  }
}
