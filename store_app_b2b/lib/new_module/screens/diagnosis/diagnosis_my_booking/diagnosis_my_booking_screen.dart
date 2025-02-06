import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:store_app_b2b/new_module/controllers/cart_controller/cart_labtest_controller.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/diagnosis_my_booking/diagnosis_cancelled_screen.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/diagnosis_my_booking/diagnosis_completed_screen.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/diagnosis_my_booking/diagnosis_upcoming_screen.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_app_bar.dart';

class DiagnosisMyBookingScreen extends StatefulWidget {
  const DiagnosisMyBookingScreen({super.key});

  @override
  State<DiagnosisMyBookingScreen> createState() =>
      _DiagnosisMyBookingScreenState();
}

class _DiagnosisMyBookingScreenState extends State<DiagnosisMyBookingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    CartLabtestController controller = Get.put(CartLabtestController());
    super.initState();
    int initialIndex =
        Get.arguments == null ? 0 : Get.arguments["initialIndex"] ?? 0;
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: initialIndex);
    controller.getLucidUserUpcomingStatus(status: initialIndex);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        controller.getLucidUserUpcomingStatus(status: _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final ThemeController themeController = Get.find();
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GetBuilder<CartLabtestController>(
        init: CartLabtestController(),
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              appBar: const AppAppBar(title: 'My Bookings'),
              body: Container(
                height: double.infinity,
                width: double.infinity,
                // padding: EdgeInsets.symmetric(horizontal: 16),
                color: themeController.textPrimaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 45,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      child: Theme(
                        data: theme.copyWith(
                          colorScheme: theme.colorScheme.copyWith(
                              // mysaa commented
                              // surfaceContainerHighest: Colors.transparent,
                              ),
                        ),
                        child: TabBar(
                          labelStyle: TextStyle(
                            fontFamily: AppFont.poppins,
                            color: themeController.black500Color,
                            fontWeight: FontWeight.w600,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontFamily: AppFont.poppins,
                            color: Color.fromRGBO(156, 163, 175, 1),
                            fontWeight: FontWeight.w600,
                          ),
                          dividerColor: Colors.transparent,
                          controller: _tabController,
                          indicatorColor: themeController.nav1,
                          indicatorWeight: 4,
                          labelColor: themeController.black500Color,
                          unselectedLabelColor: themeController.black75Color,
                          tabs: const [
                            Tab(
                              text: "Upcoming",
                            ),
                            Tab(
                              text: "Completed",
                            ),
                            Tab(
                              text: "Cancelled",
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: [
                          DiagnosisUpcomingScreen(),
                          DiagnosisCompletedScreen(),
                          DiagnosisCancelledScreen()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
