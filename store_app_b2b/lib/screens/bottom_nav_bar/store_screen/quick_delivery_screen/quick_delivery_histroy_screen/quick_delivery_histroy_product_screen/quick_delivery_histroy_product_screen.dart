import 'package:flutter/material.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/model/quick_product_history_model.dart';

class QuickDeliveryProductHistoryScreen extends StatelessWidget {
  final List<Item> productItems;
  const QuickDeliveryProductHistoryScreen(
      {super.key, required this.productItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: CommonText(
          content: 'Order details',
          boldNess: FontWeight.w600,
          textSize: 14,
        ),
        elevation: 0,
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
      body: orderDetailsView(productItems),
    );
  }

  orderDetailsView(List<Item> productItems) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Row(children: [
            Expanded(
              flex: 2,
              child: CommonText(
                content: 'Products',
                textColor: Colors.black,
                textSize: 18,
                boldNess: FontWeight.w500,
              ),
            ),
            Expanded(
                child: CommonText(
                    content: 'Qty',
                    textSize: 14,
                    textColor: Colors.black,
                    textAlign: TextAlign.center)),
            Expanded(
                child: CommonText(
                    content: 'Free Qty',
                    textSize: 14,
                    textColor: Colors.black,
                    textAlign: TextAlign.center)),
            Expanded(
                child: CommonText(
              content: 'Total Qty',
              textSize: 14,
              textColor: Colors.black,
              textAlign: TextAlign.center,
            )),
          ]),
          Column(
            children: productItems
                .map((e) => Container(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Color(0xffCFCFCF))),
                      ),
                      child: Row(children: [
                        Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonText(
                                  content: e.productName ?? '',
                                  textColor: const Color(0xff343434),
                                  textSize: 14,
                                ),
                                CommonText(
                                  content: e.manufacturer ?? '',
                                  textColor: const Color(0xff949292),
                                  textSize: 12,
                                ),
                              ],
                            )),
                        Expanded(
                            child: CommonText(
                                content: '${e.quantity ?? 0}',
                                textSize: 14,
                                textColor: Colors.black,
                                textAlign: TextAlign.center)),
                        Expanded(
                            child: CommonText(
                                content: '${e.freeQuantity ?? 0}',
                                textSize: 14,
                                textColor: Colors.black,
                                textAlign: TextAlign.center)),
                        Expanded(
                            child: CommonText(
                          content: '${e.totalQuantity ?? 0}',
                          textSize: 14,
                          textColor: Colors.black,
                          textAlign: TextAlign.center,
                        )),
                      ]),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
