class ApiConfig {
  /// Todo : BaseUrl
  //static String baseUrl = "https://acintyotechapi.com/"; // live
  static String baseUrl = "http://137.59.201.34:8090/"; // local
  static String razorpayKey = "http://137.59.201.34:8090/"; // Razorpay key

  /// Todo : Exception handling
  static String error = "Error";
  static String success = "Success";
  static String warning = 'Warning';

  /// Todo : Auth
  static String logIn = '${baseUrl}api-auth/store/login/email';
  static String logInWithPhone = '${baseUrl}api-auth/verify/phone';
  static String mobileWithLogin = '${baseUrl}api-auth/store/mobileLoginStore';
  static String storeLogin = '${baseUrl}api-auth/store/login/otp';
  static String register = '${baseUrl}api-auth/store/mOnboard/register';
  static String verifyOtp = '${baseUrl}api-auth/verify/otp';
  static String sendOtp = '${baseUrl}api-auth/send/otp';
  static String uploadImageURL = '${baseUrl}api-auth/image';

  static String deliverySlots = '${baseUrl}api-master/delivarySlots';
  static String getCategory = '${baseUrl}api-product/categorys';

  /// Todo : Order
  static String connectAPIPost = '${baseUrl}api-auth/store/b2b/linkSupplier';
  static String bannerTopApi = '${baseUrl}api-banner/banners/mobile/row';
  static String newOrders = '${baseUrl}api-oms/order/store/';
  static String productStoreAvq = '${baseUrl}api-product/product/store/avq';

  static String acceptDeclineApi = '${baseUrl}api-oms/order/accept/';
  static String getDeliveryBoyList = '${baseUrl}api-auth//emp/store/riders/';
  static String addCashRewards = '${baseUrl}api-oms/order/addcashRewards';
  static String assignDelivery = '${baseUrl}api-oms//order/store/assignRider/';
  static String getRiders = '${baseUrl}api-auth/emp/store/riders/';
  static String cashRewardPoints =
      '${baseUrl}api-wallet/wallet/add/cashRewardPoints';
  static String cashRewardAmount = "${baseUrl}api-wallet/wallet/add/amount";
  static String missedCallApi = '${baseUrl}api-auth/mobile/callNotificatoin';
  static String getCallApi =
      '${baseUrl}api-auth/mobile/receiver/callNotificatoin/';
  static String sendNotification = 'https://fcm.googleapis.com/fcm/send';

  /// Todo : inventory
  static String inventoryList = '${baseUrl}api-product/product/store/';
  static String getItemsbySubCategory = '${baseUrl}api-product/product/store/';
  static String todaysList = '${baseUrl}api-ofm/ofm/todaysDeal/';
  static String productStore = '${baseUrl}api-product/invoice/store/';
  static String updateProduct = '${baseUrl}api-product/inventory/update';
  static String priceUpdate = '${baseUrl}api-product/product/priceUpdate';
  static String addInventory = '${baseUrl}api-product/inventory/add';
  static String activeInventory = '${baseUrl}api-product/product/active/';
  static String getInventoryStatus =
      '${baseUrl}api-product/product/getProductStatsInfoByStoreId/store/';
  static String getProductCategory =
      '${baseUrl}api-product/subcategory/mobile/b2b/categoryById/';
  static String activeTodaysInventory =
      '${baseUrl}api-ofm/ofm/todayDeal/enable/';

  /// Todo : get customer
  static String customerList = '${baseUrl}api-auth//store/';
  static String userOrders = '${baseUrl}api-oms/order/store/';
  static String orderDetail = '${baseUrl}api-oms/user/';
  static String dashboard = '${baseUrl}api-oms/dashboard/myStore/';
  static String callNotificatoin =
      '${baseUrl}api-auth/mobile/receiver/callNotificatoin/';

  /// Todo : Profile
  static String profile = '${baseUrl}api-auth/store/profile';
  static String checkNumber = '${baseUrl}api-auth/verify/phone';
  static String editProfile = '${baseUrl}api-auth/store/profile';

  /// Todo : get Notification List
  static String getNotification = '${baseUrl}api-banner/alert/store/';

  static String getOrderDEtails = "${baseUrl}api-oms/order";
  static String verifyPresc = "${baseUrl}api-oms/order/item/medical/presc";
}

///todays deal
//http://localhost:8088/api-ofm/ofm/todaysDeal/AL-R202305-533?page=0&size=10
