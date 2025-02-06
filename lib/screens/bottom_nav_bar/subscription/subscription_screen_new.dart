import 'dart:developer';

import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'package:b2c/controllers/subscription_controller_new.dart';
import 'package:b2c/model/product_search_model_new.dart';
import 'package:b2c/screens/auth/sign_up_2_screen_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const CommonText(
            content: "Subscription", boldNess: FontWeight.w600),
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
        init: SubscriptionController(),
        builder: (SubscriptionController subscriptionController) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.bgColor,
                ),
                alignment: Alignment.center,
                child: TypeAheadField<String>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: subscriptionController.searchProductController,
                    autofocus: true,
                    cursorColor: AppColors.primaryColor,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      suffixIconConstraints: const BoxConstraints(maxHeight: 2),
                      hintText: 'Select product',
                      hintStyle: TextStyle(
                          fontSize: 12,
                          color: AppColors.hintColor,
                          fontWeight: FontWeight.w500),
                      contentPadding:
                          const EdgeInsets.only(left: 5, bottom: 0.8, top: 0.8),
                      isDense: true,
                      filled: true,
                      fillColor: AppColors.bgColor,
                      disabledBorder: InputBorder.none,
                      /* OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(2)),
                        borderSide: BorderSide(color: AppColors.textBlackColor, width: 0),
                      ),*/
                      focusedBorder: InputBorder.none,
                      /* OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(2)),
                        borderSide: BorderSide(color: AppColors.textBlackColor, width: 0),
                      ),*/
                      enabledBorder: InputBorder
                          .none, /* OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(2)),
                        borderSide: BorderSide(color: AppColors.textBlackColor, width: 0),
                      ),*/
                    ),
                  ),
                  suggestionsCallback: (pattern) async {
                    // if (pattern.length < 3) return [];
                    return subscriptionController.searchOnChanged(pattern);
                  },
                  itemBuilder: (context, suggestion) => Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(color: AppColors.textBlackColor)),
                    ),
                    child: AppText((suggestion ?? '').toString(),
                        color: AppColors.textColor),
                  ),
                  onSuggestionSelected: (suggestion) async {
                    subscriptionController.searchProductController.text =
                        suggestion;
                    subscriptionController.productSearchModel =
                        subscriptionController.productSearchModelList
                            .firstWhere((element) =>
                                (element.productName ?? '').toLowerCase() ==
                                suggestion.toLowerCase());
                    log('productSearchModel --> ${subscriptionController.productSearchModel!.toJson()}');
                    final String? productSearch =
                        await subscriptionController.getProductsRestCall();
                    if (productSearch != null && productSearch.isNotEmpty) {
                      subscriptionController.productResult =
                          productResultFromJson(productSearch);
                    }
                    subscriptionController.update();
                  },
                  noItemsFoundBuilder: (context) => const SizedBox(),
                  loadingBuilder: (context) => const SizedBox(),
                ),
              ),
              if (subscriptionController.productResult != null)
                Expanded(
                  child: ListView(
                    padding:
                        const EdgeInsets.only(top: 30, left: 16, right: 16),
                    children: [
                      Container(
                        decoration:
                            const BoxDecoration(color: Color(0xffF5F5F5)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: CommonText(
                                content: "Product details",
                                textSize: 18,
                                textColor: AppColors.textColor,
                                boldNess: FontWeight.w400,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                      color: AppColors.dividerColor, width: 1),
                                  right: BorderSide(
                                      color: AppColors.dividerColor, width: 1),
                                  left: BorderSide(
                                      color: AppColors.dividerColor, width: 1),
                                ),
                              ),
                              child: Column(
                                children: [
                                  reviewDetails(
                                      width: width,
                                      title: "Product Name",
                                      subTitle: subscriptionController
                                              .productResult!.name ??
                                          '--'),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Divider(
                                        color: AppColors.dividerColor,
                                        thickness: 1,
                                        height: 1),
                                  ),
                                  reviewDetails(
                                      width: width,
                                      title: 'Manufacturer',
                                      subTitle: subscriptionController
                                              .productResult!.manufacturer ??
                                          '--'),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Divider(
                                        color: AppColors.dividerColor,
                                        thickness: 1,
                                        height: 1),
                                  ),
                                  reviewDetails(
                                      width: width,
                                      title: "Description",
                                      subTitle: subscriptionController
                                              .productResult!.description ??
                                          '--'),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Divider(
                                        color: AppColors.dividerColor,
                                        thickness: 1,
                                        height: 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      InkWell(
                        onTap: () => subscriptionController.subscribeProduct(),
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const AppText(
                            'Subscribe',
                            textAlign: TextAlign.center,
                            color: AppColors.appWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Row buildProductDetails(BuildContext context, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width / 3.5,
            child: AppHeaderText(
                headerText: '$title : ', headerColor: AppColors.borderColor)),
        const SizedBox(width: 12),
        Expanded(child: AppText(value, color: AppColors.textBlackColor)),
      ],
    );
  }

  reviewDetails(
      {double? width, String? title, String? subTitle, Color? titleColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: width! / 3.2,
            child: CommonText(
              content: title,
              textSize: width * 0.032,
              textColor: titleColor ?? AppColors.textColor,
              boldNess: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: width * 0.06,
            child: CommonText(
              content: ":",
              textSize: width * 0.032,
              textColor: AppColors.textColor,
              boldNess: FontWeight.w400,
            ),
          ),
          Expanded(
            child: Html(data: subTitle),
            // child: CommonText(
            //   content: subTitle,
            //   textSize: width * 0.032,
            //   textColor: AppColors.textColor,
            //   boldNess: FontWeight.w400,
            // ),
          ),
        ],
      ),
    );
  }
}
