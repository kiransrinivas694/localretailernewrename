import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';

class CalendarDialog extends StatelessWidget {
  final DateTime? minSelectedDate;
  CalendarDialog({Key? key, this.minSelectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CalendarCarousel<Event>(
                onDayPressed: (DateTime date, List<Event> events) {
                  String selectDate = DateFormat("yyyy-MM-dd").format(date);
                  print('selectDate ------------> $selectDate');
                  print(events);
                  Get.back(result: date);
                },
                weekdayTextStyle: TextStyle(
                  color: ColorsConst.greyByTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
                iconColor: ColorsConst.textColor,
                daysTextStyle: TextStyle(
                  color: ColorsConst.textColor,
                  fontSize: 18,
                ),
                selectedDayButtonColor: ColorsConst.primaryColor,
                weekendTextStyle: TextStyle(
                  color: ColorsConst.textColor,
                  fontSize: 18,
                ),
                maxSelectedDate: DateTime.now(),
                minSelectedDate: minSelectedDate,
                weekDayPadding: EdgeInsets.only(bottom: 30),
                showOnlyCurrentMonthDate: true,
                onDayLongPressed: (day) => print(day),
                onCalendarChanged: (p0) => print(p0),
                headerTextStyle: TextStyle(
                  color: ColorsConst.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                thisMonthDayBorderColor: Colors.grey,
                childAspectRatio: 1,
                weekFormat: false,
                height: height * 0.55,
                selectedDateTime: DateTime.now(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
