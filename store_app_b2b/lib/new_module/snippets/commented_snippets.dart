//api flow without pagination starts here

/// ------ api ---- //
//  Future<void> getNewlyLaunchedProducts({String endpoint = ""}) async {
//     try {
//       isNewlyLaunchedProductsLoading.value = true;
//       await RestServices.instance.getRestCall<ProductListModel>(
//         fromJson: (json) {
//           return productListModelFromJson(json);
//         },
//         endpoint: endpoint.isNotEmpty
//             ? endpoint
//             : Payloads().getNewlyLaunchedProducts(),
//         flow: this,
//         apiType: ApiTypes.getNewlyLaunchedProducts,
//       );
//     } catch (e) {
//       isNewlyLaunchedProductsLoading.value = false;
//       toastification.dismissAll();
//       customFailureToast(content: e.toString());
//     }
//     update();
//   }

/// ---- on failure case ---- //
// @override
// void onFailure(String message, String apiType) {
//   if (apiType == ApiTypes.getNewlyLaunchedProducts) {
//     toastification.dismissAll();
//     customFailureToast(content: message);
//     isNewlyLaunchedProductsLoading.value = false;
//   }
// }

/// ---- on success case ---- ///
// @override
// void onSuccess<T>(T? data, String apiType) {
//   //newly launcehd products
//   if (apiType == ApiTypes.getNewlyLaunchedProducts) {
//     ProductListModel modelData = data as ProductListModel;

//     if (modelData.data != null &&
//         modelData.data!.content != null &&
//         modelData.data!.content!.isNotEmpty) {
//       newlyLaunchedProducts.value = modelData.data!.content!;

//       logs(
//           "printing newly launched products length -> ${newlyLaunchedProducts.length}");
//     }

//     isNewlyLaunchedProductsLoading.value = false;
//   }
// }

/// ---- onToken Case ---- ///
// @override
// void onTokenExpired(String apiType, String endPoint) {
//   if (apiType == ApiTypes.getNewlyLaunchedProducts) {
//     getNewlyLaunchedProducts(endpoint: endPoint);
//   }
// }

//api flow without pagination ends here
