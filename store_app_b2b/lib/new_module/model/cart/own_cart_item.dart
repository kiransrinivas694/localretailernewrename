class OwnCartItem {
  String productId;
  int quantity;

  OwnCartItem({required this.productId, required this.quantity});
}

class OwnMedicineItem {
  final String productId;
  final String productName;
  final String skuId;
  final String mesuare;
  final String productUrl;
  final String storeName;
  final bool isPrescriptionIsRequired;
  final num price;
  final String tabletsPerStrip;
  final String categoryName;
  final String discountType;
  final num discount;
  final num mrp;
  final String composition;

  OwnMedicineItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.skuId,
    required this.mesuare,
    required this.productUrl,
    required this.storeName,
    required this.isPrescriptionIsRequired,
    required this.tabletsPerStrip,
    required this.categoryName,
    required this.discountType,
    required this.discount,
    required this.mrp,
    required this.composition,
  });
}
