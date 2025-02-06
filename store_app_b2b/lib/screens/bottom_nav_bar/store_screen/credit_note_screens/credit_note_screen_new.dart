import 'package:b2c/constants/colors_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/credit_note_controller/credit_note_controller_new.dart';
import 'package:store_app_b2b/helper/pagination_layout_new.dart';
import 'package:dotted_line/dotted_line.dart';

class CreditNoteScreen extends StatelessWidget {
  const CreditNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GetBuilder<CreditNoteController>(
        init: CreditNoteController(),
        initState: (state) {
          Future.delayed(
            Duration(microseconds: 300),
            () {
              CreditNoteController cnController =
                  Get.find<CreditNoteController>();
              cnController.getCreditNoteHistory();
              cnController.getCreditNoteHeader();
            },
          );
        },
        builder: (cnController) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: CommonText(
                content: "Credit Note",
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
            body: cnController.isCreditNoteHistoryLoading
                ? Center(child: CircularProgressIndicator())
                : cnController.creditNoteHistoryList.length == 0
                    ? Center(
                        child: CommonText(
                          content: "No Credit History Found",
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
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.25),
                                      offset: Offset(0, 0), // X and Y offset
                                      blurRadius: 4, // Blur radius
                                      spreadRadius: 0, // Spread radius
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(8)),
                              margin: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    // height: 100,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(255, 139, 3, 1),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CommonText(content: "Balance Amount"),
                                        CommonText(
                                            content:
                                                "(₹) ${cnController.creditNoteBalance.toStringAsFixed(2)}"),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
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
                                        2: FixedColumnWidth(70),
                                        3: FixedColumnWidth(70),
                                      },
                                      children: [
                                        TableRow(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: CommonText(
                                                content: "Order ID",
                                                textSize: width * 0.035,
                                                textColor: Color.fromRGBO(
                                                    45, 54, 72, 1),
                                                boldNess: FontWeight.w500,
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: CommonText(
                                                  content: "Date",
                                                  textSize: width * 0.035,
                                                  textColor: Color.fromRGBO(
                                                      45, 54, 72, 1),
                                                  boldNess: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: CommonText(
                                                content: "DR (₹)",
                                                textSize: width * 0.035,
                                                textColor: Color.fromRGBO(
                                                    45, 54, 72, 1),
                                                boldNess: FontWeight.w500,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: CommonText(
                                                content: "CR (₹)",
                                                textAlign: TextAlign.center,
                                                textSize: width * 0.035,
                                                textColor: Color.fromRGBO(
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
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10),
                                    child: Table(
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      columnWidths: const <int,
                                          TableColumnWidth>{
                                        0: FlexColumnWidth(),
                                        1: FixedColumnWidth(75),
                                        2: FixedColumnWidth(70),
                                        3: FixedColumnWidth(70),
                                      },
                                      // border: TableBorder.all(color: const Color(0xffD8D5D5)),
                                      border: const TableBorder(
                                          // horizontalInside: BorderSide(
                                          //     width: 1,
                                          //     color: Color.fromRGBO(224, 224, 224, 1),
                                          //     style: BorderStyle.solid),
                                          verticalInside: BorderSide(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  224, 224, 224, 1),
                                              style: BorderStyle.solid)),
                                      children: List.generate(
                                          cnController.creditNoteHistoryList
                                                  .isNotEmpty
                                              ? cnController
                                                          .creditNoteHistoryList
                                                          .length *
                                                      2 -
                                                  1
                                              // ? 29
                                              : 7, (index) {
                                        List<String> originalOrderId = [];

                                        if (cnController
                                                .creditNoteHistoryList[
                                                    index ~/ 2]
                                                .orderId !=
                                            null) {
                                          originalOrderId = cnController
                                              .creditNoteHistoryList[index ~/ 2]
                                              .orderId!
                                              .split("-");
                                        }
                                        return index % 2 == 0
                                            ? TableRow(
                                                children: [
                                                  Container(
                                                    height: 40,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CommonText(
                                                          content: cnController
                                                                  .creditNoteHistoryList
                                                                  .isNotEmpty
                                                              ? cnController
                                                                          .creditNoteHistoryList[index ~/
                                                                              2]
                                                                          .orderId ==
                                                                      null
                                                                  ? ""
                                                                  : cnController
                                                                          .creditNoteHistoryList[index ~/
                                                                              2]
                                                                          .orderId ??
                                                                      ""
                                                              // : "${originalOrderId[0]} - \n${originalOrderId[1]}"
                                                              // ? "Bill Date"
                                                              : " -",
                                                          textSize: 13,
                                                          textColor: const Color
                                                                  .fromRGBO(
                                                              77, 77, 77, 1),
                                                          boldNess:
                                                              FontWeight.w400,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 40,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CommonText(
                                                          content: cnController
                                                                  .creditNoteHistoryList
                                                                  .isNotEmpty
                                                              ? cnController
                                                                          .creditNoteHistoryList[index ~/
                                                                              2]
                                                                          .orderDate !=
                                                                      null
                                                                  ? DateFormat(
                                                                          'dd-MM-yy')
                                                                      .format(cnController
                                                                          .creditNoteHistoryList[index ~/
                                                                              2]
                                                                          .orderDate!)
                                                                  : ""
                                                              : " -",
                                                          textSize: 12,
                                                          textColor: const Color
                                                                  .fromRGBO(
                                                              77, 77, 77, 1),
                                                          boldNess:
                                                              FontWeight.w400,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 40,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CommonText(
                                                          content: cnController
                                                                      .creditNoteHistoryList[
                                                                          index ~/
                                                                              2]
                                                                      .transactionType ==
                                                                  "DR"
                                                              ? cnController
                                                                          .creditNoteHistoryList[index ~/
                                                                              2]
                                                                          .creditNoteAmount !=
                                                                      null
                                                                  ? cnController
                                                                      .creditNoteHistoryList[
                                                                          index ~/
                                                                              2]
                                                                      .creditNoteAmount!
                                                                      .toStringAsFixed(
                                                                          2)
                                                                  : "-"
                                                              : "-",
                                                          textSize: 12,
                                                          textColor: const Color
                                                                  .fromRGBO(
                                                              255, 0, 0, 1),
                                                          boldNess:
                                                              FontWeight.w400,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 40,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CommonText(
                                                          content: cnController
                                                                      .creditNoteHistoryList[
                                                                          index ~/
                                                                              2]
                                                                      .transactionType ==
                                                                  "CR"
                                                              ? cnController
                                                                          .creditNoteHistoryList[index ~/
                                                                              2]
                                                                          .creditNoteAmount !=
                                                                      null
                                                                  ? cnController
                                                                      .creditNoteHistoryList[
                                                                          index ~/
                                                                              2]
                                                                      .creditNoteAmount!
                                                                      .toStringAsFixed(
                                                                          2)
                                                                  : "-"
                                                              : "-",
                                                          textSize: 12,
                                                          textColor:
                                                              Color.fromRGBO(30,
                                                                  170, 36, 1),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : TableRow(
                                                children: [
                                                  DottedLine(
                                                    dashColor: Color.fromRGBO(
                                                        224, 224, 224, 1),
                                                  ),
                                                  DottedLine(
                                                    dashColor: Color.fromRGBO(
                                                        224, 224, 224, 1),
                                                  ),
                                                  DottedLine(
                                                    dashColor: Color.fromRGBO(
                                                        224, 224, 224, 1),
                                                  ),
                                                  DottedLine(
                                                    dashColor: Color.fromRGBO(
                                                        224, 224, 224, 1),
                                                  ),
                                                ],
                                              );
                                      }),
                                    ),
                                  ),
                                ],
                              )
                              //initial table starts here
                              // : Column(
                              //     children: [
                              //       Table(
                              //         border: const TableBorder(
                              //           // verticalInside: BorderSide(
                              //           //     width: 1,
                              //           //     color: Color.fromRGBO(224, 224, 224, 1),
                              //           //     style: BorderStyle.solid),
                              //           verticalInside: BorderSide(
                              //               width: 1,
                              //               color: AppColors.appblack,
                              //               style: BorderStyle.solid),
                              //           horizontalInside: BorderSide(
                              //               width: 1,
                              //               color: AppColors.appblack,
                              //               style: BorderStyle.solid),
                              //           left: BorderSide(
                              //               width: 1,
                              //               color: AppColors.appblack,
                              //               style: BorderStyle.solid),
                              //           right: BorderSide(
                              //               width: 1,
                              //               color: AppColors.appblack,
                              //               style: BorderStyle.solid),
                              //           top: BorderSide(
                              //               width: 1,
                              //               color: AppColors.appblack,
                              //               style: BorderStyle.solid),
                              //         ),
                              //         defaultVerticalAlignment:
                              //             TableCellVerticalAlignment.middle,
                              //         columnWidths: const <int, TableColumnWidth>{
                              //           0: FlexColumnWidth(),
                              //           1: FixedColumnWidth(145),
                              //           // 2: FixedColumnWidth(75),
                              //           // 3: FixedColumnWidth(70),
                              //         },
                              //         children: [
                              //           TableRow(
                              //             decoration: BoxDecoration(
                              //                 // color: AppColors.primaryColor,
                              //                 ),
                              //             children: [
                              //               Padding(
                              //                 padding: const EdgeInsets.all(6.0),
                              //                 child: CommonText(
                              //                   content: "Balance Amount",
                              //                   textAlign: TextAlign.end,
                              //                   textSize: width * 0.035,
                              //                   textColor: AppColors.appblack,
                              //                   boldNess: FontWeight.w500,
                              //                 ),
                              //               ),
                              //               TableCell(
                              //                 child: Padding(
                              //                   padding: const EdgeInsets.all(6.0),
                              //                   child: CommonText(
                              //                     content:
                              //                         "⟨₹⟩ ${cnController.creditNoteBalance.toStringAsFixed(2)}",
                              //                     textAlign: TextAlign.end,
                              //                     textSize: width * 0.035,
                              //                     textColor: AppColors.appblack,
                              //                     boldNess: FontWeight.w500,
                              //                   ),
                              //                 ),
                              //               ),
                              //               // Padding(
                              //               //   padding: const EdgeInsets.symmetric(
                              //               //       vertical: 10, horizontal: 6.0),
                              //               //   child: CommonText(
                              //               //     textAlign: TextAlign.center,
                              //               //     content: "DR",
                              //               //     textSize: width * 0.035,
                              //               //     textColor: AppColors.appblack,
                              //               //     boldNess: FontWeight.w500,
                              //               //   ),
                              //               // ),
                              //               // Padding(
                              //               //   padding: const EdgeInsets.all(6.0),
                              //               //   child: CommonText(
                              //               //     content: "Cr",
                              //               //     textAlign: TextAlign.center,
                              //               //     textSize: width * 0.035,
                              //               //     textColor: AppColors.appblack,
                              //               //     boldNess: FontWeight.w500,
                              //               //   ),
                              //               // ),
                              //             ],
                              //           ),
                              //         ],
                              //       ),
                              //       Table(
                              //         border: const TableBorder(
                              //           // verticalInside: BorderSide(
                              //           //     width: 1,
                              //           //     color: Color.fromRGBO(224, 224, 224, 1),
                              //           //     style: BorderStyle.solid),
                              //           verticalInside: BorderSide(
                              //               width: 1,
                              //               color: AppColors.appblack,
                              //               style: BorderStyle.solid),
                              //           horizontalInside: BorderSide(
                              //               width: 1,
                              //               color: AppColors.appblack,
                              //               style: BorderStyle.solid),
                              //           left: BorderSide(
                              //               width: 1,
                              //               color: AppColors.appblack,
                              //               style: BorderStyle.solid),
                              //           right: BorderSide(
                              //               width: 1,
                              //               color: AppColors.appblack,
                              //               style: BorderStyle.solid),
                              //           top: BorderSide(
                              //               width: 1,
                              //               color: AppColors.appblack,
                              //               style: BorderStyle.solid),
                              //           bottom: BorderSide(
                              //               width: 1,
                              //               color: AppColors.appblack,
                              //               style: BorderStyle.solid),
                              //         ),
                              //         defaultVerticalAlignment:
                              //             TableCellVerticalAlignment.middle,
                              //         columnWidths: const <int, TableColumnWidth>{
                              //           0: FlexColumnWidth(),
                              //           1: FixedColumnWidth(75),
                              //           2: FixedColumnWidth(75),
                              //           3: FixedColumnWidth(70),
                              //         },
                              //         children: [
                              //           TableRow(
                              //             decoration: BoxDecoration(
                              //                 // color: AppColors.primaryColor,
                              //                 ),
                              //             children: [
                              //               Padding(
                              //                 padding: const EdgeInsets.all(6.0),
                              //                 child: CommonText(
                              //                   content: "Order Id",
                              //                   textSize: width * 0.035,
                              //                   textColor: AppColors.appblack,
                              //                   boldNess: FontWeight.w500,
                              //                 ),
                              //               ),
                              //               TableCell(
                              //                 child: Padding(
                              //                   padding: const EdgeInsets.all(6.0),
                              //                   child: CommonText(
                              //                     content: "Date",
                              //                     textSize: width * 0.035,
                              //                     textColor: AppColors.appblack,
                              //                     boldNess: FontWeight.w500,
                              //                   ),
                              //                 ),
                              //               ),
                              //               Padding(
                              //                 padding: const EdgeInsets.symmetric(
                              //                     vertical: 10, horizontal: 6.0),
                              //                 child: CommonText(
                              //                   textAlign: TextAlign.center,
                              //                   content: "DR ⟨₹⟩",
                              //                   textSize: width * 0.035,
                              //                   textColor: AppColors.appblack,
                              //                   boldNess: FontWeight.w500,
                              //                 ),
                              //               ),
                              //               Padding(
                              //                 padding: const EdgeInsets.all(6.0),
                              //                 child: CommonText(
                              //                   content: "Cr ⟨₹⟩",
                              //                   textAlign: TextAlign.center,
                              //                   textSize: width * 0.035,
                              //                   textColor: AppColors.appblack,
                              //                   boldNess: FontWeight.w500,
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ],
                              //       ),
                              //       Container(
                              //         constraints:
                              //             BoxConstraints(maxHeight: height * 0.69),
                              //         // color: Colors.red,
                              //         // height: 300,
                              //         // decoration: BoxDecoration(
                              //         //     border: Border(
                              //         //         bottom: BorderSide(
                              //         //             color: AppColors.appblack,
                              //         //             width: 1))),
                              //         child: SingleChildScrollView(
                              //           child: Table(
                              //             defaultVerticalAlignment:
                              //                 TableCellVerticalAlignment.middle,
                              //             columnWidths: const <int, TableColumnWidth>{
                              //               // 0: FixedColumnWidth(70),
                              //               // 1: FixedColumnWidth(75),
                              //               0: FlexColumnWidth(),
                              //               1: FixedColumnWidth(75),
                              //               2: FixedColumnWidth(75),
                              //               3: FixedColumnWidth(70),
                              //             },
                              //             // border: TableBorder.all(color: const Color(0xffD8D5D5)),
                              //             border: const TableBorder(
                              //               // horizontalInside: BorderSide(
                              //               //     width: 1,
                              //               //     color: Color.fromRGBO(224, 224, 224, 1),
                              //               //     style: BorderStyle.solid),
                              //               verticalInside: BorderSide(
                              //                   width: 1,
                              //                   color: AppColors.appblack,
                              //                   style: BorderStyle.solid),
                              //               horizontalInside: BorderSide(
                              //                   width: 1,
                              //                   color: AppColors.appblack,
                              //                   style: BorderStyle.solid),
                              //               left: BorderSide(
                              //                   width: 1,
                              //                   color: AppColors.appblack,
                              //                   style: BorderStyle.solid),
                              //               right: BorderSide(
                              //                   width: 1,
                              //                   color: AppColors.appblack,
                              //                   style: BorderStyle.solid),
                              //               // top: BorderSide(
                              //               //     width: 1,
                              //               //     color: AppColors.appblack,
                              //               //     style: BorderStyle.solid),
                              //               bottom: BorderSide(
                              //                 width: 1,
                              //                 color: AppColors.appblack,
                              //                 style: BorderStyle.solid,
                              //               ),
                              //             ),
                              //             children: List.generate(
                              //                 cnController.creditNoteHistoryList.length,
                              //                 // cnController.,
                              //                 (index) => TableRow(
                              //                       decoration: BoxDecoration(
                              //                           // border: Border.all(
                              //                           //     width: 3, color: Colors.red),
                              //                           ),
                              //                       children: [
                              //                         Padding(
                              //                           padding:
                              //                               const EdgeInsets.all(6.0),
                              //                           child: CommonText(
                              //                             content: cnController
                              //                                     .creditNoteHistoryList[
                              //                                         index]
                              //                                     .orderId ??
                              //                                 "",
                              //                             textSize: width * 0.035,
                              //                             textColor:
                              //                                 const Color.fromRGBO(
                              //                                     45, 54, 72, 1),
                              //                             boldNess: FontWeight.w400,
                              //                           ),
                              //                         ),
                              //                         TableCell(
                              //                           child: Padding(
                              //                             padding:
                              //                                 const EdgeInsets.all(6.0),
                              //                             child: CommonText(
                              //                               content: cnController
                              //                                           .creditNoteHistoryList[
                              //                                               index]
                              //                                           .orderDate ==
                              //                                       null
                              //                                   ? ""
                              //                                   : DateFormat('dd-MM-yy')
                              //                                       .format(cnController
                              //                                           .creditNoteHistoryList[
                              //                                               index]
                              //                                           .orderDate!),
                              //                               textSize: width * 0.035,
                              //                               textColor: Color.fromRGBO(
                              //                                   45, 54, 72, 1),
                              //                               boldNess: FontWeight.w400,
                              //                             ),
                              //                           ),
                              //                         ),
                              //                         Padding(
                              //                           padding:
                              //                               const EdgeInsets.all(6.0),
                              //                           child: CommonText(
                              //                             content: cnController
                              //                                         .creditNoteHistoryList[
                              //                                             index]
                              //                                         .transactionType ==
                              //                                     "DR"
                              //                                 ? cnController
                              //                                         .creditNoteHistoryList[
                              //                                             index]
                              //                                         .creditNoteAmount!
                              //                                         .toStringAsFixed(
                              //                                             2) ??
                              //                                     "-"
                              //                                 : "-",
                              //                             textSize: width * 0.035,
                              //                             textAlign: TextAlign.center,
                              //                             textColor: cnController
                              //                                         .creditNoteHistoryList[
                              //                                             index]
                              //                                         .transactionType ==
                              //                                     "DR"
                              //                                 ? AppColors.redColor
                              //                                 : AppColors.appblack,
                              //                             boldNess: FontWeight.w400,
                              //                           ),
                              //                         ),
                              //                         Padding(
                              //                           padding:
                              //                               const EdgeInsets.all(6.0),
                              //                           child: CommonText(
                              //                             content: cnController
                              //                                         .creditNoteHistoryList[
                              //                                             index]
                              //                                         .transactionType ==
                              //                                     "CR"
                              //                                 ? cnController
                              //                                         .creditNoteHistoryList[
                              //                                             index]
                              //                                         .creditNoteAmount!
                              //                                         .toStringAsFixed(
                              //                                             2) ??
                              //                                     "-"
                              //                                 : "-",
                              //                             textAlign: TextAlign.center,
                              //                             textSize: width * 0.035,
                              //                             textColor: cnController
                              //                                         .creditNoteHistoryList[
                              //                                             index]
                              //                                         .transactionType ==
                              //                                     "CR"
                              //                                 ? AppColors.greenColor
                              //                                 : AppColors.appblack,
                              //                             boldNess: FontWeight.w400,
                              //                           ),
                              //                         ),
                              //                       ],
                              //                     )),
                              //           ),
                              //         ),
                              //       ),
                              //       SizedBox(
                              //         height: 10,
                              //       ),
                              //       cnController.creditHistoryTotalPages <= 1
                              //           ? SizedBox()
                              //           : PaginationLayout(
                              //               pageNumber:
                              //                   cnController.creditHistoryCurrentPage,
                              //               totalPages:
                              //                   cnController.creditHistoryTotalPages,
                              //               isDoubleArrowsPresent: false,
                              //               onPageClick: (pageNumber) {
                              //                 cnController.creditHistoryCurrentPage =
                              //                     pageNumber;
                              //                 cnController.getCreditNoteHistory(
                              //                     pageNumber: pageNumber);
                              //                 cnController.update();
                              //               },
                              //             )
                              //     ],
                              //   ),
                              ),
                          cnController.creditHistoryTotalPages <= 1
                              ? SizedBox()
                              : PaginationLayout(
                                  pageNumber:
                                      cnController.creditHistoryCurrentPage,
                                  totalPages:
                                      cnController.creditHistoryTotalPages,
                                  isDoubleArrowsPresent: false,
                                  onPageClick: (pageNumber) {
                                    cnController.creditHistoryCurrentPage =
                                        pageNumber;
                                    cnController.getCreditNoteHistory(
                                        pageNumber: pageNumber);
                                    cnController.update();
                                  },
                                )
                        ],
                      ),
          );
        });
  }
}
