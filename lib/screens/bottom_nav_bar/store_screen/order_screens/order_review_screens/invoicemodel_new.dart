import 'dart:convert';

import 'package:flutter/foundation.dart';

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
