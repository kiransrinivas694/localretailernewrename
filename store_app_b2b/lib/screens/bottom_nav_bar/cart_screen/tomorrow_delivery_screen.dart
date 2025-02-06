import 'package:flutter/material.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/payment/payment_screen.dart';
import 'package:store_app_b2b/widget/tomorrow_delivery_tab.dart';
import 'package:store_app_b2b/widget/tomorrow_delivery_unavailable_tab.dart';

class TomorrowDeliveryScreen extends StatefulWidget {
  const TomorrowDeliveryScreen({super.key});

  @override
  State<TomorrowDeliveryScreen> createState() => _TomorrowDeliveryScreenState();
}

class _TomorrowDeliveryScreenState extends State<TomorrowDeliveryScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 3,
            ),
            DefaultTabController(
              length: 2,
              child: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Material(
                  color: Colors.white,
                  child: TabBar(
                    indicatorColor: ColorsConst.primaryColor,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 0,
                    indicator: const MD2Indicator(
                      indicatorSize: MD2IndicatorSize.normal,
                      indicatorHeight: 3.0,
                      indicatorColor: Colors.orange,
                    ),
                    controller: tabController,
                    tabs: [
                      Tab(
                        height: 40,
                        child: CommonText(
                          content: "Available",
                          textAlign: TextAlign.center,
                          textColor: Colors.black,
                          boldNess: FontWeight.w600,
                        ),
                      ),
                      Tab(
                        height: 40,
                        child: CommonText(
                          content: "Unavailable",
                          textAlign: TextAlign.center,
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
                child: TabBarView(controller: tabController, children: [
              // Container(
              //   height: double.infinity,
              //   width: double.infinity,
              //   color: Colors.blue,
              // ),
              TomorrowDeliveryTab(),
              TomorrowDeliveryUnavailableTab()
            ]))
          ],
        ));
  }
}
