import 'package:b2c/components/login_dialog_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app_b2b/components/common_radio_button_new.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/components/common_text_field_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/buy_controller/buy_controller_new.dart';
import 'package:store_app_b2b/controllers/home_controller_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/cart_screen/cart_screen_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

class AddUnlistedProductTab extends StatelessWidget {
  const AddUnlistedProductTab({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GetX(
      initState: (state) async {
        state.controller!.suppliersFindId.value = "";
        state.controller!.suppliersFindNameSelect.value = "";
        state.controller!.uploadImage.value = "";
        state.controller!.productNameController.value.clear();
        state.controller!.manufacturerController.value.clear();
        state.controller!.qtyController.value.clear();
        state.controller!.unlistedProductList.clear();
        await state.controller!.getSuppliersDialogListApi().then((value) {
          print('value --> ${value}');
          if (value.length == 1) {
            state.controller!.suppliersFindId.value = value[0]['supplierId'];
            state.controller!.suppliersFindNameSelect.value =
                value[0]['supplierName'];
          }
        });
      },
      init: BuyController(),
      builder: (controller) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: GestureDetector(
                    //     onTap: () async {
                    //       await controller
                    //           .getSuppliersDialogListApi()
                    //           .then((value) {
                    //         print('value --> ${value}');
                    //         if (value != null) {
                    //           Get.dialog(
                    //             supplierDialog(controller),
                    //           );
                    //         }
                    //       });
                    //     },
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(right: 10),
                    //       child: Container(
                    //         height: 45,
                    //         decoration: BoxDecoration(
                    //           color: ColorsConst.primaryColor,
                    //           borderRadius: BorderRadius.circular(8),
                    //         ),
                    //         padding: const EdgeInsets.symmetric(horizontal: 6),
                    //         child: Row(
                    //           mainAxisSize: MainAxisSize.min,
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Flexible(
                    //               child: CommonText(
                    //                 content: (controller.suppliersFindNameSelect
                    //                         .value.isNotEmpty)
                    //                     ? controller
                    //                         .suppliersFindNameSelect.value
                    //                     : "Supplier",
                    //                 textSize: width * 0.035,
                    //                 overflow: TextOverflow.ellipsis,
                    //                 maxLines: 1,
                    //               ),
                    //             ),
                    //             Padding(
                    //               padding: const EdgeInsets.only(left: 5),
                    //               child: Image.asset(
                    //                 "assets/icons/down_arrow_icon.png",
                    //                 scale: 3,
                    //                 package: 'store_app_b2b',
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    CommonTextField(
                      content: "",
                      hintTextSize: 14,
                      hintText: "Enter product name",
                      hintTextWeight: FontWeight.w500,
                      controller: controller.productNameController.value,
                      contentColor: ColorsConst.textColor,
                      titleShow: false,
                    ),
                    SizedBox(height: Get.height * 0.01),
                    CommonTextField(
                      content: "",
                      hintTextWeight: FontWeight.w500,
                      hintText: "manufacturer",
                      hintTextSize: 14,
                      controller: controller.manufacturerController.value,
                      contentColor: ColorsConst.textColor,
                      titleShow: false,
                    ),
                    SizedBox(height: Get.height * 0.01),
                    CommonTextField(
                      content: "",
                      hintTextWeight: FontWeight.w500,
                      hintText: "MRP",
                      hintTextSize: 14,
                      controller: controller.mrpController.value,
                      contentColor: ColorsConst.textColor,
                      titleShow: false,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,}'),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.01),
                    CommonTextField(
                      content: "",
                      maxLines: 4,
                      hintTextWeight: FontWeight.w500,
                      hintText: "Enter any extra comments",
                      hintTextSize: 14,
                      controller: controller.commentController.value,
                      contentColor: ColorsConst.textColor,
                      titleShow: false,
                    ),
                    SizedBox(height: Get.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: SizedBox(
                            width: width / 3,
                            child: CommonTextField(
                              hintTextWeight: FontWeight.w500,
                              hintTextSize: 14,
                              counterText: '',
                              maxLength: 4,
                              content: "",
                              hintText: "QTY",
                              controller: controller.qtyController.value,
                              contentColor: ColorsConst.textColor,
                              keyboardType: TextInputType.number,
                              titleShow: false,
                            ),
                          ),
                        ),
                        Flexible(
                          child: SizedBox(
                            width: width / 3,
                            child: CommonTextField(
                              maxLength: 4,
                              counterText: '',
                              hintTextWeight: FontWeight.w500,
                              hintTextSize: 14,
                              content: "",
                              hintText: "Free QTY +22",
                              controller: controller.freeQtyController.value,
                              contentColor: ColorsConst.textColor,
                              keyboardType: TextInputType.number,
                              titleShow: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.02),
                    CommonText(
                      content: "Or Use Image Upload",
                      boldNess: FontWeight.w500,
                      textColor: ColorsConst.notificationTextColor,
                      textSize: width * 0.035,
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Obx(
                      () => Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorsConst.hintColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            controller.uploadImage.isEmpty
                                ? GestureDetector(
                                    //     onTap: controller.findMoreProductList
                                    //                 .length >
                                    //             10
                                    //         ? null
                                    onTap: () async {
                                      await Get.bottomSheet(
                                          UploadImageEditView(isBack: true),
                                          useRootNavigator: true,
                                          isScrollControlled: true);
                                    },
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.grey.shade700,
                                      size: 30,
                                    ),
                                  )
                                : AppImageAsset(
                                    image: controller.uploadImage.value,
                                    height: 50,
                                    width: width / 3),
                            GestureDetector(
                              // onTap: controller.findMoreProductList.length >
                              //         10
                              //     ? null
                              onTap: () async {
                                await Get.bottomSheet(
                                    UploadImageEditView(isBack: true),
                                    useRootNavigator: true,
                                    isScrollControlled: true);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                      // color: controller.findMoreProductList
                                      //             .length >
                                      //         10
                                      //     ? ColorsConst.greenColor
                                      //         .withOpacity(0.4)
                                      //     : ColorsConst.greenColor,
                                      color: ColorsConst.greenColor,
                                    )),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 9),
                                child: CommonText(
                                  content: "Upload Image",
                                  boldNess: FontWeight.w500,
                                  // textColor: controller
                                  //             .findMoreProductList.length >
                                  //         10
                                  //     ? ColorsConst.greenColor
                                  //         .withOpacity(0.4)
                                  //     : ColorsConst.greenColor,
                                  textColor: ColorsConst.greenColor,
                                  textSize: width * 0.032,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    InkWell(
                      // onTap: controller.findMoreProductList.length > 10
                      //     ? null
                      onTap: () async {
                        if (controller.uploadImage.value.isEmpty) {
                          if (controller
                              .productNameController.value.text.isEmpty) {
                            CommonSnackBar.showError(
                                'Please Enter Product Name');
                            // } else if (controller
                            //     .manufacturerController.value.text.isEmpty) {
                            //   CommonSnackBar.showError(
                            //       'Please Enter manufacturer');
                          } else if (controller
                              .qtyController.value.text.isEmpty) {
                            CommonSnackBar.showError('Please Enter Quantity');
                          }
                          // else if (controller.suppliersFindId.value.isEmpty) {
                          //   CommonSnackBar.showError('Please Select Supplier');
                          // }
                          else {
                            if (controller.userId.value.isNotEmpty) {
                              var body = {
                                "userId": controller.userId.value,
                                "productName": controller
                                    .productNameController.value.text
                                    .trim(),
                                "imgURL": controller.uploadImage.value,
                                "mrp": controller.mrpController.value.text,
                                "comments":
                                    controller.commentController.value.text,
                                "productManufracturer": controller
                                    .manufacturerController.value.text
                                    .trim(),
                                "storeId": controller.suppliersFindId.value,
                                "quantity":
                                    controller.qtyController.value.text.trim(),
                                "freeQuantity": controller
                                        .freeQtyController.value.text
                                        .trim()
                                        .isNotEmpty
                                    ? controller.freeQtyController.value.text
                                    : 0
                              };
                              await controller
                                  .getProductSubmitApi(body)
                                  .then((value) {
                                if (value != null) {
                                  controller.getProductFindApiList();
                                  // controller.suppliersFindId.value =
                                  //     "";
                                  // controller.suppliersFindNameSelect
                                  //     .value = "";
                                  controller.productNameController.value
                                      .clear();
                                  controller.mrpController.value.clear();
                                  controller.commentController.value.clear();
                                  controller.manufacturerController.value
                                      .clear();
                                  controller.qtyController.value.clear();
                                  controller.uploadImage.value = "";
                                  controller.freeQtyController.value.clear();
                                }
                              });
                            } else if (!Get.isDialogOpen!) {
                              Get.dialog(const LoginDialog());
                            }
                          }
                        } else {
                          if (controller.qtyController.value.text.isEmpty) {
                            CommonSnackBar.showError('Please Enter Quantity');
                          }
                          // else if (controller.suppliersFindId.value.isEmpty) {
                          //   CommonSnackBar.showError('Please Select Supplier');
                          // }
                          else {
                            if (controller.userId.value.isNotEmpty) {
                              var body = {
                                "userId": controller.userId.value,
                                "productName": controller
                                    .productNameController.value.text
                                    .trim(),
                                "imgURL": controller.uploadImage.value,
                                "productManufracturer": controller
                                    .manufacturerController.value.text
                                    .trim(),
                                "mrp": controller.mrpController.value.text,
                                "comments":
                                    controller.commentController.value.text,
                                "storeId": controller.suppliersFindId.value,
                                "quantity":
                                    controller.qtyController.value.text.trim(),
                                "freeQuantity": controller
                                        .freeQtyController.value.text
                                        .trim()
                                        .isNotEmpty
                                    ? controller.freeQtyController.value.text
                                    : 0
                              };
                              await controller
                                  .getProductSubmitApi(body)
                                  .then((value) {
                                if (value != null) {
                                  controller.getProductFindApiList();
                                  // controller.suppliersFindId.value =
                                  //     "";
                                  // controller.suppliersFindNameSelect
                                  //     .value = "";
                                  controller.productNameController.value
                                      .clear();
                                  controller.mrpController.value.clear();
                                  controller.commentController.value.clear();
                                  controller.manufacturerController.value
                                      .clear();
                                  controller.qtyController.value.clear();
                                  controller.uploadImage.value = "";
                                  controller.freeQtyController.value.clear();
                                }
                              });
                            } else if (!Get.isDialogOpen!) {
                              Get.dialog(const LoginDialog());
                            }
                          }
                        }
                      },
                      child: Container(
                        width: width,
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: controller.unlistedProductList.length > 10
                                  ? ColorsConst.primaryColor.withOpacity(0.4)
                                  : ColorsConst.primaryColor,
                            )),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 9),
                        child: Center(
                          child: controller.isButtonFindLoading.value
                              ? CupertinoActivityIndicator(
                                  color: ColorsConst.primaryColor)
                              : CommonText(
                                  content: "Add",
                                  boldNess: FontWeight.w500,
                                  // textColor: controller
                                  //             .findMoreProductList.length >
                                  //         10
                                  //     ? ColorsConst.primaryColor
                                  //         .withOpacity(0.4)
                                  //     : ColorsConst.primaryColor,
                                  // textSize: width * 0.035,
                                  textColor: ColorsConst.primaryColor,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    // controller.findMoreProductList.length < 10
                    //     ? SizedBox()
                    //     : CommonText(
                    //         content: "Maximum 10 items can be added",
                    //         boldNess: FontWeight.w400,
                    //         textColor: ColorsConst.textColor,
                    //         textSize: width * 0.035,
                    //       ),
                    SizedBox(height: Get.height * 0.02),
                    Column(
                      children: List.generate(
                          controller.unlistedProductList.length,
                          (index) => Column(
                                children: [
                                  Divider(
                                      color: ColorsConst.notificationTextColor),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CommonText(
                                              content: controller
                                                          .unlistedProductList[
                                                      index]['productName'] ??
                                                  "",
                                              boldNess: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              textColor: ColorsConst.textColor,
                                              textSize: width * 0.04,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              await controller
                                                  .getDeleteFindProductApi(
                                                      controller
                                                              .unlistedProductList[
                                                          index]['id'])
                                                  .then((value) {
                                                if (value != null) {
                                                  print(
                                                      "value>>>>>>>>>>>>>>$value");
                                                  controller
                                                      .getProductFindApiList();
                                                  CommonSnackBar.showSuccess(
                                                      'Deleted');
                                                }
                                              });
                                            },
                                            child: Image.asset(
                                              "assets/icons/delete_icon.png",
                                              scale: 4,
                                              package: 'store_app_b2b',
                                            ),
                                          ),
                                        ],
                                      ),
                                      CommonText(
                                        content:
                                            "${controller.unlistedProductList[index]['productManufracturer'] ?? ""}",
                                        boldNess: FontWeight.w400,
                                        textColor:
                                            ColorsConst.notificationTextColor,
                                        textSize: width * 0.03,
                                      ),
                                      Row(
                                        children: [
                                          if (controller.unlistedProductList[
                                                  index]['imgURL'] !=
                                              "")
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          ColorsConst.hintColor,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: AppImageAsset(
                                                    image: controller
                                                                .unlistedProductList[
                                                            index]['imgURL'] ??
                                                        "",
                                                    height: 50,
                                                    width: 50),
                                              ),
                                            ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Obx(() => Row(
                                                      children: [
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              CommonText(
                                                                content: "QTY-",
                                                                boldNess:
                                                                    FontWeight
                                                                        .w500,
                                                                textColor:
                                                                    ColorsConst
                                                                        .textGreyColor,
                                                                textSize: 14,
                                                              ),
                                                              SizedBox(
                                                                width: 50,
                                                                height: 21,
                                                                child:
                                                                    TextField(
                                                                  onSubmitted:
                                                                      (value) async {
                                                                    var body = {
                                                                      "id": controller
                                                                              .unlistedProductList[index]
                                                                          [
                                                                          'id'],
                                                                      "userId":
                                                                          controller.unlistedProductList[index]
                                                                              [
                                                                              'userId'],
                                                                      "productName":
                                                                          controller.unlistedProductList[index]
                                                                              [
                                                                              'productName'],
                                                                      "imgURL":
                                                                          controller.unlistedProductList[index]
                                                                              [
                                                                              'imgURL'],
                                                                      "productManufracturer":
                                                                          controller.unlistedProductList[index]
                                                                              [
                                                                              'productManufracturer'],
                                                                      "storeId":
                                                                          controller.unlistedProductList[index]
                                                                              [
                                                                              'storeId'],
                                                                      "quantity": controller
                                                                          .updateQtyControllerList[
                                                                              index]
                                                                          .value
                                                                          .text
                                                                          .trim(),
                                                                      "freeQuantity": controller
                                                                          .updateFreeQtyControllerList[
                                                                              index]
                                                                          .value
                                                                          .text
                                                                          .trim()
                                                                    };
                                                                    await controller
                                                                        .getProductQtyUpdateApi(
                                                                            body)
                                                                        .then(
                                                                            (value) {
                                                                      if (value !=
                                                                          null) {
                                                                        controller
                                                                            .getProductFindApiList();
                                                                        controller
                                                                            .isUpdateQTY[index]
                                                                            .value = false;
                                                                      }
                                                                    });
                                                                    // controller.isUpdateQTY[
                                                                    // index] =
                                                                    // false;
                                                                  },
                                                                  enabled: controller
                                                                      .isUpdateQTY[
                                                                          index]
                                                                      .value,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          width *
                                                                              0.04),
                                                                  controller:
                                                                      controller
                                                                              .updateQtyControllerList[
                                                                          index],
                                                                  onChanged:
                                                                      (value) {},
                                                                  inputFormatters: [
                                                                    FilteringTextInputFormatter
                                                                        .digitsOnly
                                                                  ],
                                                                  maxLength: 4,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    counterText:
                                                                        '',
                                                                    border:
                                                                        const UnderlineInputBorder(),
                                                                    hintStyle:
                                                                        GoogleFonts
                                                                            .poppins(
                                                                      color: ColorsConst
                                                                          .semiGreyColor,
                                                                    ),
                                                                    hintText:
                                                                        "QTY",
                                                                    contentPadding: const EdgeInsets
                                                                            .only(
                                                                        top: 2,
                                                                        bottom:
                                                                            10),
                                                                    disabledBorder:
                                                                        const UnderlineInputBorder(),
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  controller
                                                                          .isUpdateQTY[
                                                                              index]
                                                                          .value =
                                                                      !controller
                                                                          .isUpdateQTY[
                                                                              index]
                                                                          .value;
                                                                },
                                                                child: Image.asset(
                                                                    'assets/icons/edit_icon.png',
                                                                    package:
                                                                        'store_app_b2b',
                                                                    scale: 4,
                                                                    color: (controller
                                                                            .isUpdateQTY[
                                                                                index]
                                                                            .value)
                                                                        ? ColorsConst
                                                                            .primaryColor
                                                                        : null,
                                                                    fit: BoxFit
                                                                        .cover),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        if (controller.unlistedProductList[
                                                                    index]
                                                                ['imgURL'] ==
                                                            '')
                                                          Obx(() => Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    CommonText(
                                                                      content:
                                                                          "Free QTY-",
                                                                      boldNess:
                                                                          FontWeight
                                                                              .w500,
                                                                      textColor:
                                                                          ColorsConst
                                                                              .textGreyColor,
                                                                      textSize:
                                                                          14,
                                                                    ),
                                                                    Container(
                                                                      width: 50,
                                                                      height:
                                                                          21,
                                                                      child:
                                                                          TextField(
                                                                        onSubmitted:
                                                                            (value) async {
                                                                          var body =
                                                                              {
                                                                            "id":
                                                                                controller.unlistedProductList[index]['id'],
                                                                            "userId":
                                                                                controller.unlistedProductList[index]['userId'],
                                                                            "productName":
                                                                                controller.unlistedProductList[index]['productName'],
                                                                            "imgURL":
                                                                                controller.unlistedProductList[index]['imgURL'],
                                                                            "productManufracturer":
                                                                                controller.unlistedProductList[index]['productManufracturer'],
                                                                            "storeId":
                                                                                controller.unlistedProductList[index]['storeId'],
                                                                            "quantity":
                                                                                controller.updateQtyControllerList[index].value.text.trim(),
                                                                            "freeQuantity":
                                                                                controller.updateFreeQtyControllerList[index].value.text.trim()
                                                                          };
                                                                          await controller
                                                                              .getProductQtyUpdateApi(body)
                                                                              .then((value) {
                                                                            if (value !=
                                                                                null) {
                                                                              controller.getProductFindApiList();
                                                                              controller.isUpdateFreeQTY[index].value = false;
                                                                            }
                                                                          });
                                                                        },
                                                                        enabled: controller
                                                                            .isUpdateFreeQTY[index]
                                                                            .value,
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                width * 0.04),
                                                                        controller:
                                                                            controller.updateFreeQtyControllerList[index],
                                                                        onChanged:
                                                                            (value) {},
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter
                                                                              .digitsOnly
                                                                        ],
                                                                        maxLength:
                                                                            4,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          counterText:
                                                                              '',
                                                                          border:
                                                                              const UnderlineInputBorder(),
                                                                          hintStyle:
                                                                              GoogleFonts.poppins(
                                                                            color:
                                                                                ColorsConst.semiGreyColor,
                                                                          ),
                                                                          hintText:
                                                                              "QTY",
                                                                          contentPadding: const EdgeInsets.only(
                                                                              top: 2,
                                                                              bottom: 10),
                                                                          disabledBorder:
                                                                              const UnderlineInputBorder(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        controller
                                                                            .isUpdateFreeQTY[index]
                                                                            .value = !controller.isUpdateFreeQTY[index].value;
                                                                      },
                                                                      child: Image.asset(
                                                                          'assets/icons/edit_icon.png',
                                                                          package:
                                                                              'store_app_b2b',
                                                                          scale:
                                                                              4,
                                                                          color: (controller.isUpdateFreeQTY[index].value)
                                                                              ? ColorsConst.primaryColor
                                                                              : null,
                                                                          fit: BoxFit.cover),
                                                                    )
                                                                  ],
                                                                ),
                                                              )),
                                                      ],
                                                    )),
                                                const SizedBox(height: 10),
                                                if (controller
                                                            .unlistedProductList[
                                                        index]['imgURL'] !=
                                                    "")
                                                  Obx(() => Row(
                                                        children: [
                                                          CommonText(
                                                            content:
                                                                "Free QTY-",
                                                            boldNess:
                                                                FontWeight.w500,
                                                            textColor: ColorsConst
                                                                .textGreyColor,
                                                            textSize: 14,
                                                          ),
                                                          Container(
                                                            width: 50,
                                                            height: 21,
                                                            child: TextField(
                                                              onSubmitted:
                                                                  (value) async {
                                                                var body = {
                                                                  "id": controller
                                                                          .unlistedProductList[
                                                                      index]['id'],
                                                                  "userId": controller
                                                                              .unlistedProductList[
                                                                          index]
                                                                      [
                                                                      'userId'],
                                                                  "productName":
                                                                      controller
                                                                              .unlistedProductList[index]
                                                                          [
                                                                          'productName'],
                                                                  "imgURL": controller
                                                                              .unlistedProductList[
                                                                          index]
                                                                      [
                                                                      'imgURL'],
                                                                  "productManufracturer":
                                                                      controller
                                                                              .unlistedProductList[index]
                                                                          [
                                                                          'productManufracturer'],
                                                                  "storeId": controller
                                                                              .unlistedProductList[
                                                                          index]
                                                                      [
                                                                      'storeId'],
                                                                  "quantity": controller
                                                                      .updateQtyControllerList[
                                                                          index]
                                                                      .value
                                                                      .text
                                                                      .trim(),
                                                                  "freeQuantity":
                                                                      controller
                                                                          .updateFreeQtyControllerList[
                                                                              index]
                                                                          .value
                                                                          .text
                                                                          .trim()
                                                                };
                                                                await controller
                                                                    .getProductQtyUpdateApi(
                                                                        body)
                                                                    .then(
                                                                        (value) {
                                                                  if (value !=
                                                                      null) {
                                                                    controller
                                                                        .getProductFindApiList();
                                                                    controller
                                                                        .isUpdateFreeQTY[
                                                                            index]
                                                                        .value = false;
                                                                  }
                                                                });
                                                              },
                                                              enabled: controller
                                                                  .isUpdateFreeQTY[
                                                                      index]
                                                                  .value,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      width *
                                                                          0.04),
                                                              controller: controller
                                                                      .updateFreeQtyControllerList[
                                                                  index],
                                                              onChanged:
                                                                  (value) {},
                                                              inputFormatters: [
                                                                FilteringTextInputFormatter
                                                                    .digitsOnly
                                                              ],
                                                              maxLength: 4,
                                                              decoration:
                                                                  InputDecoration(
                                                                counterText: '',
                                                                border:
                                                                    const UnderlineInputBorder(),
                                                                hintStyle:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  color: ColorsConst
                                                                      .semiGreyColor,
                                                                ),
                                                                hintText: "QTY",
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 2,
                                                                        bottom:
                                                                            10),
                                                                disabledBorder:
                                                                    const UnderlineInputBorder(),
                                                              ),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              controller
                                                                      .isUpdateFreeQTY[
                                                                          index]
                                                                      .value =
                                                                  !controller
                                                                      .isUpdateFreeQTY[
                                                                          index]
                                                                      .value;
                                                            },
                                                            child: Image.asset(
                                                                'assets/icons/edit_icon.png',
                                                                package:
                                                                    'store_app_b2b',
                                                                scale: 4,
                                                                color: (controller
                                                                        .isUpdateFreeQTY[
                                                                            index]
                                                                        .value)
                                                                    ? ColorsConst
                                                                        .primaryColor
                                                                    : null,
                                                                fit: BoxFit
                                                                    .cover),
                                                          )
                                                        ],
                                                      ))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                    ),
                    SizedBox(height: Get.height * 0.05),
                    if (controller.unlistedProductList.isNotEmpty)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () {
                            final controller = Get.put(HomeController());
                            controller.appBarTitle = "Cart";
                            controller.currentIndex = 1;
                            controller.currentWidget =
                                const CartScreen(tabSelect: 1);
                            Future.delayed(
                              const Duration(milliseconds: 150),
                              () {
                                Get.back();
                              },
                            );
                            controller.update();
                          },
                          child: Container(
                            height: 42,
                            width: width,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: ColorsConst.appGradientColor,
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: CommonText(
                                content: "Add to Cart",
                                textSize: width * 0.035,
                                textColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: Get.height * 0.05),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  supplierDialog(BuyController controller) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: ColorsConst.appGradientColor,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            content: "Added Suppliers",
                            boldNess: FontWeight.w600,
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.close, color: Colors.white),
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                            controller.suppliersDialogList.length, (index) {
                          return RadioButton(
                            onTap: () {
                              controller.suppliersFindId.value = controller
                                  .suppliersDialogList[index]['supplierId'];
                              controller.suppliersFindNameSelect.value =
                                  controller.suppliersDialogList[index]
                                      ['supplierName'];

                              Get.back();
                              setState(() {});
                            },
                            title: controller.suppliersDialogList[index]
                                ['supplierName'],
                            selectTitle:
                                controller.suppliersFindNameSelect.value,
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UploadImageEditView extends StatelessWidget {
  final findMoreController = Get.find<BuyController>();
  final bool isBack;
  final String? type;

  UploadImageEditView({Key? key, this.isBack = false, this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorsConst.appWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 22),
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 22, bottom: 10),
            child: CommonText(
                content: 'Select store cover image',
                textSize: 16,
                textColor: ColorsConst.textColor,
                boldNess: FontWeight.w600),
          ),
          Divider(color: ColorsConst.textColor, thickness: 1, height: 0),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 22, right: 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () =>
                      findMoreController.selectImage(ImageSource.camera),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: ColorsConst.appWhite,
                      borderRadius: BorderRadius.circular(8),
                      // boxShadow: ColorsConst.semiGreyColor,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/camera.svg",
                          height: 16,
                          width: 16,
                        ),
                        const SizedBox(width: 20),
                        CommonText(
                          content: 'camera',
                          textSize: 16,
                          textColor: ColorsConst.textColor,
                          boldNess: FontWeight.w600,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () =>
                      findMoreController.selectImage(ImageSource.gallery),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: ColorsConst.appWhite,
                      borderRadius: BorderRadius.circular(8),
                      // boxShadow: ColorsConst.appBoxShadow,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/icons/gallery.png",
                          height: 16,
                          width: 16,
                        ),
                        const SizedBox(width: 20),
                        CommonText(
                          content: 'gallery',
                          textSize: 16,
                          textColor: ColorsConst.textColor,
                          boldNess: FontWeight.w600,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
