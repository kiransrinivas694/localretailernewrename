import 'dart:convert';

GrbReturnOrdersPageableModel grbReturnOrdersPageableModelFromJson(String str) =>
    GrbReturnOrdersPageableModel.fromJson(json.decode(str));

String grbReturnOrdersPageableModelToJson(GrbReturnOrdersPageableModel data) =>
    json.encode(data.toJson());

class GrbReturnOrdersPageableModel {
  List<GrbReturnOrderModel>? content;
  Pageable? pageable;
  num? totalElements;
  num? totalPages;
  bool? last;
  num? size;
  num? number;
  List<dynamic>? sort;
  num? numberOfElements;
  bool? first;
  bool? empty;

  GrbReturnOrdersPageableModel({
    this.content,
    this.pageable,
    this.totalElements,
    this.totalPages,
    this.last,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.first,
    this.empty,
  });

  factory GrbReturnOrdersPageableModel.fromJson(Map<String, dynamic> json) {
    return GrbReturnOrdersPageableModel(
      content: (json['content'] as List<dynamic>?)
          ?.map((e) => GrbReturnOrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageable: json['pageable'] == null
          ? null
          : Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
      totalElements: json['totalElements'] as num?,
      totalPages: json['totalPages'] as num?,
      last: json['last'] as bool?,
      size: json['size'] as num?,
      number: json['number'] as num?,
      sort: json['sort'] as List<dynamic>?,
      numberOfElements: json['numberOfElements'] as num?,
      first: json['first'] as bool?,
      empty: json['empty'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'content': content?.map((e) => e.toJson()).toList(),
        'pageable': pageable?.toJson(),
        'totalElements': totalElements,
        'totalPages': totalPages,
        'last': last,
        'size': size,
        'number': number,
        'sort': sort,
        'numberOfElements': numberOfElements,
        'first': first,
        'empty': empty,
      };
}

class GrbReturnOrderModel {
  dynamic id;
  String? orderId;
  String? orderStatus;
  String? orderEventId;
  String? packed;
  String? itemId;
  String? productName;
  String? skuCode;
  String? price;
  num? quantity;
  num? freeQuantity;
  num? confirmQuantity;
  num? buyQuantity;
  num? finalQuantity;
  String? totalPrice;
  String? discountAmountLine;
  String? status;
  String? gst;
  String? cgst;
  String? sgst;
  DateTime? expDate;
  dynamic ptr;
  String? mrp;
  num? netRate;
  String? finalPtr;
  String? lineAmount;
  String? hsn;
  String? batchNumber;
  dynamic manufacturer;
  String? gstPercent;
  String? cgstPercent;
  String? sgstPercent;
  String? schemeName;
  String? confirmFlag;
  dynamic categoryId;
  String? rejectedFlag;
  String? modified;
  String? createdAt;
  String? invoiceId;
  String? productId;
  String? userId;
  String? userName;
  String? storeId;
  String? skuId;
  DateTime? orderCreatedDate;

  GrbReturnOrderModel({
    this.id,
    this.orderId,
    this.orderStatus,
    this.orderEventId,
    this.packed,
    this.itemId,
    this.productName,
    this.skuCode,
    this.price,
    this.quantity,
    this.freeQuantity,
    this.confirmQuantity,
    this.buyQuantity,
    this.finalQuantity,
    this.totalPrice,
    this.discountAmountLine,
    this.status,
    this.gst,
    this.cgst,
    this.sgst,
    this.expDate,
    this.ptr,
    this.mrp,
    this.netRate,
    this.finalPtr,
    this.lineAmount,
    this.hsn,
    this.batchNumber,
    this.manufacturer,
    this.gstPercent,
    this.cgstPercent,
    this.sgstPercent,
    this.schemeName,
    this.confirmFlag,
    this.categoryId,
    this.rejectedFlag,
    this.modified,
    this.createdAt,
    this.invoiceId,
    this.productId,
    this.userId,
    this.userName,
    this.storeId,
    this.skuId,
    this.orderCreatedDate,
  });

  factory GrbReturnOrderModel.fromJson(Map<String, dynamic> json) =>
      GrbReturnOrderModel(
        id: json['id'] as dynamic,
        orderId: json['orderId'] as String?,
        orderStatus: json['orderStatus'] as String?,
        orderEventId: json['orderEventId'] as String?,
        packed: json['packed'] as String?,
        itemId: json['itemId'] as String?,
        productName: json['productName'] as String?,
        skuCode: json['skuCode'] as String?,
        price: json['price'] as String?,
        quantity: json['quantity'] as num?,
        freeQuantity: json['freeQuantity'] as num?,
        confirmQuantity: json['confirmQuantity'] as num?,
        buyQuantity: json['buyQuantity'] as num?,
        finalQuantity: json['finalQuantity'] as num?,
        totalPrice: json['totalPrice'] as String?,
        discountAmountLine: json['discountAmountLine'] as String?,
        status: json['status'] as String?,
        netRate: json['netRate'] as num?,
        gst: json['gst'] as String?,
        cgst: json['cgst'] as String?,
        sgst: json['sgst'] as String?,
        expDate: json['expDate'] == null
            ? null
            : DateTime.parse(json['expDate'] as String),
        ptr: json['ptr'] as dynamic,
        mrp: json['mrp'] as String?,
        finalPtr: json['finalPtr'] as String?,
        lineAmount: json['lineAmount'] as String?,
        hsn: json['hsn'] as String?,
        batchNumber: json['batchNumber'] as String?,
        manufacturer: json['manufacturer'] as dynamic,
        gstPercent: json['gstPercent'] as String?,
        cgstPercent: json['cgstPercent'] as String?,
        sgstPercent: json['sgstPercent'] as String?,
        schemeName: json['schemeName'] as String?,
        confirmFlag: json['confirm_flag'] as String?,
        categoryId: json['categoryId'] as dynamic,
        rejectedFlag: json['rejectedFlag'] as String?,
        modified: json['modified'] as String?,
        createdAt: json['createdAt'] as String?,
        invoiceId: json['invoiceId'] as String?,
        productId: json['productId'] as String?,
        userId: json['userId'] as String?,
        userName: json['userName'] as String?,
        storeId: json['storeId'] as String?,
        skuId: json['skuId'] as String?,
        orderCreatedDate: json['orderCreatedDate'] == null
            ? null
            : DateTime.parse(json['orderCreatedDate'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'orderId': orderId,
        'orderStatus': orderStatus,
        'orderEventId': orderEventId,
        'packed': packed,
        'itemId': itemId,
        'netRate': netRate,
        'productName': productName,
        'skuCode': skuCode,
        'price': price,
        'quantity': quantity,
        'freeQuantity': freeQuantity,
        'confirmQuantity': confirmQuantity,
        'buyQuantity': buyQuantity,
        'finalQuantity': finalQuantity,
        'totalPrice': totalPrice,
        'discountAmountLine': discountAmountLine,
        'status': status,
        'gst': gst,
        'cgst': cgst,
        'sgst': sgst,
        'expDate': expDate?.toIso8601String(),
        'ptr': ptr,
        'mrp': mrp,
        'finalPtr': finalPtr,
        'lineAmount': lineAmount,
        'hsn': hsn,
        'batchNumber': batchNumber,
        'manufacturer': manufacturer,
        'gstPercent': gstPercent,
        'cgstPercent': cgstPercent,
        'sgstPercent': sgstPercent,
        'schemeName': schemeName,
        'confirm_flag': confirmFlag,
        'categoryId': categoryId,
        'rejectedFlag': rejectedFlag,
        'modified': modified,
        'createdAt': createdAt,
        'invoiceId': invoiceId,
        'productId': productId,
        'userId': userId,
        'userName': userName,
        'storeId': storeId,
        'skuId': skuId,
        'orderCreatedDate': orderCreatedDate?.toIso8601String(),
      };
}

class Pageable {
  List<dynamic>? sort;
  num? offset;
  num? pageNumber;
  num? pageSize;
  bool? paged;
  bool? unpaged;

  Pageable({
    this.sort,
    this.offset,
    this.pageNumber,
    this.pageSize,
    this.paged,
    this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: json['sort'] as List<dynamic>?,
        // json['sort'] == null
        //     ? null
        //     : Sort.fromJson(json['sort'] as Map<String, dynamic>),
        offset: json['offset'] as num?,
        pageNumber: json['pageNumber'] as num?,
        pageSize: json['pageSize'] as num?,
        paged: json['paged'] as bool?,
        unpaged: json['unpaged'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'sort': sort,
        'offset': offset,
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'paged': paged,
        'unpaged': unpaged,
      };
}

// class Sort {
//   bool? empty;
//   bool? sorted;
//   bool? unsorted;

//   Sort({this.empty, this.sorted, this.unsorted});

//   factory Sort.fromJson(Map<String, dynamic> json) => Sort(
//         empty: json['empty'] as bool?,
//         sorted: json['sorted'] as bool?,
//         unsorted: json['unsorted'] as bool?,
//       );

//   Map<String, dynamic> toJson() => {
//         'empty': empty,
//         'sorted': sorted,
//         'unsorted': unsorted,
//       };
// }
