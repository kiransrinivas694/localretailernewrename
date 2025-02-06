import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/new_module/controllers/booking_appointmet_controller/booking_appointment_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller_new.dart';
import 'package:store_app_b2b/new_module/utils/app_utils_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:table_calendar/table_calendar.dart';

class AppTableCalendar extends StatefulWidget {
  const AppTableCalendar(
      {super.key, required this.pageController, required this.slotsList});

  final PageController pageController;
  final Function slotsList;
  @override
  _AppTableCalendarState createState() => _AppTableCalendarState();
}

class _AppTableCalendarState extends State<AppTableCalendar> {
  final ThemeController themeController = Get.find();
  DateTime now = DateTime.now();
  BooikingAppointmentController booikingAppointmentController =
      Get.put(BooikingAppointmentController());

  PageController? _calendarPageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: themeController.textPrimaryColor,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // #0000000D
            offset: Offset(0, 4),
            blurRadius: 6,
          ),
          BoxShadow(
            color: Color(0x1A000000), // #0000001A
            offset: Offset(0, 10),
            blurRadius: 15,
            spreadRadius: -3,
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: TableCalendar(
          onCalendarCreated: (controller) {
            _calendarPageController = controller;
          },
          focusedDay: now,
          firstDay: DateTime.now(),
          lastDay: DateTime.utc(2030, 3, 14),
          selectedDayPredicate: (day) {
            return isSameDay(booikingAppointmentController.selectedDate, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              booikingAppointmentController.selectedDate = selectedDay;
              booikingAppointmentController.slots = [];
              booikingAppointmentController.update();
              widget.slotsList();
              now = focusedDay;
            });
          },
          startingDayOfWeek: StartingDayOfWeek.sunday,
          calendarBuilders: CalendarBuilders(
            headerTitleBuilder: (context, day) {
              return Container(
                height: 50,
                padding: const EdgeInsets.only(left: 9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      DateFormat("LLL yyyy").format(day),
                      color: themeController.black500Color,
                      fontWeight: FontWeight.w600,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_calendarPageController != null) {
                              _calendarPageController!.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.fastOutSlowIn,
                              );
                            }
                          },
                          child: Icon(
                            Icons.arrow_left,
                            color: themeController.black500Color,
                            size: 30,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_calendarPageController != null) {
                              _calendarPageController!.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.fastOutSlowIn,
                              );
                            }
                          },
                          child: Icon(
                            Icons.arrow_right,
                            size: 30,
                            color: themeController.black500Color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          daysOfWeekHeight: 30,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            leftChevronVisible: false,
            rightChevronVisible: false,
          ),
          availableGestures: AvailableGestures.horizontalSwipe,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: themeController.black100Color,
              fontWeight: FontWeight.w600,
            ),
            weekendStyle: TextStyle(
              fontFamily: AppFont.poppins,
              color: themeController.black100Color,
              fontWeight: FontWeight.w600,
            ),
          ),
          calendarStyle: CalendarStyle(
            defaultTextStyle: const TextStyle(
              fontFamily: AppFont.montserrat,
              fontWeight: FontWeight.w600,
            ),
            holidayTextStyle: TextStyle(
              fontFamily: AppFont.montserrat,
              color: themeController.black100Color,
              fontWeight: FontWeight.w600,
            ),
            weekendTextStyle: TextStyle(
              fontFamily: AppFont.montserrat,
              fontWeight: FontWeight.w600,
              color: themeController.black500Color,
            ),
            disabledTextStyle: TextStyle(
              fontFamily: AppFont.montserrat,
              fontWeight: FontWeight.w600,
              color: themeController.black100Color,
            ),
            outsideTextStyle: TextStyle(
              fontFamily: AppFont.montserrat,
              color: themeController.black100Color,
            ),
            selectedDecoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  themeController.black500Color,
                  themeController.black500Color,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
