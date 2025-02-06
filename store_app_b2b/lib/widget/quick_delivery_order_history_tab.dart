import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:store_app_b2b/components/common_border_button.dart';
import 'package:store_app_b2b/components/common_primary_button.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/constants/loader.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/quick_delivery_controller/quick_delivery_controller.dart';
import 'package:store_app_b2b/model/quick_product_history_model.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/quick_delivery_screen/quick_delivery_histroy_screen/quick_delivery_histroy_product_screen/quick_delivery_histroy_product_screen.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/quick_delivery_screen/quick_delivery_histroy_screen/quick_delivery_invoice_screen/quick_delivery_invoice_screen.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/quick_delivery_screen/quick_place_payment_screen/quick_place_payment_screen.dart';
import 'package:store_app_b2b/service/api_service.dart';
import 'package:store_app_b2b/widget/app_image_assets.dart';
import 'package:url_launcher/url_launcher_string.dart';

class QuickDeliveryOrderHistoryTab extends StatefulWidget {
  const QuickDeliveryOrderHistoryTab({super.key});

  @override
  State<QuickDeliveryOrderHistoryTab> createState() =>
      _QuickDeliveryOrderHistoryTabState();
}

class _QuickDeliveryOrderHistoryTabState
    extends State<QuickDeliveryOrderHistoryTab> {
  int page = 0;
  RxBool isLoadingMore = false.obs;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
      init: QuickDeliveryController(),
      initState: (state) {
        Future.delayed(
          Duration(milliseconds: 150),
          () async {
            QuickDeliveryController controller =
                Get.find<QuickDeliveryController>();
            controller.historyProductList.clear();
            await controller.getProductHistory(page: 0, size: 10);
            scrollController.addListener(
              () async {
                if (scrollController.position.pixels ==
                    scrollController.position.maxScrollExtent) {
                  isLoadingMore.value = true;
                  page = page + 1;
                  await controller.getProductHistory(
                      page: page, size: 10, isLoad: false);
                  isLoadingMore.value = false;
                }
              },
            );
          },
        );
      },
      builder: (controller) {
        return Stack(
          children: [
            (controller.historyProductList.isEmpty)
                ? Center(
                    child: CommonText(
                        content: 'No Orders Found',
                        textColor: ColorsConst.textColor,
                        textSize: 18,
                        boldNess: FontWeight.w500),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: controller.historyProductList.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return waitingCardView(
                                  controller.historyProductList[index],
                                  controller);
                            },
                          ),
                        ),
                        Obx(() => (isLoadingMore.value)
                            ? Center(child: CircularProgressIndicator())
                            : SizedBox()),
                      ],
                    ),
                  ),
            if (controller.isLoading.value)
              AppLoader(color: ColorsConst.primaryColor)
          ],
        );
      },
    );
  }

  Widget waitingCardView(
      Content historyProduct, QuickDeliveryController controller) {
    return GestureDetector(
      onTap: () => Get.to(QuickDeliveryProductHistoryScreen(
          productItems: historyProduct.items)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(color: ColorsConst.appBorderGrey, width: 1.2)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: DashedBorder(
                dashLength: 3,
                left: BorderSide.none,
                top: BorderSide.none,
                right: BorderSide.none,
                bottom: BorderSide(
                  color: ColorsConst.borderColor,
                  width: 1,
                ),
              )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    content: 'Order ID : ${historyProduct.id ?? ''}',
                    boldNess: FontWeight.w500,
                    textSize: 16,
                    textColor: Colors.black,
                  ),
                  CommonText(
                    content: 'Supplier : ${historyProduct.storeName ?? ''}',
                    boldNess: FontWeight.w500,
                    textSize: 16,
                    textColor: Colors.black,
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        content: 'Invoice Bill',
                        boldNess: FontWeight.w500,
                        textSize: 16,
                        textColor: Color(0xff6C6868),
                      ),
                      if (historyProduct.invoiceUrl == null ||
                          historyProduct.invoiceUrl!.isEmpty)
                        CommonText(
                          content: 'Waiting',
                          boldNess: FontWeight.w500,
                          textSize: 18,
                          decoration: TextDecoration.underline,
                          textColor: ColorsConst.primaryColor,
                        ),
                    ],
                  ),
                  if (historyProduct.invoiceUrl != null &&
                      historyProduct.invoiceUrl!.isNotEmpty)
                    InkWell(
                      onTap: () => Get.to(QuickDeliveryInvoiceScreen(
                          invoiceUrl: historyProduct.invoiceUrl!,
                          invoiceNumber: historyProduct.invoiceNumber)),
                      child: Container(
                          height: 100,
                          margin: EdgeInsets.only(bottom: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Color(0xff08B510), width: 1.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 53,
                                child: (historyProduct.invoiceUrl!
                                        .contains('.pdf'))
                                    ? PDF(enableSwipe: false).cachedFromUrl(
                                        historyProduct.invoiceUrl ?? '',
                                        placeholder: (progress) =>
                                            Center(child: Text('$progress %')),
                                        errorWidget: (error) => Center(
                                            child: Text(error.toString())),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: AppImageAsset(
                                            image: historyProduct.invoiceUrl,
                                            fit: BoxFit.cover)),
                                decoration: BoxDecoration(
                                  color: ColorsConst.greyTextColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: CommonText(
                                  content: 'Order Invoice file.pdf',
                                  textSize: 14,
                                  boldNess: FontWeight.w500,
                                  textColor: Color(0xff888888),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: Get.width * 0.07),
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: CommonText(
                                      content: 'View',
                                      textSize: 16,
                                      boldNess: FontWeight.w500,
                                      textColor: ColorsConst.primaryColor,
                                      decoration: TextDecoration.underline,
                                      textAlign: TextAlign.center,
                                    )),
                              ),
                            ],
                          )),
                    ),
                ],
              ),
            ),
            if (historyProduct.invoiceAmount != null &&
                historyProduct.invoicePaidTransStatus != 'sucess'.toLowerCase())
              SizedBox(
                height: 10,
              ),
            if (historyProduct.invoiceAmount != null &&
                historyProduct.invoicePaidTransStatus != 'sucess'.toLowerCase())
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(
                    content: 'Amount Payable',
                    boldNess: FontWeight.w500,
                    textSize: 16,
                    textColor: Colors.black,
                  ),
                  CommonText(
                    content:
                        '${historyProduct.invoiceAmount!.toStringAsFixed(2)}',
                    boldNess: FontWeight.w500,
                    textSize: 16,
                    textColor: Colors.black,
                  ),
                ],
              ),
            SizedBox(height: 8),
            if (historyProduct.invoiceAmount != null &&
                historyProduct.invoicePaidTransStatus == 'sucess'.toLowerCase())
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        content: 'Amount Payable',
                        boldNess: FontWeight.w500,
                        textSize: 16,
                        textColor: Colors.black,
                      ),
                      CommonText(
                        content:
                            '${historyProduct.invoiceAmount!.toStringAsFixed(2)}',
                        boldNess: FontWeight.w500,
                        textSize: 16,
                        textColor: Colors.black,
                      ),
                    ],
                  ),
                  CommonText(
                    content: 'Amount Paid Successfully to Supplier',
                    textColor: Color(0xff1EAA24),
                    textSize: 16,
                    boldNess: FontWeight.w500,
                  ),
                  SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        content: 'Agent ',
                        textSize: 14,
                        textColor: Color(0xff6E6E6E),
                        boldNess: FontWeight.w500,
                      ),
                      Flexible(
                        child: CommonText(
                          content: '${historyProduct.riderName ?? ''}',
                          textColor: Color(0xff2E2E2E),
                          textSize: 14,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          boldNess: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 5),
                      InkWell(
                        onTap: () => launchUrlString(
                            "tel://${(historyProduct.riderContactNumber == null || historyProduct.riderContactNumber!.isEmpty) ? API.customerCareNumber : historyProduct.riderContactNumber}"),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/voice_call.png',
                              package: 'store_app_b2b',
                              height: 20,
                              width: 14,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 8),
                            CommonText(
                              content: 'Call',
                              textColor: ColorsConst.primaryColor,
                              textSize: 14,
                              decoration: TextDecoration.underline,
                              boldNess: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (historyProduct.riderStatus != null &&
                    historyProduct.riderStatus!.isNotEmpty)
                  Container(
                    height: 40,
                    padding: EdgeInsets.all(5),
                    constraints: BoxConstraints(maxWidth: 180),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ColorsConst.primaryColor),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/quick_delivery.png',
                          package: 'store_app_b2b',
                          height: 25,
                          width: 20,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: CommonText(
                            content: '${historyProduct.riderStatus ?? ''}',
                            textSize: 14,
                            textColor: ColorsConst.primaryColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            boldNess: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (historyProduct.invoiceAmount != null &&
                    historyProduct.invoicePaidTransStatus !=
                        'sucess'.toLowerCase())
                  GestureDetector(
                    onTap: () => controller.openPayHistoryProductCheckout(
                        historyProduct.invoiceAmount ?? 0,
                        historyProduct.id ?? ''),
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      constraints: BoxConstraints(maxWidth: 100),
                      decoration: BoxDecoration(
                        color: ColorsConst.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CommonText(
                        content: 'Pay Now',
                        textSize: 15,
                        boldNess: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            if (historyProduct.invoiceAmount != null &&
                historyProduct.riderStatusEventId == "6")
              SizedBox(
                height: 10,
              ),
            if (historyProduct.confirmDelivery != "Y" &&
                historyProduct.riderStatusEventId == "6")
              GestureDetector(
                onTap: () {
                  controller.changeRiderRating(0.0);
                  Get.dialog(confirmDeliveryDialog(historyProduct, controller));
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.all(5),
                  constraints: BoxConstraints(maxWidth: 240),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ColorsConst.primaryColor),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: CommonText(
                          content: 'Click here to Confirm Delivery...!',
                          textSize: 14,
                          textColor: ColorsConst.primaryColor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          boldNess: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget payNowCardView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(color: ColorsConst.appBorderGrey, width: 1.2)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                border: DashedBorder(
              dashLength: 3,
              left: BorderSide.none,
              top: BorderSide.none,
              right: BorderSide.none,
              bottom: BorderSide(
                color: ColorsConst.borderColor,
                width: 1,
              ),
            )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  content: 'Order ID : Acty00072',
                  boldNess: FontWeight.w500,
                  textSize: 16,
                  textColor: Colors.black,
                ),
                CommonText(
                  content: 'Supplier : M.R.Pharma',
                  boldNess: FontWeight.w500,
                  textSize: 16,
                  textColor: Colors.black,
                ),
                SizedBox(height: 5),
                CommonText(
                  content: 'Invoice Bill',
                  boldNess: FontWeight.w500,
                  textSize: 16,
                  textColor: Color(0xff6C6868),
                ),
                SizedBox(height: 5),
                Container(
                    height: 100,
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff08B510), width: 1.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 53,
                          decoration: BoxDecoration(
                            color: ColorsConst.greyTextColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: CommonText(
                            content: 'Order Invoice file.pdf',
                            textSize: 14,
                            boldNess: FontWeight.w500,
                            textColor: Color(0xff888888),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Get.width * 0.07),
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: CommonText(
                                content: 'View',
                                textSize: 16,
                                boldNess: FontWeight.w500,
                                textColor: ColorsConst.primaryColor,
                                decoration: TextDecoration.underline,
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                content: 'Amount Payable',
                textSize: 15,
                textColor: Colors.black,
                boldNess: FontWeight.w500,
              ),
              CommonText(
                content: '540.00',
                textColor: ColorsConst.greyTextColor,
                textSize: 15,
                boldNess: FontWeight.w500,
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 40,
                padding: EdgeInsets.all(5),
                constraints: BoxConstraints(maxWidth: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorsConst.primaryColor),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/quick_delivery.png',
                      package: 'store_app_b2b',
                      height: 25,
                      width: 20,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 5),
                    Flexible(
                      child: CommonText(
                        content: 'Ready for Delivery..',
                        textSize: 14,
                        textColor: ColorsConst.primaryColor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        boldNess: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Get.to(() => QuickPaymentPlacedScreen(
                      showStatusButton: false,
                      message: 'Your Payment has been Received Successfully',
                    )),
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  constraints: BoxConstraints(maxWidth: 100),
                  decoration: BoxDecoration(
                    color: ColorsConst.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CommonText(
                    content: 'Pay Now',
                    textSize: 15,
                    boldNess: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget stockReachCardView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(color: ColorsConst.appBorderGrey, width: 1.2)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                border: DashedBorder(
              dashLength: 3,
              left: BorderSide.none,
              top: BorderSide.none,
              right: BorderSide.none,
              bottom: BorderSide(
                color: ColorsConst.borderColor,
                width: 1,
              ),
            )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  content: 'Order ID : Acty00072',
                  boldNess: FontWeight.w500,
                  textSize: 16,
                  textColor: Colors.black,
                ),
                CommonText(
                  content: 'Supplier : M.R.Pharma',
                  boldNess: FontWeight.w500,
                  textSize: 16,
                  textColor: Colors.black,
                ),
                SizedBox(height: 5),
                CommonText(
                  content: 'Invoice Bill',
                  boldNess: FontWeight.w500,
                  textSize: 16,
                  textColor: Color(0xff6C6868),
                ),
                SizedBox(height: 5),
                Container(
                    height: 100,
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff08B510), width: 1.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 53,
                          decoration: BoxDecoration(
                            color: ColorsConst.greyTextColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: CommonText(
                            content: 'Order Invoice file.pdf',
                            textSize: 14,
                            boldNess: FontWeight.w500,
                            textColor: Color(0xff888888),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Get.width * 0.07),
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: CommonText(
                                content: 'View',
                                textSize: 16,
                                boldNess: FontWeight.w500,
                                textColor: ColorsConst.primaryColor,
                                decoration: TextDecoration.underline,
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                content: 'Amount Payable',
                textSize: 15,
                textColor: Colors.black,
                boldNess: FontWeight.w500,
              ),
              CommonText(
                content: '540.00',
                textColor: ColorsConst.greyTextColor,
                textSize: 15,
                boldNess: FontWeight.w500,
              ),
            ],
          ),
          SizedBox(height: 5),
          CommonText(
            content: 'Amount Paid Successfully to Supplier',
            textSize: 15,
            textColor: ColorsConst.greenButtonColor,
            boldNess: FontWeight.w500,
          ),
          SizedBox(height: 5),
          Row(
            children: [
              CommonText(
                content: 'Agent',
                textSize: 14,
                textColor: Color(0xff6E6E6E),
                boldNess: FontWeight.w500,
              ),
              CommonText(
                content: ' Hemanth Kumar',
                textColor: Color(0xff2E2E2E),
                textSize: 14,
                boldNess: FontWeight.w500,
              ),
              SizedBox(width: 10),
              Row(
                children: [
                  Image.asset(
                    'assets/icons/voice_call.png',
                    package: 'store_app_b2b',
                    height: 20,
                    width: 14,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 8),
                  CommonText(
                    content: 'Call',
                    textColor: ColorsConst.primaryColor,
                    textSize: 14,
                    decoration: TextDecoration.underline,
                    boldNess: FontWeight.w500,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: 40,
            padding: EdgeInsets.all(5),
            constraints: BoxConstraints(maxWidth: 262),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ColorsConst.primaryColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/quick_delivery.png',
                  package: 'store_app_b2b',
                  height: 25,
                  width: 20,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 5),
                Flexible(
                  child: CommonText(
                    content: 'Your Stocks Reaching Shortly',
                    textSize: 13,
                    textColor: ColorsConst.primaryColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    boldNess: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget stockDeliveredCardView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(color: ColorsConst.appBorderGrey, width: 1.2)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                border: DashedBorder(
              dashLength: 3,
              left: BorderSide.none,
              top: BorderSide.none,
              right: BorderSide.none,
              bottom: BorderSide(
                color: ColorsConst.borderColor,
                width: 1,
              ),
            )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  content: 'Order ID : Acty00072',
                  boldNess: FontWeight.w500,
                  textSize: 16,
                  textColor: Colors.black,
                ),
                CommonText(
                  content: 'Supplier : M.R.Pharma',
                  boldNess: FontWeight.w500,
                  textSize: 16,
                  textColor: Colors.black,
                ),
                SizedBox(height: 5),
                CommonText(
                  content: 'Invoice Bill',
                  boldNess: FontWeight.w500,
                  textSize: 16,
                  textColor: Color(0xff6C6868),
                ),
                SizedBox(height: 5),
                Container(
                    height: 100,
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff08B510), width: 1.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 53,
                          decoration: BoxDecoration(
                            color: ColorsConst.greyTextColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: CommonText(
                            content: 'Order Invoice file.pdf',
                            textSize: 14,
                            boldNess: FontWeight.w500,
                            textColor: Color(0xff888888),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Get.width * 0.07),
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: CommonText(
                                content: 'View',
                                textSize: 16,
                                boldNess: FontWeight.w500,
                                textColor: ColorsConst.primaryColor,
                                decoration: TextDecoration.underline,
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                content: 'Amount Payable',
                textSize: 15,
                textColor: Colors.black,
                boldNess: FontWeight.w500,
              ),
              CommonText(
                content: '540.00',
                textColor: ColorsConst.greyTextColor,
                textSize: 15,
                boldNess: FontWeight.w500,
              ),
            ],
          ),
          SizedBox(height: 5),
          CommonText(
            content: 'Amount Paid Successfully to Supplier',
            textSize: 15,
            textColor: ColorsConst.greenButtonColor,
            boldNess: FontWeight.w500,
          ),
          SizedBox(height: 5),
          Container(
            height: 40,
            alignment: Alignment.center,
            padding: EdgeInsets.all(5),
            constraints: BoxConstraints(maxWidth: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ColorsConst.primaryColor),
            ),
            child: CommonText(
              content: 'Your Stocks Delivered...!',
              textSize: 13,
              textColor: ColorsConst.primaryColor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              boldNess: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    content: 'Agent',
                    textSize: 14,
                    textColor: Color(0xff6E6E6E),
                  ),
                  CommonText(
                    content: 'Hemanth Kumar',
                    textSize: 14,
                    boldNess: FontWeight.w500,
                    textColor: Colors.black,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    content: 'Rating',
                    textSize: 14,
                    boldNess: FontWeight.w500,
                    textColor: ColorsConst.greyTextColor,
                  ),
                  RatingBar.builder(
                    initialRating: 4,
                    itemSize: 20,
                    minRating: 1,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2),
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    ignoreGestures: true,
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                      Icons.star_outlined,
                      color: ColorsConst.primaryColor,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget confirmDeliveryDialog(
      Content historyProduct, QuickDeliveryController controller) {
    return AlertDialog(
      titlePadding: const EdgeInsets.symmetric(vertical: 3),
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      content: Container(
        height: 230,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              content: "Delivery Done By",
              textColor: Color.fromARGB(155, 144, 144, 1),
            ),
            const SizedBox(
              height: 5,
            ),
            CommonText(
              content: historyProduct.riderName ?? "",
              textColor: Color.fromRGBO(0, 0, 0, 1),
              boldNess: FontWeight.w500,
              textSize: 16,
            ),
            const SizedBox(
              height: 16,
            ),
            CommonText(
              content: "Rating",
              textColor: Color.fromRGBO(0, 0, 0, 1),
              boldNess: FontWeight.w500,
              textSize: 16,
            ),
            const SizedBox(
              height: 10,
            ),
            RatingBar.builder(
              initialRating: 0,
              itemSize: 30,
              minRating: 0,
              itemPadding: EdgeInsets.symmetric(horizontal: 2),
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                Icons.star_outlined,
                color: ColorsConst.primaryColor,
              ),
              onRatingUpdate: (rating) {
                controller.changeRiderRating(rating);
              },
            ),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                controller.orderConfirmDelivery(
                    cartId: historyProduct.id, page: page, size: 10);
              },
              child: Container(
                height: 40,
                padding: EdgeInsets.symmetric(vertical: 4),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 122, 0, 1),
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
