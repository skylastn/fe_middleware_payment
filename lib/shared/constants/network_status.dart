class NetworkStatus {
  static bool isStatusOkay(int? statusCode) {
    if (statusCode == null) return false;
    return statusCode >= 200 && statusCode < 300;
  }

  static bool isUnauthorized(int? statusCode) {
    return statusCode == 401 || statusCode == 403;
  }
}
