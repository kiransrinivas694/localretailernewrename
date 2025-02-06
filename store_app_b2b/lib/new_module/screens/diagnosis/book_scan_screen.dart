import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/constants/loader.dart';

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
import 'package:store_app_b2b/screens/auth/sign_up_2_screen.dart';

class BookScanScreen extends StatefulWidget {
  const BookScanScreen({
    super.key,
    required this.appBarTitle,
  });
  final String appBarTitle;

  @override
  State<BookScanScreen> createState() => _BookScanScreenState();
}

class _BookScanScreenState extends State<BookScanScreen> {
  final ThemeController themeController = Get.find();

  LucidController lucidController = Get.put(LucidController());
  final CartLabtestController cartController = Get.put(CartLabtestController());
  SampleCollectionController sampleCollectionController =
      Get.put(SampleCollectionController());
  final bool homeCollection = false;
  @override
  void initState() {
    LucidController lucidController = Get.put(LucidController());
    lucidController.scanSearchController.clear();
    lucidController.showSuffixForSearchScanController.call(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppAppBar(
          title: widget.appBarTitle,
          backgroundColor: themeController.textPrimaryColor,
          isTitleNeeded: true,
          isIconNeeded: true,
        ),
        body: Obx(
          () => Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: [
                    Obx(
                      () => AppSearchBox(
                        showSuffixIcon: lucidController
                            .showSuffixForSearchScanController.value,
                        onSuffixIconTap: () {
                          lucidController.scanSearchController.text = "";
                          lucidController.scanServicesCurrentPage.value = 0;
                          lucidController.scanServicesPageSize.value = 8;
                          lucidController.scanServicesTotalPages.value = 0;
                          lucidController.getlucidByDepartment(
                            searchText: "",
                          );

                          lucidController
                              .showSuffixForSearchScanController.value = false;
                        },
                        textEditingController:
                            lucidController.scanSearchController,
                        onChange: (value) {
                          lucidController.scanServicesCurrentPage.value = 0;
                          lucidController.scanServicesPageSize.value = 8;
                          lucidController.scanServicesTotalPages.value = 0;
                          lucidController.getlucidByDepartment(
                            searchText: value,
                          );
                          lucidController.showSuffixForSearchScanController
                              .value = value.isNotEmpty;
                        },
                      ),
                    ),
                    const Gap(15),
                    Expanded(
                      child: Obx(
                        () => lucidController.isScanServicesLoading.value
                            ? verticalShimmerGridView()
                            : NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  if (notification is ScrollEndNotification &&
                                      notification.metrics.extentAfter == 0) {
                                    if (lucidController
                                            .isScanMoreServicesLoading.value ||
                                        lucidController
                                            .isScanServicesLoading.value) {
                                      return false;
                                    }

                                    lucidController.getlucidByDepartment(
                                        loadMore: true,
                                        searchText: lucidController
                                            .scanSearchController.text);
                                  }
                                  return false;
                                },
                                child: Obx(
                                  () => AlignedGridView.count(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: 10,
                                    itemCount:
                                        lucidController.scanServices.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      BasicLucidModel scanService =
                                          lucidController.scanServices[index];

                                      logs(
                                          "loading lucid image -> ${scanService.image}");
                                      return ServiceCardWidget(
                                        serviceId: scanService.serviceCd ?? "",
                                        productTitle:
                                            scanService.serviceName ?? "",
                                        productSellingPrice:
                                            scanService.mrpPriceList ?? 0,
                                        productDiscountPrice:
                                            scanService.finalMrp,
                                        imageUrl: scanService.image ??
                                            'assets/images/mri-scan.png',
                                        themeController: themeController,
                                        discount: scanService.discount ?? 0,
                                        hc: "0",
                                        isAppointmentRequired:
                                            scanService.isAppointmentRequired ??
                                                "N",
                                        index: index,
                                        onAddToCartTap: () {
                                          cartController.getTestUserDetails(
                                              isHomeCollection: '0');
                                          lucidController
                                              .getAddTest(
                                                  serviceCd:
                                                      scanService.serviceCd!,
                                                  serviceName:
                                                      scanService.serviceName!,
                                                  imageUrl: scanService.image!,
                                                  discount:
                                                      scanService.discount!,
                                                  finalMrp:
                                                      scanService.finalMrp!,
                                                  mrpPrice:
                                                      scanService.mrpPriceList!,
                                                  hv: '0',
                                                  isAppointmentRequired: scanService
                                                          .isAppointmentRequired ??
                                                      "N",
                                                  isHealthPackage: 'N')
                                              .then(
                                            (value) {
                                              cartController
                                                  .getDiagnosticCartData(
                                                      homeCollection: '0');
                                            },
                                          );
                                        },
                                        onTap: () {
                                          Get.to(() => TestDescriptionScreen(
                                                image: scanService.image ??
                                                    'assets/images/mri-scan.png',
                                                title:
                                                    scanService.serviceName ??
                                                        "",
                                                finalMrp:
                                                    scanService.finalMrp ?? 0,
                                                orginMrp:
                                                    scanService.mrpPriceList ??
                                                        0,
                                                discount:
                                                    scanService.discount ?? 0,
                                                description:
                                                    scanService.description ??
                                                        "",
                                                turnaroundTime:
                                                    scanService.turnaroundTime,
                                                serviceId:
                                                    scanService.serviceCd ?? "",
                                                hc: "0",
                                                isAppointmentRequired: scanService
                                                        .isAppointmentRequired ??
                                                    "N",
                                                ishomeCollection: scanService
                                                        .homeCollection ??
                                                    'N',
                                                helpLine: scanService
                                                        .helpLineNumber ??
                                                    "",
                                              ));
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Gap(3.h),
                    if (lucidController.isScanMoreServicesLoading.value)
                      CircularProgressIndicator()
                  ],
                ),
              ),
              if (homeCollection
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
                        Get.to(() =>
                            SampleCollectionScreen(homeCollection: false));
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
                                      "${homeCollection ? cartController.diagnosticHomeTests.length : cartController.diagnosticCartTests.length} Test Added",
                                      color: themeController.textPrimaryColor,
                                      fontFamily: AppFont.poppins,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                                : Expanded(
                                    child: AppText(
                                      "${homeCollection ? cartController.diagnosticHomeTests.length : cartController.diagnosticCartTests.length} Tests Added",
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
                            ),
                          ],
                        ),
                      ),
                    )),
              if (lucidController.isAddCartLoading.value ||
                  cartController.isTestDeletingLoading.value)
                Positioned(
                    right: 0,
                    top: 0,
                    left: 0,
                    bottom: 0,
                    child: SizedBox(
                        height: 5,
                        width: 5,
                        child: AppLoader(
                          color: themeController.navShadow1,
                        )))
            ],
          ),
        ),
      ),
    );
  }
}
