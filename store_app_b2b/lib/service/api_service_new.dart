class API {
  // static const baseUrl = "https://acintyotechapi.com/"; // live
  static String appVersion = "";
  static String baseUrl = "http://137.59.201.34:8090/b2b/"; // local
  static String razorpayKey = ""; //Razorpay Key

  static const bool enableToken = false;

  static String generalMedicineCategoryId = '';
  static String genericMedicineCategoryId = '';
  static String sppCategoryId = '';
  static String checkout1 = "";
  static String checkout2 = "";
  static String checkout3 = "";
  static String customerCareNumber = "";
  static bool campaignsShowing = false;
  static List campaignImg = [];
  static String campaignContent = "";
  static bool emergencyStop = false;
  static String emergencyStopImg = "";

  static bool needMaxTimeStopFunctionality = false;
  static num maxTimeToStopOrder = 22;

  /// Auth
  static String logInWithPhone = '${baseUrl}api-auth/verify/phone';
  static String verifyPhone = '${baseUrl}api-auth/verify/store/phone/';
  static String verifyEmail = '${baseUrl}api-auth/verify/store/email/';

  static String logIn = '${baseUrl}api-auth/store/login/email';
  static String register = '${baseUrl}api-auth/store/mOnboard/register';
  static String verifyOtp = '${baseUrl}api-auth/verify/otp';
  // static String sendOtp = '${baseUrl}api-auth/send/otp'; --> this is initially used one , but suddenly came errors so changed to below one.
  static String sendOtp = '${baseUrl}api-auth/';
  static String uploadImageURL = '${baseUrl}api-auth/image';
  static String storeLogin = '${baseUrl}api-auth/store/login/otp';
  static String getAccountStatus = '${baseUrl}api-auth/store/accountStatus';
  static String getStoreCreditRating = '${baseUrl}api-auth/retailerId';
  static String deliverySlots = '${baseUrl}api-master/delivarySlots';
  static String getCategory = '${baseUrl}api-product/categorys';

  /// Home
  // Supplier
  static String allSuppliers =
      '${baseUrl}api-auth/store/b2b/mobile/getAllSuppliers';
  static String linkedSuppliers =
      '${baseUrl}api-auth/store/b2b/linkSuppliersList';

  static String connectAPIPost = '${baseUrl}api-auth/store/b2b/linkSupplier';
  static String bannerTopApi = '${baseUrl}api-banner/banners/mobile/row';

  /// Profile
  static String profile = '${baseUrl}api-auth/store/profile';
  static String editProfile = '${baseUrl}api-auth/store/profile';

  /// Dashboard Stats
  static String topBuyingProducts =
      "${baseUrl}api-oms/storeTopSellingProducts/user";
  static String purchasesAndProfits =
      "${baseUrl}api-oms/storeLtdSalesInfo/user/";

  /// Buy
  // By Product
  // static String getBuyProduct = '${baseUrl}api-product/product/b2b/text';
  static String getBuyProduct =
      '${baseUrl}api-product/product/b2b/search/supplier';
  static String getSupplierList = "${baseUrl}api-auth/store/storeUsers/admin/2";
  static String getProductDetails = '${baseUrl}api-product/product';
  static String getAddToCart = '${baseUrl}api-cart/cart/items';
  static String getNrAddToCart = '${baseUrl}api-cart/nrCart/items';
  static String addGrbOrderToCart = '${baseUrl}api-oms/grborder/addItem';
  static String addToCartGrb = '${baseUrl}api-cart/grb/items';
  static String editGrb = '${baseUrl}api-cart/grb/update/cart';
  static String checkProductAvailableInCart = "${baseUrl}api-cart/cart";
  static String nrCheckProductAvailableInCart = "${baseUrl}api-cart/nrCart";
  static String checkGrbItemAvaialbleInCart =
      "${baseUrl}api-cart/grb/ckeckItem/userId";
  static String checkProductQuantityAvailable =
      "${baseUrl}api-product/inventory";
  static String getUpdateQtyAddToCart = '${baseUrl}api-cart/cart/quantity/sku';
  static String getNrUpdateQtyAddToCart =
      '${baseUrl}api-cart/nrCart/quantity/sku';
  static String getAddFavorite = '${baseUrl}api-cart/favorite/b2b';
  static String getAddFavListToCart =
      '${baseUrl}api-cart/favorite/b2b/moveToCart/favList/';
  static String getFavoriteNameList = '${baseUrl}api-cart/favorite/b2b/favList';
  static String getDeleteFavourite = '${baseUrl}api-cart/favorite/b2b/favList';
  static String getDeleteFavouriteListItem =
      '${baseUrl}api-cart/favorite/b2b/favList';
  static String getByDate = '${baseUrl}api-oms/user';
  static String getNrByDate = '${baseUrl}api-oms/nr/orders/user';
  static String getTOdayOrderCount =
      '${baseUrl}api-oms/order/store/order-count/retailerId';
  static String getGrbByDate = "${baseUrl}api-oms/grbOrders/user";
  static String getLatestOrder = '${baseUrl}api-oms/user';
  static String getUnlistedProduct = '${baseUrl}api-oms/user';
  static String getGrbReturnOrderList =
      '${baseUrl}api-oms/grborder/salesAgg/store';
  static String getExpiryProdutsList =
      '${baseUrl}api-oms/grb/expiry-items/storeId';
  // Favourite
  static String getFavoriteList = '${baseUrl}api-cart/favorite/b2b';
  static String getUpdateQtyFavoriteItem =
      '${baseUrl}api-cart/favorite/b2b/qtyUpdate/favList';

  // by supplier
  static String getBuySupplier = '${baseUrl}api-product/product/b2b/text';

  // find More
  static String getAddFindProduct =
      '${baseUrl}api-cart/cart/b2b/UnverifiedProducts/store';
  static String getDeleteFindProduct =
      '${baseUrl}api-cart/cart/b2b/removeUnverifiedProducts';
  static String getUnverifiedProducts =
      '${baseUrl}api-cart/cart/b2b/getUnverifiedProducts/userId';
  static String getUnListedProductsPlaced =
      '${baseUrl}api-cart/cart/b2b/getUnverifiedProducts/userId';

  /// Payment
  // Payment Request
  static String getPaymentRequest = '${baseUrl}api-oms/billedOrders/user';
  static String getPaymentOverview =
      '${baseUrl}api-oms/billedOrders/summary/storeId/payerId?storeId=';
  static String getPaymentSuccess = '${baseUrl}api-oms/b2b/paymentRequest';
  static String getPaymentSuccessCustom =
      '${baseUrl}api-oms/b2b/customPaymentRequest';
  static String getFullyPaid = '${baseUrl}api-oms/billedOrders/fullyPaid/user';
  static String getPaymentHistoryByOrder =
      '${baseUrl}api-oms/b2b/paymentDetailsRetailer/payerId';

  /// Credit Note
  static String getCreditNoteHistory = '${baseUrl}api-oms/creditNote/user';
  static String getCreditNoteHeader = '${baseUrl}api-oms/creditNoteHeader/user';
//entrynote
  static String getEntryNoteHistory =
      '${baseUrl}api-oms/v1/get/retailerPaymentRequest/retailerId/';
  static String postPaymentData =
      '${baseUrl}api-oms/add/retailerPaymentRequest';
  static String putPaymentData =
      '${baseUrl}api-oms/update/retailerPaymentRequest';

  /// Cart
  // Verified Product
  static String getVerifiedProduct = '${baseUrl}api-cart/cart/user';
  static String getNrVerfiedProduct = '${baseUrl}api-cart/nrCart/user';
  static String getGrbCart = '${baseUrl}api-oms/grbOrders/user';
  static String getCartGrb = '${baseUrl}api-cart/grb/user';
  static String getGRBSchemeBatches = "${baseUrl}api-oms/grb/get-items/orderId";
  static String getLaterDeliveryData = '${baseUrl}api-cart/laterDayCart/user';
  static String getTodayDeliveryData =
      '${baseUrl}api-cart/laterDayCart/today/user';
  static String getPlaceOrder = '${baseUrl}api-checkout/before/checkout';
  static String getNrPlaceOrder = '${baseUrl}api-checkout/before/NrCheckout';
  static String updateNetworkRetailerStatus =
      "${baseUrl}api-auth/network/status";
  static String onboardSupplierPost = "${baseUrl}api-auth/store/linkSupplier";
  static String linkRetailer = "${baseUrl}api-auth/linkRetailer";
  static String unlinkRetailer = "${baseUrl}api-auth/unlinkRetailer";
  static String getAllRetailers = "${baseUrl}api-auth/store/storeUsers/admin/2";
  static String getLinkedRetailers = "${baseUrl}api-auth/getLinkedStores";
  static String getRequestRetailers =
      "${baseUrl}api-auth/getLinkedRetailerStores";
  static String getConfirmOrder = '${baseUrl}api-checkout/${checkout2}';
  static String getNrConfirmOrder = '${baseUrl}api-checkout/nrCheckout';
  static String generateGrb = "${baseUrl}api-oms/grborder/confrimGrb";
  static String checkoutGrb = "${baseUrl}api-checkout/grb-order/cart";
  static String getSchemeQtyCal =
      '${baseUrl}api-product/product/b2b/getSchemQtyCal';
  static String storeCategory = '${baseUrl}api-auth/storeCategory/store';
  static String getOrderDetails = '${baseUrl}api-oms/user';
  static String sendCSVForOrder = '${baseUrl}api-oms/sendmail/csv';
  static String getGrbOrderDetails = '${baseUrl}api-oms/grbOrders/user';
  static String getStoreWiseDeleteProduct = '${baseUrl}api-cart/cart';
  static String getNrStoreWiseDeleteProduct = '${baseUrl}api-cart/nrCart';
  static String getSingleItemDeleteFromCart = '${baseUrl}api-cart/cart';
  static String getNrSingleItemDeleteFromCart = '${baseUrl}api-cart/nrCart';
  static String singleItemDeleteFromGrbCart = '${baseUrl}api-cart/grb';
  static String getSchemeQty =
      '${baseUrl}api-product/product/b2b/getSchemQtyCal';
  static String getUnverifiedPlaceOrder =
      '${baseUrl}api-cart/cart/b2b/getUnverifiedProducts/palceOrder/userId';

  /// Inventory
  static String getInventory = '${baseUrl}api-product/product/store';

  ///Notification
  static String getNotification = '${baseUrl}api-banner/alert/user/';
  static String deleteNotification = '${baseUrl}api-banner/alert/';
  static String getInternalPopUp = '${baseUrl}api-banner/alert/internal/user/';
  static String updatePopupValue = '${baseUrl}api-banner/alert/updateUserViwed';
  static String updatePopupConfirmation = '${baseUrl}api-oms/user/confirmUser';

  ///App Subscription
  static String getSubscriptionPopup =
      '${baseUrl}api-banner/getSubscriptions?page=0&size=10';
  static String getSubscriptionSubscribe = '${baseUrl}api-banner/subscribe';

  ///New Subscription format
  static String getSubscriptionPlanLabels =
      '${baseUrl}api-banner/getPlanTypeLabels/planTenure';
  static String getSubscriptionPlanByTenure =
      "${baseUrl}api-banner/getSubscriptions/";
  static String getAllSubscriptionsHistory =
      "${baseUrl}api-banner/user/getAllSubscription/";

  //Refer Supplier
  static String addReferSupplier = '${baseUrl}api-auth/store/refferSupplier';

  /// Quick Delivery
  static String getQuickSuppliers =
      '${baseUrl}api-auth/store/storeUsers/quickList/admin/2';
  static String addFirstQuickProductToCart = '${baseUrl}api-cart/quickCart';
  static String addMoreQuickProductToCart = '${baseUrl}api-cart/quickCart';
  static String getQuickCartDetails = '${baseUrl}api-cart/quickCart';
  static String deleteQuickCart = '${baseUrl}api-cart/quickCart';
  static String deleteQuickCartItem = '${baseUrl}api-cart/quickCart';
  static String quickProductCheckOut = '${baseUrl}api-cart/quickCart';
  static String historyProductCheckOut = '${baseUrl}api-cart/quickCart';
  static String getQuickProductHistory =
      '${baseUrl}api-cart/quickCart/history/user';

  //delete account

  static String deleteAccount = "${baseUrl}api-auth/v1/user";
}
