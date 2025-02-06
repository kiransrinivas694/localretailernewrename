import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:sizer/sizer.dart';

import 'invoicemodel_new.dart';
// import 'modules/account/order/controller/order_controller.dart';
// import 'modules/account/order/model/order_details_model.dart';

class InvoiceController extends GetxController {
  Invoice? dummyInvoice;

  Map<String, dynamic> singleOrderDetail = {};

  var image;
  // OrderDetailsModel? model;
  Map model = {
    "items": [
      {
        "qty": 20,
        "grossAmount": 200,
        "discountTotal": 200,
        "taxableValue": 'dsf',
        "taxes": 'sf',
        "total": 400,
        "HSN": "skdfj",
        "descriptionName": "skfhskjf",
      }
    ]
  };
  InvoiceController() {
    // getOrderData();
    //loadImage();
  }

  //items
  List<dynamic> filteredItems = [];

  //Footer values storage
  double totalOrderValueResult = 0;
  double productDiscountResult = 0;
  num afterproductDiscountResult = 0;
  String couponCodeResult = "";
  num couponDiscountResult = 0;
  num totalDiscountResult = 0;
  num netReceivableResult = 0;

  void valuesRefresh() {
    totalOrderValueResult = 0;
    productDiscountResult = 0;
    afterproductDiscountResult = 0;
    couponCodeResult = "";
    couponDiscountResult = 0;
    totalDiscountResult = 0;
    netReceivableResult = 0;

    update();
  }

  Future loadImage() async {
    final imageByteData = await rootBundle.load('assets/images/playstore.png');
    // Convert ByteData to Uint8List
    final imageUint8List = imageByteData.buffer
        .asUint8List(imageByteData.offsetInBytes, imageByteData.lengthInBytes);

    image = pw.MemoryImage(imageUint8List);
  }

  getOrderData() {
    // model = Get.find<OrderController>().orderDetails;
    valuesRefresh();
    Map model = {
      "items": [
        {
          "qty": 20,
          "grossAmount": 200,
          "discountTotal": 200,
          "taxableValue": 'dsf',
          "taxes": 'sf',
          "total": 400,
          "HSN": "skdfj",
          "descriptionName": "skfhskjf",
        }
      ]
    };

    filteredItems = singleOrderDetail["items"]
        .where((item) => item["status"] != "0")
        .toList();

    dummyInvoice = Invoice(
        billTo: BillTo(
          // name: model!.pickupAddress?.name ?? 'null',
          // billingAddress: model!.pickupAddress?.addressLine1 ?? ' ',
          name: singleOrderDetail["pickupAddress"]["name"] ?? "",
          billingAddress: 'Suryaraopet - bill to ',
        ),
        shipTo: ShipTo(
          // name: model!.deliveryAddress?.name ?? ' ',
          // shippingAddress: model!.deliveryAddress?.addressLine1 ?? ' ',
          name: 'Kiran Srinivas',
          shippingAddress: 'Suryaraopet - bill to ',
        ),
        // invoiceDate: model!.orderCreatedDate.toString(),
        // invoiceNumber: model!.id,
        invoiceDate: "invoiceDate",
        invoiceNumber: "invoiceNumber",
        // orderNumber: model!.id,
        //orderDate: model!.orderCreatedDate.toString(),
        // total: model!.paidAmount,
        // totalTaxes: model!.tax,
        total: "total",
        totalTaxes: "totalTaxes",
        // items: model!.items!
        //     .map((e) => orderedItems(
        //           qty: e.quantity,
        //           grossAmount: e.mrp,
        //           discountTotal: e.discountPrice,
        //           taxableValue: '',
        //           taxes: '',
        //           total: e.totalPrice,
        //           HSN: e.hsn,
        //           descriptionName: e.productName,
        //         ))
        //     .toList());
        // items: singleOrderDetail["items"]
        //     .map((e) => orderedItems(
        //           qty: e["quantity"],
        //           grossAmount: e["mrp"],
        //           discountTotal: e["discountPrice"],
        //           taxableValue: '',
        //           taxes: '',
        //           total: e["totalPrice"],
        //           HSN: e["hsn"],
        //           descriptionName: e["productName"],
        //         ))
        //     .toList()
        items: (filteredItems)
            .map<orderedItems>((e) => orderedItems(
                  qty: e["quantity"],
                  grossAmount: e["mrp"],
                  discountTotal: e["discountPrice"],
                  taxableValue: '',
                  taxes: '',
                  total: e["totalPrice"],
                  HSN: e["hsn"],
                  descriptionName: e["productName"],
                ))
            .toList());

    update();
  }

  bool isPdfDownloading = false;
  redirectToInvoice(BuildContext c, Uint8List imageAsBytes,
      Map<String, dynamic> orderDetails) async {
    singleOrderDetail = orderDetails;
    update();
    getOrderData();
    calculateFooterValue();
    image = pw.MemoryImage(imageAsBytes);
    final pdf = pw.Document(
      compress: true,
    );
    pdf.addPage(
      pw.MultiPage(
        maxPages: 100,
        orientation: pw.PageOrientation.portrait,
        // margin: pw.EdgeInsets.all(5.w),
        // margin: pw.EdgeInsets.all(5),
        margin: pw.EdgeInsets.all(20),
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          //calculateNoOfPages();
          return [
            pw.Column(children: [
              header(c),
              pw.SizedBox(
                // height: 3.5.h,
                // height: 3.5,
                height: 20,
              ),
              ...calculateNoOfPages(),
              pw.SizedBox(
                // height: 3.5.h,
                height: 3.5,
              ),
              footer(),
            ])
          ];
        },
      ),
    );
    final bytes = await pdf.save();
    // saveAndLaunchFile(bytes, '${model!.id}.pdf');
    saveAndLaunchFile(bytes, '${singleOrderDetail["id"]}.pdf');
  }

  footer() {
    return pw.Container(
        width: double.infinity,
        child:
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
          pw.SizedBox(
            height: 10,
          ),
          pw.Text(
            'Total Order Value: Rs ${totalOrderValueResult.toStringAsFixed(2)}',
            style: pw.TextStyle(
                // fontWeight: pw.FontWeight.bold,
                ),
          ),
          pw.SizedBox(
            height: 2,
          ),
          pw.Text(
            'Product Discount: Rs ${productDiscountResult.toStringAsFixed(2)}',
            style: pw.TextStyle(
                // fontWeight: pw.FontWeight.bold,
                ),
          ),
          pw.SizedBox(
            height: 2,
          ),
          pw.Text(
            'After Product Discount: Rs ${afterproductDiscountResult.toStringAsFixed(2)}',
            style: pw.TextStyle(
                // fontWeight: pw.FontWeight.bold,
                ),
          ),
          pw.SizedBox(
            height: 2,
          ),
          pw.Text(
            'Coupon Code: ${singleOrderDetail["couponInfo"] == null || singleOrderDetail["couponInfo"]["providedByAdmin"] == "Y" ? "--" : singleOrderDetail["couponInfo"]["couponCode"] ?? "--"}',
            style: const pw.TextStyle(
                // fontWeight: pw.FontWeight.bold,
                ),
          ),
          pw.SizedBox(
            height: 2,
          ),
          pw.Text(
            'Coupon Discounts: Rs ${singleOrderDetail["couponInfo"] == null || singleOrderDetail["couponInfo"]["providedByAdmin"] == "Y" ? "0" : singleOrderDetail["couponInfo"]["couponValue"] ?? "0"}',
            style: const pw.TextStyle(
                // fontWeight: pw.FontWeight.bold,
                ),
          ),
          pw.SizedBox(
            height: 2,
          ),
          pw.Text(
            'Total Discount: Rs ${(singleOrderDetail["couponInfo"] == null || singleOrderDetail["couponInfo"]["providedByAdmin"] == "Y" ? 0 : singleOrderDetail["couponInfo"]["couponValue"] ?? 0) + productDiscountResult}',
            style: const pw.TextStyle(
                // fontWeight: pw.FontWeight.bold,
                ),
          ),
          pw.SizedBox(
            height: 2,
          ),
          pw.Text(
            'Net Receivable: Rs ${netReceivableResult.toStringAsFixed(2)}',
            style: pw.TextStyle(
                // fontWeight: pw.FontWeight.bold,
                ),
          ),
          // TandC(
          //     'All purchases are subject to availability at nearby stores and may vary in price and quantity.'),
        ]));
  }

  calculateFooterValue() {
    dynamic productItems = singleOrderDetail["items"];

    totalOrderValueResult = 0;

    productItems.forEach((element) {
      if (element["status"] != "0") {
        //calculating total order value amount
        double itemSubTotal = double.parse((element['mrp'] ?? '0').toString()) *
            double.parse((element['quantity'] ?? '0').toString());

        totalOrderValueResult += itemSubTotal;

        //calculating product discount
        double productDiscountSubTotal =
            double.parse((element['price'] ?? '0').toString()) *
                double.parse((element['quantity'] ?? '0').toString());

        productDiscountResult += itemSubTotal - productDiscountSubTotal;
        print("printing total productDiscountResult = $productDiscountResult");
      }
    });

    //calculating after product discount
    afterproductDiscountResult = totalOrderValueResult - productDiscountResult;

    //coupon code assign
    couponCodeResult = singleOrderDetail["couponInfo"] == null ||
            singleOrderDetail["couponInfo"]["providedByAdmin"] == "Y"
        ? ""
        : singleOrderDetail["couponInfo"]["couponCode"] ?? "";

    //coupondiscount calculation
    couponDiscountResult = 0;

    //net receivable calculation
    netReceivableResult =
        totalOrderValueResult - productDiscountResult - couponDiscountResult;

    print("printing total order value -> $totalOrderValueResult");
    print("printing total discount value -> $productDiscountResult");
    print(
        "printing total after product discount value ---> ${totalOrderValueResult - productDiscountResult}");
    print("printing total net receivable -. ${netReceivableResult}");
    update();
  }

  TandC(String text) {
    return pw.Padding(
        padding: pw.EdgeInsets.only(
          // bottom: 0.7.w,
          bottom: 0.7,
        ),
        child: pw.Row(children: [
          pw.Container(
            height: 3,
            width: 3,
            decoration: pw.BoxDecoration(
              color: PdfColors.black,
              // borderRadius: pw.BorderRadius.circular(
              //   10,
              // ),
            ),
          ),
          pw.SizedBox(
            // width: 2.w,
            width: 2,
          ),
          pw.Container(
            // width: 130.w,
            width: 130,
            child: pw.Text(text),
          ),
        ]));
  }

  calculateNoOfPages() {
    int firstPageLimit = 20; // 8 without total
    int fromSecondPageLimit = 29; //11 without total
    var x = dummyInvoice!.items!.length;

    print("dummyInvoice length ---> ${dummyInvoice!.items!.length}");
    // int y = (10 / 8).round();
    // print(y);
    int noOfPages = (x / 14).round();
    print("dummyInvoice noOfPages ---> ${noOfPages}");
    int remElements = 18 - firstPageLimit;
    print('dummyInvoice rem = $remElements');
    if (x <= firstPageLimit) {
      return [body(startIndex: 0, endIndex: x - 1)];
    } else {
      List bodiesList = [];
      bodiesList.add(body(startIndex: 0, endIndex: firstPageLimit - 1));
      int ll = firstPageLimit;
      int ul = ll + fromSecondPageLimit - 1;
      for (int i = 0; i <= noOfPages; i++) {
        print('lower = $ll || upper = $ul');
        bodiesList.add(
          body(
            startIndex: ll,
            endIndex: (ul - x < 0) ? ul : x - 1,
          ),
        );
        if (ul - x < 0) {
          ll = ul + 1;
          ul = ll + fromSecondPageLimit - 1;
        } else {
          break;
        }
      }
      return bodiesList;
    }
  }

  body({
    required int startIndex,
    required int endIndex,
  }) {
    return pw.Container(
        //color: PdfColors.amber,
        child: pw.TableHelper.fromTextArray(
      columnWidths: {
        // 0: pw.FixedColumnWidth(17.w),
        // 1: pw.FixedColumnWidth(40.w),
        // 2: pw.FixedColumnWidth(17.w),
        // 3: pw.FixedColumnWidth(16.w),
        // 4: pw.FixedColumnWidth(23.w),
        // 5: pw.FixedColumnWidth(25.w),
        // 6: pw.FixedColumnWidth(24.w),
        // 7: pw.FixedColumnWidth(20.w),
        // 8: pw.FixedColumnWidth(18.w),
        // 0: pw.FixedColumnWidth(17),
        0: pw.FlexColumnWidth(),
        1: pw.FixedColumnWidth(50),
        2: pw.FixedColumnWidth(50),
        3: pw.FixedColumnWidth(50),
        4: pw.FixedColumnWidth(50),
        5: pw.FixedColumnWidth(50),
        // 6: pw.FixedColumnWidth(24),
        // 7: pw.FixedColumnWidth(20),
        // 8: pw.FixedColumnWidth(18),
      },
      cellPadding: pw.EdgeInsets.all(0),
      //defaultColumnWidth: pw.IntrinsicColumnWidth(),
      border: pw.TableBorder.symmetric(
        outside: pw.BorderSide(
          width: 1,
          color: PdfColors.grey,
          style: pw.BorderStyle.solid,
        ),
        // inside: pw.BorderSide(
        //   width: 1,
        //   color: PdfColors.grey,
        //   style: pw.BorderStyle.solid,
        // ),
      ),
      data: [
        headerTableRowAsList(),
        ...itemRows(startIndex, endIndex),
        totalTableRow(endIndex),
      ],
    ));
  }

  totalTableRow(int endIndex) {
    // return (endIndex == model!.items!.length - 1)
    return (endIndex == model!["items"]!.length - 1)
        // ? [
        //     totalTableChildCell(text: 'Total', tagName: 's.no'),
        //     totalTableChildCell(text: '', tagName: 'desc'),
        //     totalTableChildCell(text: '', tagName: 'hsn'),
        //     totalTableChildCell(text: '', tagName: 'qty'),
        //     totalTableChildCell(text: '', tagName: 'ga'),
        //     totalTableChildCell(text: '', tagName: 'dit'),
        //     // totalTableChildCell(text: '', tagName: 'tv'),
        //     // totalTableChildCell(
        //     //     text: dummyInvoice!.totalTaxes == 0 ||
        //     //             dummyInvoice!.totalTaxes == '' ||
        //     //             dummyInvoice!.totalTaxes == null
        //     //         ? ''
        //     //         : 'Rs ${dummyInvoice!.totalTaxes.toString()}',
        //     //     tagName: 'taxes'),
        //     // totalTableChildCell(
        //     //     text: 'Rs ${dummyInvoice!.total.toString()}', tagName: 'total'),
        //   ]
        ? []
        : [];
  }

  totalTableChildCell({required String text, required String tagName}) {
    return pw.Container(
      // padding: pw.EdgeInsets.all(10),
      padding: pw.EdgeInsets.symmetric(
        horizontal: 0.03,
        vertical: 10,
      ),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          right: (tagName == 's.no' || tagName == 'taxes')
              ? pw.BorderSide(
                  style: pw.BorderStyle.solid,
                  color: PdfColors.grey,
                  width: 1,
                )
              : pw.BorderSide.none,
          top: (tagName == 's.no')
              ? pw.BorderSide(
                  style: pw.BorderStyle.solid,
                  color: PdfColors.grey,
                  width: 1,
                )
              : pw.BorderSide.none,
          left: (tagName == 'taxes')
              ? pw.BorderSide(
                  style: pw.BorderStyle.solid,
                  color: PdfColors.grey,
                  width: 1,
                )
              : pw.BorderSide.none,
          // bottom: pw.BorderSide(
          //   color: PdfColors.grey,
          //   width: 0.5,
          // ),
          // left: pw.BorderSide(
          //   color: PdfColors.grey,
          //   width: 0.5,
          // ),
        ),
      ),
      // height: 6.h,
      height: 6,
      child: pw.Center(
        child: pw.Container(
          // width: 47.w,
          width: 47,
          //color: PdfColors.amber,
          child: pw.Text(
            (text.isEmpty && tagName == 'taxes') ? '-' : text,
            maxLines: 4,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              // fontSize: 7.sp,
              fontSize: 7,
              color: PdfColors.black,
            ),
          ),
        ),
      ),
    );
  }

  List itemRows(int start, int end) {
    List l = dummyInvoice!.items!;

    List tempList = [];
    for (int i = start; i <= end; i++) {
      print(i);
      tempList.add(itemRowTableAsList(l[i], i));
    }
    return tempList;
  }

  headerTableRowAsList() {
    return [
      tableHeaderCell(
        text: headerList[0],
      ),
      tableHeaderCell(
        text: headerList[1],
      ),
      tableHeaderCell(
        text: headerList[2],
      ),
      tableHeaderCell(
        text: headerList[3],
      ),
      tableHeaderCell(
        text: headerList[4],
      ),
      tableHeaderCell(
        text: headerList[5],
      ),
      // tableHeaderCell(
      //   text: headerList[6],
      // ),
      // tableHeaderCell(
      //   text: headerList[7],
      // ),
      // tableHeaderCell(
      //   text: headerList[8],
      // ),
    ];
  }

  itemRowTableAsList(
    orderedItems item,
    int index,
  ) {
    return [
      // tableChildCell(text: (index + 1).toString(), tagName: 's.no'),
      // tableChildCell(
      //     text:
      //         "ACCUSURE DIGITAL THERMOMETER ACCUSURE DIGITAL THERMOMETER ACCUSURE DIGITAL THERMOMETER ACCUSURE DIGITAL THERMOMETER",
      //     tagName: 's.no'),
      tableChildCell(text: item.descriptionName ?? "", tagName: 'product'),
      tableChildCell(
          text: singleOrderDetail["items"][index]["discountInfo"] ?? "",
          tagName: 'desc'),

      tableChildCell(text: item.qty.toString(), tagName: 'qty'),
      tableChildCell(
          text: singleOrderDetail["items"][index]["mrp"] == null
              ? ""
              : "Rs. ${singleOrderDetail["items"][index]["mrp"].toString()}",
          tagName: 'mrp'),
      tableChildCell(
          text: singleOrderDetail["items"][index]["price"] == null
              ? ""
              : "Rs. ${singleOrderDetail["items"][index]["price"].toString()}",
          tagName: 'mrp'),
      tableChildCell(
        text:
            'Rs ${(singleOrderDetail["items"][index]["price"] * singleOrderDetail["items"][index]["quantity"]).toString()}',
        tagName: 'ga',
      ),
      // tableChildCell(text: item.discountTotal.toString(), tagName: 'dit'),
      // tableChildCell(text: item.taxableValue.toString(), tagName: 'tv'),
      // tableChildCell(
      //   text: item.taxes == '' ? '' : 'Rs ${item.taxes.toString()}',
      //   tagName: 'taxes',
      // ),
      // tableChildCell(text: 'Rs ${item.total.toString()}', tagName: 'total'),
    ];
  }

  List<String> headerList = [
    'Product',
    'Discount',
    'Qty',
    'MRP',
    'Price',
    'Total',
    // 'Taxable Value',
    // 'Taxes',
    // 'Total',
  ];
  // tableHeaderRow() {
  //   return headerList.map((e) => tableHeaderCell(text: e)).toList();
  // }

  tableChildCell({required String text, required String tagName}) {
    return pw.Container(
      padding: pw.EdgeInsets.symmetric(
        horizontal: 0.03,
        vertical: 10,
      ),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          right: pw.BorderSide(
            style: pw.BorderStyle.solid,
            color: PdfColors.grey,
            width: 1,
          ),
          // top: pw.BorderSide(
          //   style: pw.BorderStyle.solid,
          //   color: PdfColors.grey,
          //   width: 1,
          // ),
          bottom: pw.BorderSide(
            style: pw.BorderStyle.solid,
            color: PdfColors.grey,
            width: 1,
          ),
          // left: pw.BorderSide(
          //   color: PdfColors.grey,
          //   width: 0.5,
          // ),
        ),
      ),
      // height: 6.h,
      height: 26,
      child: pw.Center(
        child: pw.Container(
          // width: 47.w,
          // width: 47,
          //color: PdfColors.amber,
          child: pw.Text(
            (text == 'null' || text.isEmpty) ? '-' : text,
            maxLines: 4,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              // fontSize: 7.sp,
              fontSize: 7,
              color: PdfColors.black,
            ),
          ),
        ),
      ),
    );
  }

  tableHeaderCell({required String text}) {
    return pw.Container(
        padding: pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(
          border: pw.Border(
            right: pw.BorderSide(
              style: pw.BorderStyle.solid,
              color: PdfColors.grey,
              width: 1,
            ),
            // top: pw.BorderSide(
            //   color: PdfColors.grey,
            //   width: 0.5,
            // ),
            bottom: pw.BorderSide(
              style: pw.BorderStyle.solid,
              color: PdfColors.grey,
              width: 1,
            ),
            // left: pw.BorderSide(
            //   color: PdfColors.grey,
            //   width: 0.5,
            // ),
          ),
        ),
        child: pw.Center(
          child: pw.Text(
            text,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              // fontSize: 7.sp,
              fontSize: 7,
              color: PdfColors.black,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ));
  }

  header(context) {
    return pw.SizedBox(
      // height: MediaQuery.of(context).size.height * 0.23,
      width: double.infinity,
      child: pw.Column(
          // mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            companyDetails(),
            pw.SizedBox(height: 20),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Expanded(
                    child: deliveryDetails1(),
                  ),
                  pw.Expanded(child: deliveryDetails2()),

                  // billToShipTo(context),
                  //orderNoAndDate(),
                  // invoiceDetails(),
                ]),
          ]),
    );
  }

  invoiceDetails() {
    return pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            pw.Center(
              child: pw.Image(image, height: 60),
            ),
            pw.SizedBox(
              height: 8,
            ),
            pw.Text(
              'Tax Invoice',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              'Original For Recipient',
              style: pw.TextStyle(),
            ),
          ]),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            pw.Text(
              'Invoice Number',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              dummyInvoice!.invoiceNumber ?? ' ',
              style: pw.TextStyle(),
            ),
          ]),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            pw.Text(
              'Invoice Date',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              dummyInvoice!.invoiceDate ?? ' ',
              style: pw.TextStyle(),
            ),
          ])
        ]);
  }

  orderNoAndDate() {
    return pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
      pw.Text(
        'Order Number',
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
        ),
      ),
      pw.Text(
        dummyInvoice!.orderNumber ?? ' ',
        style: pw.TextStyle(),
      ),
      // pw.SizedBox(height: 2.h),
      pw.SizedBox(height: 2),
      pw.Text(
        'Order Date',
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
        ),
      ),
      pw.Text(
        dummyInvoice!.orderDate ?? ' ',
        style: pw.TextStyle(),
      ),
    ]);
  }

  companyDetails() {
    return pw.Column(children: [
      pw.Text(
        'Invoice',
        style: pw.TextStyle(),
      ),
      pw.Text(
        'Acintyo Central Store',
        style: pw.TextStyle(),
      ),
      pw.Text(
        'B-4, Asbestos Colony, Kukatpally, Hyderabad, Telangana 500037, India',
        style: pw.TextStyle(),
      )
    ]);
  }

  deliveryDetails1() {
    String backendDateTimeString = singleOrderDetail["orderCreatedDate"];

    DateTime dateTime = DateTime.parse(backendDateTimeString);

    String formattedDateTime =
        DateFormat("dd/MM/yyyy hh:mm:ss a").format(dateTime);

    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Order No: ${singleOrderDetail["id"] ?? ""}',
            style: pw.TextStyle(),
          ),
          pw.Text(
            'Order Date: $formattedDateTime',
            style: pw.TextStyle(),
          ),
          pw.Text(
            'Transaction Id: ${singleOrderDetail["paymentTrasactionId"] ?? ""}',
            style: pw.TextStyle(),
          ),
          pw.SizedBox(height: 30),
          pw.Text(
            'Deliver To:',
            style: pw.TextStyle(),
          ),
          pw.Text(
            singleOrderDetail["deliveryAddress"]["name"] ?? "",
            style: pw.TextStyle(),
          ),
          pw.Text(
            singleOrderDetail["deliveryAddress"]["mobileNumber"] ?? "",
            style: pw.TextStyle(),
          ),
          pw.Text(
            singleOrderDetail["deliveryAddress"]["addresslineMobileOne"] ?? "",
            style: pw.TextStyle(),
          ),
          pw.Text(
            singleOrderDetail["deliveryAddress"]["addresslineMobileTwo"] ?? "",
            style: pw.TextStyle(),
          ),
          pw.Text(
            singleOrderDetail["deliveryAddress"]["landMark"] ?? "",
            style: pw.TextStyle(),
          ),
          pw.Text(
            singleOrderDetail["deliveryAddress"]["addressLine1"] ?? "",
            style: pw.TextStyle(),
          ),
        ]);
  }

  deliveryDetails2() {
    String dateString =
        singleOrderDetail["createdAt"]; // Your input date string

    print("printing slot -> ${singleOrderDetail["slot"]}");

    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
      // pw.Center(
      // child: pw.Image(image, height: 60),
      // ),
      pw.Image(image, height: 60),
      pw.SizedBox(height: 10),
      pw.Text(
        'Delivery Date and Slot',
        style: pw.TextStyle(),
      ),
      pw.Text(
        '${dateString.substring(0, 2) + '/' + dateString.substring(2, 4) + '/' + dateString.substring(4)}',
        style: pw.TextStyle(),
      ),
      pw.Text(
        singleOrderDetail["slot"] ?? "",
        style: pw.TextStyle(),
      ),
    ]);
  }

  billToShipTo(context) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text(
            'BILL TO:',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(
            // height: 0.5.h,
            height: 0.5,
          ),
          (dummyInvoice!.billTo?.name == null ||
                  dummyInvoice!.billTo?.name == 'null' ||
                  dummyInvoice!.billTo!.name!.isEmpty)
              ? pw.SizedBox()
              : pw.Text(
                  '${dummyInvoice!.billTo?.name},',
                  style: pw.TextStyle(),
                ),
          pw.SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: pw.Text(
              '${dummyInvoice!.billTo?.billingAddress ?? ' '},',
              style: pw.TextStyle(),
            ),
          ),
        ]),
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text(
            'SHIP TO:',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(
            // height: 0.5.h,
            height: 0.5,
          ),
          pw.Text(
            '${dummyInvoice!.shipTo?.name ?? ' '},',
            style: pw.TextStyle(),
          ),
          pw.Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: pw.Text(
              '${dummyInvoice!.shipTo?.shippingAddress ?? ' '},',
              style: pw.TextStyle(),
            ),
          ),
        ]),
      ],
    );
  }

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    isPdfDownloading = true;
    update();
    final path = ((Platform.isAndroid)
            ? await getExternalStorageDirectory()
            : await getApplicationSupportDirectory())!
        .path;
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    OpenFilex.open('$path/$fileName');
    isPdfDownloading = false;
    update();
  }

  Future downloadFile(var fileName, var documentUrl) async {
    try {
      /// setting filename

      String dir = (await getApplicationDocumentsDirectory()).path;
      //print(dir);
      if (await File('$dir/${fileName}.pdf').exists())
        return File('$dir/${fileName}.pdf');

      String url = documentUrl;

      /// requesting http to get url
      var request = await HttpClient().getUrl(Uri.parse(url));

      /// closing request and getting response
      var response = await request.close();

      /// getting response data in bytes
      var bytes = await consolidateHttpClientResponseBytes(response);
      // DocumentFileSavePlus.saveFile(bytes, "$fileName.pdf", "appliation/pdf");

      /// generating a local system file with name as 'filename' and path as '$dir/$filename'
      File file = new File('$dir/${fileName}.pdf');

      /// writing bytes data of response in the file.
      await file.writeAsBytes(bytes);

      return file;
    } catch (err) {
      print(err);
    }
    isPdfDownloading = false;
    update();
  }
}
