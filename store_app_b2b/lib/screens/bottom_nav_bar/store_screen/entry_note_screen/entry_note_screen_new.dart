import 'package:b2c/constants/colors_const_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/credit_note_controller/credit_note_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/entry_note_controller/entry_note_controller_new.dart';
import 'package:store_app_b2b/helper/pagination_layout_new.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/store_screen_new.dart';

class EntryNoteScreen extends StatelessWidget {
  const EntryNoteScreen({super.key});

  String formattedDate(String date) {
    DateTime dateCovert = DateFormat('yyyy-MM-dd').parse(date);
    String parseDate = DateFormat('dd-MM-yy').format(dateCovert);
    return parseDate;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GetBuilder<EntryNoteController>(
        init: EntryNoteController(),
        initState: (state) {
          Future.delayed(
            const Duration(microseconds: 300),
            () {
              EntryNoteController controller = Get.find<EntryNoteController>();
              controller.getEntryNoteHistory();
              //   cnController.getCreditNoteHeader();
            },
          );
        },
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: CommonText(
                content: "Clearing Status",
                boldNess: FontWeight.w600,
                textSize: width * 0.047,
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
            backgroundColor: ColorsConst.greyBgColor,
            body: controller.isEntryNoteHistoryLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.entryNoteHistoryList.isEmpty
                    ? const Center(
                        child: CommonText(
                          content: "No Entry History Found",
                          textColor: AppColors.appblack,
                          boldNess: FontWeight.w500,
                        ),
                      )
                    : Column(
                        children: [
                          Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    const BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.25),
                                      offset: Offset(0, 0), // X and Y offset
                                      blurRadius: 4, // Blur radius
                                      spreadRadius: 0, // Spread radius
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(8)),
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    child: Table(
                                      border: const TableBorder(
                                          verticalInside: BorderSide(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  224, 224, 224, 1),
                                              style: BorderStyle.solid),
                                          bottom: BorderSide(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  224, 224, 224, 1),
                                              style: BorderStyle.solid)),
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      columnWidths: const <int,
                                          TableColumnWidth>{
                                        0: FlexColumnWidth(),
                                        1: FixedColumnWidth(75),
                                        2: FixedColumnWidth(75),
                                        3: FixedColumnWidth(80),
                                      },
                                      children: [
                                        TableRow(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8)),
                                            color:
                                                Color.fromRGBO(255, 139, 3, 1),
                                          ),
                                          children: [
                                            // Padding(
                                            //   padding:
                                            //       const EdgeInsets.all(4.0),
                                            //   child: CommonText(
                                            //     content: "Order ID",
                                            //     textSize: width * 0.035,
                                            //     textColor: const Color.fromRGBO(
                                            //         45, 54, 72, 1),
                                            //     boldNess: FontWeight.w500,
                                            //   ),
                                            // ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: CommonText(
                                                  content: "Paid Amount(₹)",
                                                  textSize: width * 0.035,
                                                  textColor:
                                                      const Color.fromRGBO(
                                                          45, 54, 72, 1),
                                                  boldNess: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: CommonText(
                                                content: "Paid Date",
                                                textSize: width * 0.035,
                                                textColor: const Color.fromRGBO(
                                                    45, 54, 72, 1),
                                                boldNess: FontWeight.w500,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: CommonText(
                                                content: "Requested Date",
                                                textSize: width * 0.035,
                                                textColor: const Color.fromRGBO(
                                                    45, 54, 72, 1),
                                                boldNess: FontWeight.w500,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: CommonText(
                                                content: "Approved Status",
                                                textAlign: TextAlign.center,
                                                textSize: width * 0.035,
                                                textColor: const Color.fromRGBO(
                                                    45, 54, 72, 1),
                                                boldNess: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0, right: 0, bottom: 10),
                                    child: Table(
                                        defaultVerticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        columnWidths: const <int,
                                            TableColumnWidth>{
                                          0: FlexColumnWidth(),
                                          1: FixedColumnWidth(75),
                                          2: FixedColumnWidth(75),
                                          3: FixedColumnWidth(80),
                                        },
                                        // border: TableBorder.all(color: const Color(0xffD8D5D5)),
                                        border: const TableBorder(
                                            horizontalInside: BorderSide(
                                                width: 1,
                                                color: Color.fromRGBO(
                                                    224, 224, 224, 1),
                                                style: BorderStyle.solid),
                                            verticalInside: BorderSide(
                                                width: 1,
                                                color: Color.fromRGBO(
                                                    224, 224, 224, 1),
                                                style: BorderStyle.solid)),
                                        children: controller
                                                .entryNoteHistoryList.isNotEmpty
                                            ? List.generate(
                                                controller.entryNoteHistoryList
                                                    .length, (index) {
                                                // List<num> originalOrderId = [];
                                                return TableRow(children: [
                                                  // Padding(
                                                  //   padding:
                                                  //       const EdgeInsets.all(
                                                  //           4.0),
                                                  //   child: CommonText(
                                                  //     content: controller
                                                  //             .entryNoteHistoryList[
                                                  //                 index]
                                                  //             .id ??
                                                  //         "",
                                                  //     textSize: width * 0.035,
                                                  //     textColor:
                                                  //         const Color.fromRGBO(
                                                  //             45, 54, 72, 1),
                                                  //     boldNess: FontWeight.w400,
                                                  //   ),
                                                  // ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width: width * 0.2,
                                                            child: CommonText(
                                                              //maxLines: 2,
                                                              content:
                                                                  "${controller.entryNoteHistoryList[index].amountPaid}",
                                                              textSize:
                                                                  width * 0.035,
                                                              textColor: const Color
                                                                      .fromRGBO(
                                                                  45,
                                                                  54,
                                                                  72,
                                                                  1),
                                                              boldNess:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          // SizedBox(
                                                          //   width: width * 0.08,
                                                          // ),
                                                          controller
                                                                      .entryNoteHistoryList[
                                                                          index]
                                                                      .status ==
                                                                  "N"
                                                              ? GestureDetector(
                                                                  onTap: () {
                                                                    controller
                                                                        .entryNoteid = controller
                                                                            .entryNoteHistoryList[index]
                                                                            .id ??
                                                                        '';
                                                                    controller
                                                                        .update();
                                                                    entryDataDialog(
                                                                        context,
                                                                        paidDate:
                                                                            controller.entryNoteHistoryList[index].paidDate ??
                                                                                '',
                                                                        amount:
                                                                            "${controller.entryNoteHistoryList[index].amountPaid}",
                                                                        isUpdate:
                                                                            true);
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .edit_note,
                                                                    size: 18,
                                                                  ))
                                                              : SizedBox()
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: CommonText(
                                                        content: formattedDate(
                                                            "${controller.entryNoteHistoryList[index].paidDate}"),
                                                        textSize: width * 0.035,
                                                        textColor: const Color
                                                                .fromRGBO(
                                                            45, 54, 72, 1),
                                                        boldNess:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: CommonText(
                                                        content: formattedDate(
                                                            "${controller.entryNoteHistoryList[index].requestDate}"),
                                                        textSize: width * 0.035,
                                                        textColor: const Color
                                                                .fromRGBO(
                                                            45, 54, 72, 1),
                                                        boldNess:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),

                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: CommonText(
                                                          content: controller
                                                                      .entryNoteHistoryList[
                                                                          index]
                                                                      .status ==
                                                                  "N"
                                                              ? "Pending"
                                                              : "Approved",
                                                          textSize:
                                                              width * 0.035,
                                                          textColor: controller
                                                                      .entryNoteHistoryList[
                                                                          index]
                                                                      .status ==
                                                                  "N"
                                                              ? ColorsConst
                                                                  .redColor
                                                              : AppColors
                                                                  .greenColor,
                                                          boldNess:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]);
                                              })
                                            : []),
                                  )
                                ],
                              )),
                          controller.entryHistoryTotalPages <= 1
                              ? const SizedBox()
                              : PaginationLayout(
                                  pageNumber:
                                      controller.entryHistoryCurrentPage,
                                  totalPages: controller.entryHistoryTotalPages,
                                  isDoubleArrowsPresent: false,
                                  onPageClick: (pageNumber) {
                                    controller.entryHistoryCurrentPage =
                                        pageNumber;
                                    controller.getEntryNoteHistory(
                                        pageNumber: pageNumber);
                                    controller.update();
                                  },
                                )
                        ],
                      ),
          );
        });
  }
}
