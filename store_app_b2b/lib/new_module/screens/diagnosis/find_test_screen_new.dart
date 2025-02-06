import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/constants/loader_new.dart';
//import 'package:store_app_b2b/components/app_loader.dart';
import 'package:store_app_b2b/new_module/controllers/cart_controller/cart_labtest_controller.dart';
import 'package:store_app_b2b/new_module/controllers/diagnosis_controller/lucid_controller.dart';
import 'package:store_app_b2b/new_module/controllers/diagnosis_controller/sample_collection_controller.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller.dart';
import 'package:store_app_b2b/new_module/model/lucid/lucid_list_model.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/sample_collection_screen.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/test_details.dart';
import 'package:store_app_b2b/new_module/snippets/snippets.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_app_bar.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_search_box.dart';
import 'package:store_app_b2b/new_module/widgets/service_card_widget.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';

class FindTestScreen extends StatefulWidget {
  const FindTestScreen(
      {super.key, required this.appBarTitle, this.typesNeeded = false});
  final String appBarTitle;
  final bool typesNeeded;

  @override
  State<FindTestScreen> createState() => _FindTestScreenState();
}

class _FindTestScreenState extends State<FindTestScreen> {
  final ThemeController themeController = Get.find();
  final LucidController lucidController = Get.put(LucidController());
  // final CartLabtestController cartController = Get.put(CartLabtestController());
  SampleCollectionController sampleCollectionController =
      Get.put(SampleCollectionController());
  @override
  void initState() {
    lucidController.diagnosisSearchController.clear();
    lucidController.showSuffixFordiagnosisSearchController.call(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartLabtestController>(builder: (context) {
      final CartLabtestController cartController =
          Get.put(CartLabtestController());
      cartController.getDiagnosticCartData(
          homeCollection: widget.typesNeeded ? "1" : "0");
      cartController.getTestUserDetails(
          isHomeCollection: widget.typesNeeded ? "1" : "0");
      return SafeArea(
        child: Scaffold(
          appBar: AppAppBar(
            title: widget.appBarTitle,
            backgroundColor: themeController.textPrimaryColor,
            isTitleNeeded: true,
            isIconNeeded: true,
          ),
          body: Obx(
            () => Stack(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: [
                    Obx(
                      () => AppSearchBox(
                        showSuffixIcon: lucidController
                            .showSuffixFordiagnosisSearchController.value,
                        onSuffixIconTap: () {
                          lucidController.diagnosisSearchController.text = "";
                          lucidController.lucidServicesCurrentPage.value = 0;
                          lucidController.lucidServicesPageSize.value = 8;
                          lucidController.lucidServicesTotalPages.value = 0;
                          if (widget.typesNeeded) {
                            lucidController.getAllLucidData(
                                searchText: "", hc: "Y");
                          } else {
                            lucidController.getAllLucidData(
                                searchText: "", hc: "N");
                          }

                          lucidController.showSuffixFordiagnosisSearchController
                              .value = false;
                        },
                        textEditingController:
                            lucidController.diagnosisSearchController,
                        onChange: (value) {
                          lucidController.lucidServicesCurrentPage.value = 0;
                          lucidController.lucidServicesPageSize.value = 8;
                          lucidController.lucidServicesTotalPages.value = 0;
                          if (widget.typesNeeded) {
                            lucidController.getAllLucidData(
                                searchText: value, hc: "Y");
                          } else {
                            lucidController.getAllLucidData(
                                searchText: value, hc: "N");
                          }
                          lucidController.showSuffixFordiagnosisSearchController
                              .value = value.isNotEmpty;
                        },
                      ),
                    ),
                    const Gap(15),
                    Expanded(
                      child: Obx(
                        () => lucidController.islucidServicesLoading.value
                            ? verticalShimmerGridView()
                            : NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  if (notification is ScrollEndNotification &&
                                      notification.metrics.extentAfter == 0) {
                                    if (lucidController
                                            .islucidMoreServicesLoading.value ||
                                        lucidController
                                            .islucidServicesLoading.value) {
                                      return false;
                                    }
                                    if (widget.typesNeeded) {
                                      lucidController.getAllLucidData(
                                          loadMore: true,
                                          hc: "Y",
                                          searchText: lucidController
                                              .diagnosisSearchController.text);
                                    } else {
                                      lucidController.getAllLucidData(
                                          loadMore: true,
                                          hc: "N",
                                          searchText: lucidController
                                              .diagnosisSearchController.text);
                                    }
                                  }
                                  return false;
                                },
                                child: Obx(
                                  () => AlignedGridView.count(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: 10,
                                    itemCount:
                                        lucidController.lucidServices.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      BasicLucidModel lucidService =
                                          lucidController.lucidServices[index];

                                      return ServiceCardWidget(
                                        serviceId: lucidService.serviceCd ?? "",
                                        productTitle:
                                            lucidService.serviceName ?? "",
                                        productSellingPrice:
                                            lucidService.mrpPriceList ?? 0,
                                        productDiscountPrice:
                                            lucidService.finalMrp,
                                        imageUrl: lucidService.image ??
                                            'assets/images/mri-scan.png',
                                        themeController: themeController,
                                        discount: lucidService.discount ?? 0,
                                        isAppointmentRequired: lucidService
                                                .isAppointmentRequired ??
                                            "N",
                                        hc: widget.typesNeeded ? "1" : "0",
                                        index: index,
                                        onAddToCartTap: () {
                                          cartController.getTestUserDetails(
                                              isHomeCollection:
                                                  widget.typesNeeded
                                                      ? '1'
                                                      : '0');
                                          lucidController
                                              .getAddTest(
                                                  serviceCd:
                                                      lucidService.serviceCd!,
                                                  serviceName:
                                                      lucidService.serviceName!,
                                                  imageUrl: lucidService.image!,
                                                  discount:
                                                      lucidService.discount!,
                                                  finalMrp:
                                                      lucidService.finalMrp!,
                                                  mrpPrice: lucidService
                                                      .mrpPriceList!,
                                                  hv: widget.typesNeeded
                                                      ? "1"
                                                      : "0",
                                                  isAppointmentRequired:
                                                      lucidService
                                                              .isAppointmentRequired ??
                                                          "N",
                                                  isHealthPackage: 'N')
                                              .then(
                                            (value) {
                                              cartController
                                                  .getDiagnosticCartData(
                                                      homeCollection:
                                                          widget.typesNeeded
                                                              ? "1"
                                                              : "0");
                                            },
                                          );
                                        },
                                        onTap: () {
                                          Get.to(() => TestDescriptionScreen(
                                                serviceId:
                                                    lucidService.serviceCd ??
                                                        "",
                                                image: lucidService.image ??
                                                    'assets/images/mri-scan.png',
                                                title:
                                                    lucidService.serviceName ??
                                                        "",
                                                finalMrp:
                                                    lucidService.finalMrp ?? 0,
                                                orginMrp:
                                                    lucidService.mrpPriceList ??
                                                        0,
                                                discount:
                                                    lucidService.discount ?? 0,
                                                description:
                                                    lucidService.description ??
                                                        "",
                                                turnaroundTime:
                                                    lucidService.turnaroundTime,
                                                hc: widget.typesNeeded
                                                    ? "1"
                                                    : "0",
                                                isAppointmentRequired: lucidService
                                                        .isAppointmentRequired ??
                                                    "N",
                                                ishomeCollection: lucidService
                                                        .homeCollection ??
                                                    '',
                                              ));
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Gap(30),
                    if (lucidController.islucidMoreServicesLoading.value)
                      CircularProgressIndicator()
                  ],
                ),
              ),
              if (widget.typesNeeded
                  ? cartController.diagnosticHomeTests.isNotEmpty
                  : cartController.diagnosticCartTests.isNotEmpty)
                Positioned(
                    bottom: 25,
                    right: 18,
                    width: 90.w,
                    child: GestureDetector(
                      onTap: () {
                        cartController.rebook.value = false;
                        sampleCollectionController.clearForm();
                        Get.to(() => SampleCollectionScreen(
                            homeCollection: widget.typesNeeded));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: themeController.nav1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            cartController.diagnosticCartTests.length == 1
                                ? Expanded(
                                    child: AppText(
                                      "${widget.typesNeeded ? cartController.diagnosticHomeTests.length : cartController.diagnosticCartTests.length} Test Added",
                                      color: themeController.textPrimaryColor,
                                      fontFamily: AppFont.poppins,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                                : Expanded(
                                    child: AppText(
                                      "${widget.typesNeeded ? cartController.diagnosticHomeTests.length : cartController.diagnosticCartTests.length} Tests Added",
                                      color: themeController.textPrimaryColor,
                                      fontFamily: AppFont.poppins,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                            Row(
                              children: [
                                cartController
                                        .isDiagnosticUSerDetailsLoading.value
                                    ? AppText(
                                        "Loading....    ",
                                        color: themeController.textPrimaryColor,
                                        fontFamily: AppFont.poppins,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w300,
                                      )
                                    : cartController.testUserDetails.value ==
                                            null
                                        ? AppText(
                                            "Fill the details",
                                            color: themeController
                                                .textPrimaryColor,
                                            fontFamily: AppFont.poppins,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w300,
                                          )
                                        : AppText(
                                            " View details",
                                            color: themeController
                                                .textPrimaryColor,
                                            fontFamily: AppFont.poppins,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w300,
                                          ),
                                Icon(
                                  Icons.chevron_right,
                                  color: themeController.textPrimaryColor,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
              if (cartController.isTestDeletingLoading.value ||
                  lucidController.isAddCartLoading.value)
                Positioned(
                    right: 0,
                    top: 0,
                    left: 0,
                    bottom: 0,
                    child: SizedBox(
                        height: 25,
                        width: 25,
                        child: AppLoader(
                          color: themeController.navShadow1,
                        )))
            ]),
          ),
        ),
      );
    });
  }
}
