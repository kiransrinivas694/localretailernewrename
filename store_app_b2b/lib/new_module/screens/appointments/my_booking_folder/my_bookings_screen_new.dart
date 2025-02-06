import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/new_module/controllers/booking_appointmet_controller/booking_appointment_controller.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller.dart';
import 'package:store_app_b2b/new_module/screens/appointments/my_booking_folder/cancelled_tab_bar.dart';
import 'package:store_app_b2b/new_module/screens/appointments/my_booking_folder/completed_tab_bar.dart';
import 'package:store_app_b2b/new_module/screens/appointments/my_booking_folder/upcoming_tab_bar.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_app_bar.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    BooikingAppointmentController controller =
        Get.put(BooikingAppointmentController());

    super.initState();
    int initialIndex =
        Get.arguments == null ? 0 : Get.arguments["initialIndex"] ?? 0;
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: initialIndex);
    _tabController.addListener(
      () {
        if (_tabController.indexIsChanging) {
          if (_tabController.index == 0) {
            controller.status = 'P';
          } else if (_tabController.index == 1) {
            controller.status = 'A';
          } else if (_tabController.index == 2) {
            controller.status = 'C';
          }
          controller.appointmentDetails.clear();
          controller.getAppointmentHistory();
        }
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final ThemeController themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GetBuilder<BooikingAppointmentController>(
        // init: BooikingAppointmentController(),
        // initState: (state) {
        //   BooikingAppointmentController booikingAppointmentController =
        //       Get.put(BooikingAppointmentController());
        //   // booikingAppointmentController.status = 'P';
        //   booikingAppointmentController.getAppointmentHistory();
        // },
        builder: (_) {
      return SafeArea(
        child: Scaffold(
          appBar: const AppAppBar(title: 'My Bookings'),
          // bottomNavigationBar: AppBottomBar(
          //   index: 4,
          //   useIndexFromController: false,
          // ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            // padding: EdgeInsets.symmetric(horizontal: 16),
            color: themeController.textPrimaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: Theme(
                    data: theme.copyWith(
                      colorScheme: theme.colorScheme.copyWith(
                          // surfaceContainerHighest: Colors.transparent, //mysaa commented
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
                      // isScrollable: true,
                      dividerColor: const Color.fromRGBO(229, 231, 235, 1),
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
                // Container(
                //   width: double.infinity,
                //   height: 0.5,
                //   color: themeController.black50Color,
                // ),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      UpcomingTabBar(),
                      const CompletedTabBar(),
                      const CancelledTabBar()
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
