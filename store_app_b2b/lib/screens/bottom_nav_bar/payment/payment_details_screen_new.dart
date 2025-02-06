import 'package:b2c/constants/colors_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/constants/loader_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/payment_controller/payment_controller_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/payment/payment_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/payment/tax_invoice_screen_new.dart';
import 'package:store_app_b2b/widget/payment_product_tab_new.dart';
import 'package:store_app_b2b/widget/payment_transaction_tab.dart';

class PaymentDetailsScreen extends StatefulWidget {
  final String orderId;
  final String payerId;
  final String storeId;

  const PaymentDetailsScreen(
      {super.key,
      required this.orderId,
      required this.storeId,
      required this.payerId});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController paymentDetailsTabController;

  @override
  void initState() {
    paymentDetailsTabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    paymentDetailsTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(
      init: PaymentController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: ColorsConst.bgColor,
          appBar: AppBar(
            centerTitle: true,
            title: const CommonText(content: 'Payments', textSize: 18),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff2F394B),
                    Color(0xff090F1A),
                  ],
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              DefaultTabController(
                initialIndex: 0,
                length: 2,
                child: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Material(
                    color: Colors.white,
                    child: TabBar(
                      controller: paymentDetailsTabController,
                      indicatorColor: ColorsConst.primaryColor,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorWeight: 0,
                      indicator: const MD2Indicator(
                        indicatorSize: MD2IndicatorSize.normal,
                        indicatorHeight: 3.0,
                        indicatorColor: Colors.orange,
                      ),
                      onTap: (value) async {
                        if (value == 0) {
                          //await cartController.getVerifiedProductDataApi();
                        } else if (value == 1) {
                          // await cartController.getProductFindApiList();
                        }
                      },
                      tabs: const [
                        Tab(
                          child: CommonText(
                            content: "Products",
                            textColor: Colors.black,
                            boldNess: FontWeight.w600,
                          ),
                        ),
                        Tab(
                          child: CommonText(
                            content: "Transactions",
                            textColor: Colors.black,
                            boldNess: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: paymentDetailsTabController,
                  children: [
                    PaymentProductTab(
                      payerId: widget.payerId,
                      orderId: widget.orderId,
                      storeId: widget.storeId,
                    ),
                    PaymentTransactionTab(
                      payerId: widget.payerId,
                      orderId: widget.orderId,
                      storeId: widget.storeId,
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
