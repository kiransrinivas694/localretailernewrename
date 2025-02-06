import 'dart:io';
import 'dart:ui';

import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/controllers/delivery_controller_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:b2c/widget/app_image_assets_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../constants/colors_const_new.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const CommonText(
          content: "Delivery",
          boldNess: FontWeight.w600,
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: AppColors.appGradientColor,
            ),
          ),
        ),
      ),
      body: GetBuilder(
          init: DeliveryController(),
          initState: (state) {
            Future.delayed(const Duration(microseconds: 300),
                () => Get.find<DeliveryController>().getRiders());
          },
          builder: (DeliveryController deliveryController) {
            return Stack(
              alignment: Alignment.center,
              children: [
                ListView(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.semiGreyColor.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.all(15),
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () => cameraOptions(),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 10.0,
                                      left: 8.0,
                                      right: 8.0),
                                  child: Center(
                                    child: Container(
                                      height: 112,
                                      width: 112,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          color: AppColors.greyBgColor,
                                          shape: BoxShape.circle),
                                      child: (deliveryController.profileImage ==
                                                  null ||
                                              deliveryController
                                                  .profileImage!.isEmpty)
                                          ? const Icon(
                                              Icons.camera_alt_outlined,
                                              size: 25)
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(500),
                                              child: Image.file(
                                                File(deliveryController
                                                    .profileImage!),
                                                height: 112,
                                                width: 112,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("First Name:"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  style: const TextStyle(
                                      height: 1, color: Colors.black),
                                  controller: deliveryController.txtFirstName,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    hintText: "Enter First Name",
                                    hintStyle: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto-Regular',
                                        color: Color(0xFFAAAAAA)),
                                    filled: true,
                                    fillColor: const Color(0xFFFFFFFF),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        12, 20, 12, 20),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF36EB9F))),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'First Name is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("Last Name:"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  style: const TextStyle(
                                      height: 1, color: Colors.black),
                                  controller: deliveryController.txtLastName,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    hintText: "Enter Last Name",
                                    hintStyle: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto-Regular',
                                        color: Color(0xFFAAAAAA)),
                                    filled: true,
                                    fillColor: const Color(0xFFFFFFFF),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        12, 20, 12, 20),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF36EB9F))),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Last Name is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("Date of Birth"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  style: const TextStyle(
                                      height: 1, color: Colors.black),
                                  controller: deliveryController.txtDateOfBirth,
                                  readOnly: true,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "dd-mm-yyyy",
                                    hintStyle: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Roboto-Regular',
                                      color: Color(0xFFAAAAAA),
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFFFFFFF),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        12, 20, 12, 20),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF36EB9F))),
                                    suffixIconConstraints: const BoxConstraints(
                                        minWidth: 40, maxHeight: 20),
                                    suffixIcon: Image.network(
                                      'https://www.oneinsure.com/assets/bi/images/FlutterOneinsureimg/OI-PNG-Icons/calendar01.png',
                                      color: const Color(0xFFAAAAAA),
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return const SizedBox();
                                      },
                                    ),
                                  ),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.utc(1960),
                                      lastDate: DateTime.now(),
                                    );
                                    if (pickedDate != null) {
                                      var formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                      setState(() {
                                        deliveryController.txtDateOfBirth.text =
                                            formattedDate;
                                      });
                                    } else {
                                      print("Date is not selected");
                                    }
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Date of birth is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("Join Date"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  style: const TextStyle(
                                      height: 1, color: Colors.black),
                                  controller: deliveryController.txtJoinDate,
                                  readOnly: true,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "dd-mm-yyyy",
                                    hintStyle: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Roboto-Regular',
                                      color: Color(0xFFAAAAAA),
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFFFFFFF),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        12, 20, 12, 20),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF36EB9F))),
                                    suffixIconConstraints: const BoxConstraints(
                                        minWidth: 40, maxHeight: 20),
                                    suffixIcon: Image.network(
                                      'https://www.oneinsure.com/assets/bi/images/FlutterOneinsureimg/OI-PNG-Icons/calendar01.png',
                                      color: const Color(0xFFAAAAAA),
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return const SizedBox();
                                      },
                                    ),
                                  ),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime(2100));
                                    if (pickedDate != null) {
                                      var formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                      setState(() {
                                        deliveryController.txtJoinDate.text =
                                            formattedDate;
                                      });
                                    } else {
                                      print("Date is not selected");
                                    }
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Join Date is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("Email Id:"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  style: const TextStyle(
                                      height: 1, color: Colors.black),
                                  controller: deliveryController.txtEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: "Enter Email Id ",
                                    hintStyle: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto-Regular',
                                        color: Color(0xFFAAAAAA)),
                                    filled: true,
                                    fillColor: const Color(0xFFFFFFFF),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        12, 20, 12, 20),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF36EB9F))),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    //   if (value!.isEmpty) {
                                    //     return 'Mobile Number is required';
                                    //   } else if (!RegExp(r'^([6-9]{1})([0-9]{9})$').hasMatch(value)) {
                                    //     return 'Mobile Number is not valid';
                                    //   }
                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("Phone Number"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  style: const TextStyle(
                                      height: 1, color: Colors.black),
                                  controller: deliveryController.txtMobile,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: "Enter Phone Mobile ",
                                    hintStyle: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto-Regular',
                                        color: Color(0xFFAAAAAA)),
                                    filled: true,
                                    fillColor: const Color(0xFFFFFFFF),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        12, 20, 12, 20),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF36EB9F))),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Mobile Number is required';
                                    } else if (!RegExp(
                                            r'^([6-9]{1})([0-9]{9})$')
                                        .hasMatch(value)) {
                                      return 'Mobile Number is not valid';
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.digitsOnly,
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9.,]')),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("Alternate Mobile Number"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  style: const TextStyle(
                                      height: 1, color: Colors.black),
                                  controller: deliveryController.txtAltMobile,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: "Enter Alternate Mobile Number ",
                                    hintStyle: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto-Regular',
                                        color: Color(0xFFAAAAAA)),
                                    filled: true,
                                    fillColor: const Color(0xFFFFFFFF),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        12, 20, 12, 20),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF36EB9F))),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    // if (value!.isEmpty) {
                                    //   return 'Alternate Mobile Number is required';
                                    // } else if (!RegExp(r'^([6-9]{1})([0-9]{9})$').hasMatch(value)) {
                                    //   return 'Alternate Mobile Number is not valid';
                                    // }
                                    return null;
                                  },
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.digitsOnly,
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9.,]')),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("Password:"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  style: const TextStyle(
                                      height: 1, color: Colors.black),
                                  controller: deliveryController.txtPassword,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    hintText: "Enter Password",
                                    hintStyle: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto-Regular',
                                        color: Color(0xFFAAAAAA)),
                                    filled: true,
                                    fillColor: const Color(0xFFFFFFFF),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        12, 20, 12, 20),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF36EB9F))),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Last Name is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("Aadhaar Number"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                          style: const TextStyle(
                                              height: 1, color: Colors.black),
                                          controller:
                                              deliveryController.txtAadhaar,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(),
                                          decoration: InputDecoration(
                                            //Color(0xFF36EB9F
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(9.0),
                                                borderSide: const BorderSide(
                                                    color: Color(0xFF36EB9F))),
                                            hintText: "Enter Aadhaar Number",
                                            hintStyle: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Roboto-Regular',
                                              color: Color(0xFFAAAAAA),
                                            ),
                                            filled: true,
                                            fillColor: const Color(0xFFFFFFFF),
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    12, 20, 12, 20),
                                          ),
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                12),
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            FilteringTextInputFormatter.allow(
                                                RegExp('[0-9.,]')),
                                          ],
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Aadhaar Number is required';
                                            }
                                            return null;
                                          }),
                                    ),
                                    const SizedBox(width: 12),
                                    (deliveryController.aadharCardURL != null &&
                                            deliveryController
                                                .aadharCardURL!.isNotEmpty)
                                        ? InkWell(
                                            onTap: () {
                                              showUploadedImagePopup(
                                                deliveryController
                                                    .aadharCardURL!,
                                                () {
                                                  deliveryController
                                                      .aadharCardURL = null;
                                                  deliveryController.update();
                                                  Get.back();
                                                },
                                              );
                                            },
                                            child: const Icon(Icons.visibility))
                                        : InkWell(
                                            onTap: () => adhaarCameraOptions(),
                                            child: Container(
                                              height: 46,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 12),
                                              decoration: BoxDecoration(
                                                color: AppColors.textColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Image.asset(
                                                  "assets/icons/share.png",
                                                  height: 16,
                                                  width: 16),
                                            ),
                                          ),
                                    const SizedBox(width: 12),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("Vehicle No"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  style: const TextStyle(
                                      height: 1, color: Colors.black),
                                  controller: deliveryController.txtVNumber,
                                  onFieldSubmitted: (text) {
                                    print("First text field: $text");
                                    setState(() {
                                      deliveryController.txtVNumber.text =
                                          checkReg(text);
                                    });
                                  },
                                  keyboardType: TextInputType.text,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  decoration: InputDecoration(
                                    hintText: "Enter Vehicle No ",
                                    hintStyle: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto-Regular',
                                        color: Color(0xFFAAAAAA)),
                                    filled: true,
                                    fillColor: const Color(0xFFFFFFFF),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        12, 20, 12, 20),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF36EB9F))),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Vehicle Number is required';
                                    }
                                    // final pattern = RegExp(
                                    //     '([0-9]{0,2}|[A-Z]{2})-([0-9]{1,2}|[A-Z]{1,2})(-)(?:([A-Z]{1,3}|[0-9]{1,4}))(|-)([A-Z]{1,2}|[0-9]{1,4})');
                                    // if (!(value.length < 15 && pattern.hasMatch(value))) {
                                    //   return 'Please enter valid vehicle number';
                                    // }
                                    return null;
                                  },
                                  inputFormatters: const [
                                    // LengthLimitingTextInputFormatter(15),
                                    // FilteringTextInputFormatter.digitsOnly,
                                    // FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("Driving Licence number"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                          style: const TextStyle(
                                              height: 1, color: Colors.black),
                                          controller: deliveryController
                                              .txtLicenceNumber,
                                          keyboardType: TextInputType.text,
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          decoration: InputDecoration(
                                            //Color(0xFF36EB9F
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(9.0),
                                                borderSide: const BorderSide(
                                                    color: Color(0xFF36EB9F))),
                                            hintText:
                                                "Enter Driving Licence number",
                                            hintStyle: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Roboto-Regular',
                                              color: Color(0xFFAAAAAA),
                                            ),
                                            filled: true,
                                            fillColor: const Color(0xFFFFFFFF),
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    12, 20, 12, 20),
                                          ),
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Driving Licence number is required';
                                            } else if (RegExp(
                                                    r'^([A-Z]{2}(?:\d[- ]*){14})$')
                                                .hasMatch(deliveryController
                                                    .txtIFSCCode.text)) {
                                              return 'Please enter valid licence number';
                                            }
                                            return null;
                                          }),
                                    ),
                                    const SizedBox(width: 12),
                                    (deliveryController
                                                    .drivingLicenseNumberURL !=
                                                null &&
                                            deliveryController
                                                .drivingLicenseNumberURL!
                                                .isNotEmpty)
                                        ? InkWell(
                                            onTap: () {
                                              showUploadedImagePopup(
                                                deliveryController
                                                    .drivingLicenseNumberURL!,
                                                () {
                                                  deliveryController
                                                          .drivingLicenseNumberURL =
                                                      null;
                                                  deliveryController.update();
                                                  Get.back();
                                                },
                                              );
                                            },
                                            child: const Icon(Icons.visibility))
                                        : InkWell(
                                            onTap: () => drivingCameraOptions(),
                                            child: Container(
                                              height: 46,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 12),
                                              decoration: BoxDecoration(
                                                color: AppColors.textColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Image.asset(
                                                  "assets/icons/share.png",
                                                  height: 16,
                                                  width: 16),
                                            ),
                                          ),
                                    const SizedBox(width: 12),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("Driving Licence Expiry"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  style: const TextStyle(
                                      height: 1, color: Colors.black),
                                  controller: deliveryController.txtLicenceExp,
                                  readOnly: true,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "Driving Licence Expiry Date",
                                    hintStyle: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Roboto-Regular',
                                      color: Color(0xFFAAAAAA),
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFFFFFFF),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        12, 20, 12, 20),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF36EB9F))),
                                    suffixIconConstraints: const BoxConstraints(
                                        minWidth: 40, maxHeight: 20),
                                    suffixIcon: Image.network(
                                      'https://www.oneinsure.com/assets/bi/images/FlutterOneinsureimg/OI-PNG-Icons/calendar01.png',
                                      color: const Color(0xFFAAAAAA),
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return const SizedBox();
                                      },
                                    ),
                                  ),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime(2100));
                                    if (pickedDate != null) {
                                      var formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                      setState(() {
                                        deliveryController.txtLicenceExp.text =
                                            formattedDate;
                                      });
                                    } else {
                                      print("Date is not selected");
                                    }
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Driving Licence Expiry Date is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("Delivery Area"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                    style: const TextStyle(
                                        height: 1, color: Colors.black),
                                    controller:
                                        deliveryController.txtDeliveryArea,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      //Color(0xFF36EB9F
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(9.0),
                                          borderSide: const BorderSide(
                                              color: Color(0xFF36EB9F))),
                                      hintText: "Enter Delivery Area",
                                      hintStyle: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto-Regular',
                                        color: Color(0xFFAAAAAA),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFFFFFFF),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          12, 20, 12, 20),
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Preferred delivery area is required';
                                      }
                                      return null;
                                    }),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("Bank Account Name:"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                    style: const TextStyle(
                                        height: 1, color: Colors.black),
                                    controller:
                                        deliveryController.txtAccountName,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      //Color(0xFF36EB9F
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(9.0),
                                          borderSide: const BorderSide(
                                              color: Color(0xFF36EB9F))),
                                      hintText: "Enter Bank Account Name:",
                                      hintStyle: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto-Regular',
                                        color: Color(0xFFAAAAAA),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFFFFFFF),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          12, 20, 12, 20),
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Preferred delivery area is required';
                                      }
                                      return null;
                                    }),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("City"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                    style: const TextStyle(
                                        height: 1, color: Colors.black),
                                    controller: deliveryController.txtCity,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      //Color(0xFF36EB9F
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(9.0),
                                          borderSide: const BorderSide(
                                              color: Color(0xFF36EB9F))),
                                      hintText: "Enter City",
                                      hintStyle: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto-Regular',
                                        color: Color(0xFFAAAAAA),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFFFFFFF),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          12, 20, 12, 20),
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'City is required';
                                      }
                                      return null;
                                    }),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("Bank"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  style: const TextStyle(
                                      height: 1, color: Colors.black),
                                  controller: deliveryController.txtBankName,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    hintText: "Enter Bank",
                                    hintStyle: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto-Regular',
                                        color: Color(0xFFAAAAAA)),
                                    filled: true,
                                    fillColor: const Color(0xFFFFFFFF),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        12, 20, 12, 20),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF36EB9F))),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Bank Account is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("Bank Account Number"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  style: const TextStyle(
                                      height: 1, color: Colors.black),
                                  controller:
                                      deliveryController.txtAccountNumber,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: "Enter Bank Account Number",
                                    hintStyle: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto-Regular',
                                        color: Color(0xFFAAAAAA)),
                                    filled: true,
                                    fillColor: const Color(0xFFFFFFFF),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        12, 20, 12, 20),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF36EB9F))),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Bank Account Number is required';
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    //LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.digitsOnly,
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9.,]')),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("IFSC Code"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  style: const TextStyle(
                                      height: 1, color: Colors.black),
                                  controller: deliveryController.txtIFSCCode,
                                  keyboardType: TextInputType.text,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  decoration: InputDecoration(
                                    hintText: "Enter IFSC Code",
                                    hintStyle: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto-Regular',
                                        color: Color(0xFFAAAAAA)),
                                    filled: true,
                                    fillColor: const Color(0xFFFFFFFF),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        12, 20, 12, 20),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF36EB9F))),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'IFSC Code is required';
                                    }
                                    /*else if (RegExp(r'^([A-Za-z]{4}[a-zA-Z0-9]{7})$')
                                        .hasMatch(deliveryController.txtIFSCCode.text)) {
                                      return 'Please enter valid IFSC code';
                                    }*/
                                    return null;
                                  },
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(11),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("Branch Name"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  style: const TextStyle(
                                      height: 1, color: Colors.black),
                                  controller: deliveryController.txtBranchName,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "Enter Bank Branch",
                                    hintStyle: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto-Regular',
                                        color: Color(0xFFAAAAAA)),
                                    filled: true,
                                    fillColor: const Color(0xFFFFFFFF),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        12, 20, 12, 20),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF36EB9F))),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Bank Branch is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("Amount Deposited :"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  style: const TextStyle(
                                      height: 1, color: Colors.black),
                                  controller: deliveryController.txtDepositeAmt,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(),
                                  decoration: InputDecoration(
                                    hintText: "Amount Deposited",
                                    hintStyle: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto-Regular',
                                        color: Color(0xFFAAAAAA)),
                                    filled: true,
                                    fillColor: const Color(0xFFFFFFFF),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        12, 20, 12, 20),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF36EB9F))),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Bank Branch is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("Assets Given :"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  style: const TextStyle(
                                      height: 1, color: Colors.black),
                                  controller: deliveryController.txtAssetGiven,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "Assets Given",
                                    hintStyle: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto-Regular',
                                        color: Color(0xFFAAAAAA)),
                                    filled: true,
                                    fillColor: const Color(0xFFFFFFFF),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        12, 20, 12, 20),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF36EB9F))),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Bank Branch is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 8.0, right: 8.0),
                                child: Text("PAN Number"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        style: const TextStyle(
                                            height: 1, color: Colors.black),
                                        controller:
                                            deliveryController.txtPanNumber,
                                        keyboardType: TextInputType.text,
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        decoration: InputDecoration(
                                          hintText: "Enter PAN Number",
                                          hintStyle: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Roboto-Regular',
                                              color: Color(0xFFAAAAAA)),
                                          filled: true,
                                          fillColor: const Color(0xFFFFFFFF),
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  12, 20, 12, 20),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(9.0),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF36EB9F))),
                                        ),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'PAN Number is required';
                                          }
                                          /*else if (RegExp(r'^([A-Z]{5}[0-9]{4}[A-Z]{1})$')
                                              .hasMatch(deliveryController.txtPanNumber.text)) {
                                            return 'Please enter valid pan number';
                                          }*/
                                          return null;
                                        },
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(10),
                                          // FilteringTextInputFormatter.digitsOnly,
                                          // FilteringTextInputFormatter.allow(
                                          //     RegExp('[0-9.,]')),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    (deliveryController.panCardURL != null &&
                                            deliveryController
                                                .panCardURL!.isNotEmpty)
                                        ? InkWell(
                                            onTap: () {
                                              showUploadedImagePopup(
                                                deliveryController.panCardURL!,
                                                () {
                                                  deliveryController
                                                      .panCardURL = null;
                                                  deliveryController.update();
                                                  Get.back();
                                                },
                                              );
                                            },
                                            child: const Icon(Icons.visibility))
                                        : InkWell(
                                            onTap: () => panCameraOptions(),
                                            child: Container(
                                              height: 46,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 12),
                                              decoration: BoxDecoration(
                                                color: AppColors.textColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Image.asset(
                                                  "assets/icons/share.png",
                                                  height: 16,
                                                  width: 16),
                                            ),
                                          ),
                                    const SizedBox(width: 12),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width / 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, left: 5.0, right: 5.0),
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      if (deliveryController.profileImage ==
                                          null) {
                                        'Please select profile image'
                                            .showError();
                                        return;
                                      }
                                      if (_formKey.currentState!.validate()) {
                                        if (deliveryController.aadharCardURL ==
                                            null) {
                                          'Please select aadhar card image'
                                              .showError();
                                          return;
                                        }
                                        if (deliveryController
                                                .drivingLicenseNumberURL ==
                                            null) {
                                          'Please select driving license image'
                                              .showError();
                                          return;
                                        }
                                        if (deliveryController.panCardURL ==
                                            null) {
                                          'Please select pan card image'
                                              .showError();
                                          return;
                                        }
                                        deliveryController.saveProfile();
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF8A00),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      alignment:
                                          const AlignmentDirectional(0, 0),
                                      child: const Text("Next",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                deliveryController.isLoading.isTrue
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: Colors.orange,
                        backgroundColor: Colors.white10,
                      ))
                    : const SizedBox(),
              ],
            );
          }),
    );
  }

  showUploadedImagePopup(String imageUrl, Function() removeOnTap) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          title: Container(
            height: 30,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(3), topRight: Radius.circular(3)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: AppColors.appGradientColor,
              ),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
                onTap: removeOnTap,
                child: AppImageAsset(
                  image: 'assets/icons/delete_icon.png',
                  fit: BoxFit.contain,
                  color: Colors.white,
                  height: 20,
                  width: 20,
                )),
          ),
          contentPadding: EdgeInsets.zero,
          content: AppImageAsset(
              image: imageUrl,
              height: 300,
              width: 100,
              fit: BoxFit.cover,
              isFile: true),
        );
      },
    );
  }

  Future cameraOptions() {
    final deliveryController = Get.find<DeliveryController>();
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 2.0,
            sigmaY: 2.0,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              height: MediaQuery.of(context).size.width / 2.5,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                //borderRadius: const BorderRadius.all(Radius.circular(20)),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                border: Border.all(
                  color: Colors.black26,
                  width: 0.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Center(
                    child: Text(
                      "Upload Photo",
                      style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins"),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => deliveryController
                                .selectProfileImage(ImageSource.gallery),
                            child: Container(
                                width: 50.00,
                                height: 50.00,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: const Icon(Icons.photo_outlined)),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          const Text("Gallery",
                              style: TextStyle(
                                  color: Color(0xFF605E5E),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins")),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => deliveryController
                                .selectProfileImage(ImageSource.camera),
                            child: Container(
                                width: 50.00,
                                height: 50.00,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                child: const Icon(Icons.camera_alt_outlined)),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          const Text("Camera",
                              style: TextStyle(
                                  color: Color(0xFF605E5E),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins")),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future adhaarCameraOptions() {
    final deliveryController = Get.find<DeliveryController>();
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 2.0,
            sigmaY: 2.0,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              height: MediaQuery.of(context).size.width / 2.5,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                //borderRadius: const BorderRadius.all(Radius.circular(20)),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                border: Border.all(
                  color: Colors.black26,
                  width: 0.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Center(
                    child: Text(
                      "Upload Photo",
                      style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins"),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => deliveryController
                                .selectAdharImage(ImageSource.gallery),
                            child: Container(
                                width: 50.00,
                                height: 50.00,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: const Icon(Icons.photo_outlined)),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          const Text("Gallery",
                              style: TextStyle(
                                  color: Color(0xFF605E5E),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins")),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => deliveryController
                                .selectAdharImage(ImageSource.camera),
                            child: Container(
                                width: 50.00,
                                height: 50.00,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                child: const Icon(Icons.camera_alt_outlined)),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          const Text("Camera",
                              style: TextStyle(
                                  color: Color(0xFF605E5E),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins")),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future panCameraOptions() {
    final deliveryController = Get.find<DeliveryController>();
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 2.0,
            sigmaY: 2.0,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              height: MediaQuery.of(context).size.width / 2.5,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                //borderRadius: const BorderRadius.all(Radius.circular(20)),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                border: Border.all(
                  color: Colors.black26,
                  width: 0.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Center(
                    child: Text(
                      "Upload Photo",
                      style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins"),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => deliveryController
                                .selectPanImage(ImageSource.gallery),
                            child: Container(
                                width: 50.00,
                                height: 50.00,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: const Icon(Icons.photo_outlined)),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          const Text("Gallery",
                              style: TextStyle(
                                  color: Color(0xFF605E5E),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins")),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => deliveryController
                                .selectPanImage(ImageSource.camera),
                            child: Container(
                                width: 50.00,
                                height: 50.00,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                child: const Icon(Icons.camera_alt_outlined)),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          const Text("Camera",
                              style: TextStyle(
                                  color: Color(0xFF605E5E),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins")),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future drivingCameraOptions() {
    final deliveryController = Get.find<DeliveryController>();
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 2.0,
            sigmaY: 2.0,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              height: MediaQuery.of(context).size.width / 2.5,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                //borderRadius: const BorderRadius.all(Radius.circular(20)),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                border: Border.all(
                  color: Colors.black26,
                  width: 0.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Center(
                    child: Text(
                      "Upload Photo",
                      style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins"),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => deliveryController
                                .selectDrivingImage(ImageSource.gallery),
                            child: Container(
                                width: 50.00,
                                height: 50.00,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: const Icon(Icons.photo_outlined)),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          const Text("Gallery",
                              style: TextStyle(
                                  color: Color(0xFF605E5E),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins")),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => deliveryController
                                .selectDrivingImage(ImageSource.camera),
                            child: Container(
                                width: 50.00,
                                height: 50.00,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                child: const Icon(Icons.camera_alt_outlined)),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          const Text("Camera",
                              style: TextStyle(
                                  color: Color(0xFF605E5E),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins")),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  checkReg(n) {
    print("data: ${n}");
    var pa = RegExp(r'^[a-zA-Z]{1,2}$');
    var pb = RegExp(r'^[0-9]{1,2}$');
    var pc = RegExp(r'^[a-zA-Z]{1,3}$');
    var pd = RegExp(r'^[0-9]{1,4}$');
    var rn = n == "" ? "" : n;
    final rnarr = List.filled(4, "", growable: false);
    var a = '';
    var b = '';
    var c = '';
    var d = '';
    rn = rn.replaceAll(r'[^a-zA-Z0-9]', "");
    rn = rn.split("");
    rn.forEach((char) {
      a = a + char;
      if (pa.hasMatch(a) && a.length <= 2) {
        rnarr[0] = a;
        print(a);
      } else if (rnarr.length >= 1) {
        b = b + char;
        if (pb.hasMatch(b) && b.length <= 2) {
          rnarr[1] = b;
          print(b);
        } else if (rnarr.length >= 2) {
          c = c + char;
          if (pc.hasMatch(c) && c.length <= 3) {
            rnarr[2] = c;
            print(c);
          } else if (rnarr.length >= 3) {
            d = d + char;
            if (pd.hasMatch(d)) {
              rnarr[3] = d;
              print(d);
            }
          }
        }
      }
    });
    print(rnarr);
    rn = rnarr.join("-");
    print("Registraiont Number: ${rn}");
    return rn;
  }
}
