abstract class APiResponseFlow {
  void onSuccess<T>(
    T? data,
    String apiType,
    Map<String, dynamic> info,
  );
  void onFailure(
    String message,
    String apiType,
    Map<String, dynamic> info,
  );
  void onTokenExpired(
    String apiType,
    String endPoint,
    Map<String, dynamic> info,
  );
}
