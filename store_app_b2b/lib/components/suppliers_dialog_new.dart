import 'dart:developer';

import 'package:b2c/utils/string_extensions_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_radio_button_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/buy_controller/buy_controller_new.dart';

class SuppliersDialog extends StatelessWidget {
  const SuppliersDialog({Key? key, required this.applyOnTap}) : super(key: key);
  final VoidCallback applyOnTap;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        log("willpop");
        return true;
      },
      child: ClipRRect(
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
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
                  GetBuilder<BuyController>(
                    builder: (BuyController controller) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: List.generate(
                            controller.suppliersDialogList.length,
                            (index) {
                              return SizedBox(
                                height: 46,
                                child: RadioButton(
                                  onTap: () {
                                    controller.suppliersSelect.value =
                                        controller.suppliersDialogList[index]
                                            ['supplierName'];
                                    controller.suppliersId.value =
                                        controller.suppliersDialogList[index]
                                            ['supplierId'];
                                    controller.getBuyBySuppliersDataApi(
                                      supplierId:
                                          controller.suppliersDialogList[index]
                                              ['supplierId'],
                                      search: "a",
                                      showLoading: true,
                                    );
                                    Get.back();
                                    setState(() {});
                                  },
                                  title: controller.suppliersDialogList[index]
                                      ['supplierName'],
                                  selectTitle: controller.suppliersSelect.value,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
