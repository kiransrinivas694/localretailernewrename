// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

// import 'package:autocart/modules/account/order/controller/order_controller.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/order_review_screens/invoicecontroller_new.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:sizer/sizer.dart';

// import 'package:autocart/invoicecontroller.dart';

// import 'modules/account/order/model/order_details_model.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  @override
  void initState() {
    getOrderData();
    // TODO: implement initState
    super.initState();
  }

  Invoice? dummyInvoice;
  // OrderDetailsModel? model;
  Map? model;
  getOrderData() {
    // model = Get.find<OrderController>().orderDetails;
    model = {
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
    dummyInvoice = Invoice(
        billTo: BillTo(
          // name: model!.pickupAddress?.name ?? 'null',
          // billingAddress: model!.pickupAddress?.addressLine1 ?? ' ',
          name: 'Kiran Srinivas',
          billingAddress: 'Suryaraopet - bill to ',
        ),
        shipTo: ShipTo(
          // name: model!.deliveryAddress?.name ?? ' ',
          // shippingAddress: model!.deliveryAddress?.addressLine1 ?? ' ',
          name: 'Kiran Srinivas',
          shippingAddress: 'Suryaraopet - bill to ',
        ),
        invoiceDate: 'dummy',
        invoiceNumber: 'dummy',
        // orderNumber: model!.id,
        // orderDate: model!.orderCreatedDate.toString(),
        // total: model!.paidAmount,
        // totalTaxes: model!.tax,
        orderNumber: "orderNumber",
        orderDate: "orderDate",
        total: "total",
        totalTaxes: "totalTaxes",
        // items: model!["items"]!
        //     .map((e) => orderedItems(
        //           // qty: e.quantity,
        //           // grossAmount: e.mrp,
        //           // discountTotal: e.discountPrice,
        //           // taxableValue: '',
        //           // taxes: '',
        //           // total: e.totalPrice,
        //           // HSN: e.hsn,
        //           // descriptionName: e.productName,
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
        items: [
          orderedItems(
            HSN: '12412',
            descriptionName: 'dolo',
            qty: 1,
            grossAmount: 120,
            discountTotal: 10,
            taxableValue: 70,
            taxes: 10,
            total: 231,
          ),
          orderedItems(
            HSN: '12412',
            descriptionName: 'polo',
            qty: 1,
            grossAmount: 120,
            discountTotal: 10,
            taxableValue: 70,
            taxes: 10,
            total: 231,
          ),
          orderedItems(
            HSN: '12412',
            descriptionName: 'volvo',
            qty: 1,
            grossAmount: 120,
            discountTotal: 10,
            taxableValue: 70,
            taxes: 10,
            total: 231,
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () async {
          final pdf = pw.Document(
            compress: true,
          );
          pdf.addPage(
            pw.MultiPage(
              maxPages: 100,
              orientation: pw.PageOrientation.portrait,
              // margin: pw.EdgeInsets.all(5.w),
              margin: pw.EdgeInsets.all(5),
              pageFormat: PdfPageFormat.a4,
              build: (context) {
                //calculateNoOfPages();
                return [
                  pw.Column(children: [
                    header(),
                    pw.SizedBox(
                      // height: 3.5.h,
                      height: 3.5,
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
          Get.put(InvoiceController()).saveAndLaunchFile(bytes, 'sd.pdf');
          // saveAndLaunchFile(bytes, "sample.pdf");
        },
        child: Center(
            child: Container(
          color: Colors.red,
          child: Text('pdf'),
        )),
      ),
    );
  }

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    // isPdfDownloading = true;
    // update();
    final path = ((Platform.isAndroid)
            ? await getExternalStorageDirectory()
            : await getApplicationSupportDirectory())!
        .path;
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    OpenFilex.open('$path/$fileName');
    // isPdfDownloading = false;
    // update();
  }

  redirectToInvoice() async {
    final pdf = pw.Document(
      compress: true,
    );
    pdf.addPage(
      pw.MultiPage(
        maxPages: 100,
        orientation: pw.PageOrientation.portrait,
        // margin: pw.EdgeInsets.all(5.w),
        margin: pw.EdgeInsets.all(5),
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          //calculateNoOfPages();
          return [
            pw.Column(children: [
              header(),
              pw.SizedBox(
                // height: 3.5.h,
                height: 3.5,
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
    // Get.put(InvoiceController()).saveAndLaunchFile(bytes, '${model!.id}.pdf');
    Get.put(InvoiceController()).saveAndLaunchFile(bytes, 'sample.pdf');
  }

  footer() {
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Terms & Conditions:',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(
            height: 10,
          ),
          pw.Row(children: [
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
              child: pw.Text(
                  'dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy '),
            ),
          ]),
        ]);
  }

  calculateNoOfPages() {
    int firstPageLimit = 8;
    int fromSecondPageLimit = 11;
    var x = dummyInvoice!.items!.length;
    // int y = (10 / 8).round();
    // print(y);
    int noOfPages = (x / 11).round();
    print(noOfPages);
    int remElements = 10 - firstPageLimit;
    print('rem = $remElements');
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
        // 0: pw.FixedColumnWidth(16.w),
        // 1: pw.FixedColumnWidth(47.w),
        // 2: pw.FixedColumnWidth(17.w),
        // 3: pw.FixedColumnWidth(11.w),
        // 4: pw.FixedColumnWidth(22.w),
        // 5: pw.FixedColumnWidth(22.w),
        // 6: pw.FixedColumnWidth(21.w),
        // 7: pw.FixedColumnWidth(17.w),
        // 8: pw.FixedColumnWidth(17.w),
        0: pw.FixedColumnWidth(16),
        1: pw.FixedColumnWidth(47),
        2: pw.FixedColumnWidth(17),
        3: pw.FixedColumnWidth(11),
        4: pw.FixedColumnWidth(22),
        5: pw.FixedColumnWidth(22),
        6: pw.FixedColumnWidth(21),
        7: pw.FixedColumnWidth(17),
        8: pw.FixedColumnWidth(17),
      },

      //defaultColumnWidth: pw.IntrinsicColumnWidth(),
      border: pw.TableBorder.symmetric(
        outside: pw.BorderSide(
          width: 1,
          color: PdfColors.grey,
          style: pw.BorderStyle.solid,
        ),
        inside: pw.BorderSide(
          width: 1,
          color: PdfColors.grey,
          style: pw.BorderStyle.solid,
        ),
      ),
      data: [
        headerTableRowAsList(),
        ...itemRows(startIndex, endIndex),
      ],
    ));
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
      tableHeaderCell(
        text: headerList[6],
      ),
      tableHeaderCell(
        text: headerList[7],
      ),
      tableHeaderCell(
        text: headerList[8],
      ),
    ];
  }

  itemRowTableAsList(
    orderedItems item,
    int index,
  ) {
    return [
      tableChildCell(text: (index + 1).toString(), tagName: 's.no'),
      tableChildCell(text: item.descriptionName ?? ' ', tagName: 'desc'),
      tableChildCell(text: item.HSN.toString(), tagName: 'hsn'),
      tableChildCell(text: item.qty.toString(), tagName: 'qty'),
      tableChildCell(text: item.grossAmount.toString(), tagName: 'ga'),
      tableChildCell(text: item.discountTotal.toString(), tagName: 'dit'),
      tableChildCell(text: item.taxableValue.toString(), tagName: 'tv'),
      tableChildCell(text: item.taxes.toString(), tagName: 'taxes'),
      tableChildCell(text: item.total.toString(), tagName: 'total'),
    ];
  }

  List<String> headerList = [
    'Sno',
    'Description',
    'HSN',
    'Qty',
    'Gross Amount',
    'Discount Total',
    'Taxable Value',
    'Taxes',
    'Total',
  ];
  // tableHeaderRow() {
  //   return headerList.map((e) => tableHeaderCell(text: e)).toList();
  // }

  tableChildCell({required String text, required String tagName}) {
    return pw.Container(
      // height: 6.h,
      height: 6,
      child: pw.Center(
        child: pw.Container(
          // width: 47.w,
          width: 47,
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
    return pw.Padding(
      // padding: pw.EdgeInsets.all(2.w),
      padding: pw.EdgeInsets.all(2),
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
      ),
    );
  }

  header() {
    return pw.SizedBox(
      height: MediaQuery.of(context).size.height * 0.23,
      child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            billToShipTo(),
            orderNoAndDate(),
            invoiceDetails(),
          ]),
    );
  }

  invoiceDetails() {
    return pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
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

  billToShipTo() {
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
}

class Invoice {
  BillTo? billTo;
  ShipTo? shipTo;
  String? orderNumber;
  String? orderDate;
  String? invoiceNumber;
  String? invoiceDate;
  dynamic totalTaxes;
  dynamic total;
  List<orderedItems>? items;
  Invoice({
    this.billTo,
    this.shipTo,
    this.orderNumber,
    this.orderDate,
    this.invoiceNumber,
    this.invoiceDate,
    this.totalTaxes,
    this.total,
    this.items,
  });

  Invoice copyWith({
    BillTo? billTo,
    ShipTo? shipTo,
    String? orderNumber,
    String? orderDate,
    String? invoiceNumber,
    String? invoiceDate,
    dynamic? totalTaxes,
    dynamic? total,
    List<orderedItems>? items,
  }) {
    return Invoice(
      billTo: billTo ?? this.billTo,
      shipTo: shipTo ?? this.shipTo,
      orderNumber: orderNumber ?? this.orderNumber,
      orderDate: orderDate ?? this.orderDate,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      totalTaxes: totalTaxes ?? this.totalTaxes,
      total: total ?? this.total,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'billTo': billTo?.toMap(),
      'shipTo': shipTo?.toMap(),
      'orderNumber': orderNumber,
      'orderDate': orderDate,
      'invoiceNumber': invoiceNumber,
      'invoiceDate': invoiceDate,
      'totalTaxes': totalTaxes,
      'total': total,
      'items': items?.map((x) => x.toMap()).toList(),
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      billTo: map['billTo'] != null
          ? BillTo.fromMap(map['billTo'] as Map<String, dynamic>)
          : null,
      shipTo: map['shipTo'] != null
          ? ShipTo.fromMap(map['shipTo'] as Map<String, dynamic>)
          : null,
      orderNumber:
          map['orderNumber'] != null ? map['orderNumber'] as String : null,
      orderDate: map['orderDate'] != null ? map['orderDate'] as String : null,
      invoiceNumber:
          map['invoiceNumber'] != null ? map['invoiceNumber'] as String : null,
      invoiceDate:
          map['invoiceDate'] != null ? map['invoiceDate'] as String : null,
      totalTaxes: map['totalTaxes'] as dynamic,
      total: map['total'] as dynamic,
      items: List<orderedItems>.from(
        (map['items'] as List<int>).map<orderedItems>(
          (x) => orderedItems.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Invoice.fromJson(String source) =>
      Invoice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Invoice(billTo: $billTo, shipTo: $shipTo, orderNumber: $orderNumber, orderDate: $orderDate, invoiceNumber: $invoiceNumber, invoiceDate: $invoiceDate, totalTaxes: $totalTaxes, total: $total, items: $items)';
  }

  @override
  bool operator ==(covariant Invoice other) {
    if (identical(this, other)) return true;

    return other.billTo == billTo &&
        other.shipTo == shipTo &&
        other.orderNumber == orderNumber &&
        other.orderDate == orderDate &&
        other.invoiceNumber == invoiceNumber &&
        other.invoiceDate == invoiceDate &&
        other.totalTaxes == totalTaxes &&
        other.total == total &&
        listEquals(other.items, items);
  }

  @override
  int get hashCode {
    return billTo.hashCode ^
        shipTo.hashCode ^
        orderNumber.hashCode ^
        orderDate.hashCode ^
        invoiceNumber.hashCode ^
        invoiceDate.hashCode ^
        totalTaxes.hashCode ^
        total.hashCode ^
        items.hashCode;
  }
}

class orderedItems {
  String? descriptionName;
  String? HSN;
  dynamic qty;
  dynamic grossAmount;
  dynamic discountTotal;
  dynamic taxableValue;
  dynamic taxes;
  dynamic total;
  orderedItems({
    this.descriptionName,
    this.HSN,
    this.qty,
    this.grossAmount,
    this.discountTotal,
    this.taxableValue,
    this.taxes,
    this.total,
  });

  orderedItems copyWith({
    String? descriptionName,
    String? HSN,
    dynamic qty,
    dynamic grossAmount,
    dynamic discountTotal,
    dynamic taxableValue,
    dynamic taxes,
    dynamic total,
  }) {
    return orderedItems(
      descriptionName: descriptionName ?? this.descriptionName,
      HSN: HSN ?? this.HSN,
      qty: qty ?? this.qty,
      grossAmount: grossAmount ?? this.grossAmount,
      discountTotal: discountTotal ?? this.discountTotal,
      taxableValue: taxableValue ?? this.taxableValue,
      taxes: taxes ?? this.taxes,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'descriptionName': descriptionName,
      'HSN': HSN,
      'qty': qty,
      'grossAmount': grossAmount,
      'discountTotal': discountTotal,
      'taxableValue': taxableValue,
      'taxes': taxes,
      'total': total,
    };
  }

  factory orderedItems.fromMap(Map<String, dynamic> map) {
    return orderedItems(
      descriptionName: map['descriptionName'] != null
          ? map['descriptionName'] as String
          : null,
      HSN: map['HSN'] != null ? map['HSN'] as String : null,
      qty: map['qty'] as dynamic,
      grossAmount: map['grossAmount'] as dynamic,
      discountTotal: map['discountTotal'] as dynamic,
      taxableValue: map['taxableValue'] as dynamic,
      taxes: map['taxes'] as dynamic,
      total: map['total'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory orderedItems.fromJson(String source) =>
      orderedItems.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'orderedItems(descriptionName: $descriptionName, HSN: $HSN, qty: $qty, grossAmount: $grossAmount, discountTotal: $discountTotal, taxableValue: $taxableValue, taxes: $taxes, total: $total)';
  }

  @override
  bool operator ==(covariant orderedItems other) {
    if (identical(this, other)) return true;

    return other.descriptionName == descriptionName &&
        other.HSN == HSN &&
        other.qty == qty &&
        other.grossAmount == grossAmount &&
        other.discountTotal == discountTotal &&
        other.taxableValue == taxableValue &&
        other.taxes == taxes &&
        other.total == total;
  }

  @override
  int get hashCode {
    return descriptionName.hashCode ^
        HSN.hashCode ^
        qty.hashCode ^
        grossAmount.hashCode ^
        discountTotal.hashCode ^
        taxableValue.hashCode ^
        taxes.hashCode ^
        total.hashCode;
  }
}

class BillTo {
  String? name;
  String? billingAddress;
  BillTo({
    this.name,
    this.billingAddress,
  });

  BillTo copyWith({
    String? name,
    String? billingAddress,
  }) {
    return BillTo(
      name: name ?? this.name,
      billingAddress: billingAddress ?? this.billingAddress,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'billingAddress': billingAddress,
    };
  }

  factory BillTo.fromMap(Map<String, dynamic> map) {
    return BillTo(
      name: map['name'] != null ? map['name'] as String : null,
      billingAddress: map['billingAddress'] != null
          ? map['billingAddress'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BillTo.fromJson(String source) =>
      BillTo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BillTo(name: $name, billingAddress: $billingAddress)';

  @override
  bool operator ==(covariant BillTo other) {
    if (identical(this, other)) return true;

    return other.name == name && other.billingAddress == billingAddress;
  }

  @override
  int get hashCode => name.hashCode ^ billingAddress.hashCode;
}

class ShipTo {
  String? name;
  String? shippingAddress;
  ShipTo({
    this.name,
    this.shippingAddress,
  });

  ShipTo copyWith({
    String? name,
    String? shippingAddress,
  }) {
    return ShipTo(
      name: name ?? this.name,
      shippingAddress: shippingAddress ?? this.shippingAddress,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'shippingAddress': shippingAddress,
    };
  }

  factory ShipTo.fromMap(Map<String, dynamic> map) {
    return ShipTo(
      name: map['name'] != null ? map['name'] as String : null,
      shippingAddress: map['shippingAddress'] != null
          ? map['shippingAddress'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShipTo.fromJson(String source) =>
      ShipTo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ShipTo(name: $name, shippingAddress: $shippingAddress)';

  @override
  bool operator ==(covariant ShipTo other) {
    if (identical(this, other)) return true;

    return other.name == name && other.shippingAddress == shippingAddress;
  }

  @override
  int get hashCode => name.hashCode ^ shippingAddress.hashCode;
}
