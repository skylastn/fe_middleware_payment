import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../domain/model/response_model.dart';
import '../shared/constants/network_status.dart';
import 'package:http/http.dart' as http;
import 'http_config.dart';

class RemoteSource {
  int timeOut = 120;
  final String url = dotenv.env['API_URL'] ?? 'http://localhost:3000';
  Future<ResponseModel> postApi(String urlPrefix,
      {Object? body, bool header = true}) async {
    var urlS = url + urlPrefix;
    if (kDebugMode) {
      Get.log('ambil data Post : $urlS');
      Get.log(body.toString());
    }
    try {
      http.Response? response;
      if (kIsWeb) {
        response = await http
            .post(
              Uri.parse(urlS),
              body: jsonEncode(body),
              headers: (header) ? headerMiddleware() : headerNormal(),
            )
            .timeout(Duration(seconds: timeOut));
      } else {
        response = await TrustAllCertificates.getInstance
            .sslClient()
            .post(
              Uri.parse(urlS),
              body: jsonEncode(body),
              headers: (header) ? headerMiddleware() : headerNormal(),
            )
            .timeout(Duration(seconds: timeOut));
      }
      if (kDebugMode) {
        Get.log('response : ${response.body}');
        Get.log('statuscode : ${response.statusCode}');
      }
      if (NetworkStatus.isStatusOkay(response.statusCode)) {
        return ResponseModel(
          isError: false,
          result: response,
          msg: 'Success Post Data',
        );
      }
      if (NetworkStatus.isUnauthorized(response.statusCode)) {
        return ResponseModel(
          isError: true,
          result: response,
          msg: 'Unauthorized',
        );
      }
      String msg = jsonDecode(response.body)['message'] ?? 'Server Error';
      return ResponseModel(
        isError: true,
        result: response,
        msg: msg,
      );
    } on TimeoutException {
      throw 'Connection Timeout, please check your connection';
    } catch (e) {
      if (kDebugMode) {
        Get.log('failed $urlPrefix : $e');
      }
      return ResponseModel(isError: true, result: null, msg: e.toString());
    }
  }

  // Future<ResponseModel> postApiWithFiles(String urlPrefix,
  //     {Object? body, bool header = true}) async {
  //   var urlS = url + urlPrefix;
  //   if (kDebugMode) {
  //     Get.log('ambil data Post : $urlS');
  //     Get.log(body.toString());
  //   }
  //   try {
  //     final Response response = await connect.post(
  //       urlS,
  //       body,
  //       headers: (header) ? await headerImage() : headerNormal(),
  //     );
  //     if (kDebugMode) {
  //       Get.log('response : ${response.bodyString}');
  //       Get.log('statuscode : ${response.statusCode}');
  //     }
  //     if (response.isOk) {
  //       return ResponseModel(
  //         isError: false,
  //         result: response,
  //         msg: 'Success Get Data',
  //       );
  //     }
  //     if (response.unauthorized) {
  //       return ResponseModel(
  //         isError: true,
  //         result: response,
  //         msg: 'Unauthorized',
  //       );
  //     }
  //     return ResponseModel(
  //       isError: true,
  //       result: response,
  //       msg: jsonDecode(response.bodyString ?? '''{}''')['message'] ??
  //           'Server Error',
  //     );
  //   } on TimeoutException {
  //     throw 'Connection Timeout, please check your connection';
  //   } catch (e) {
  //     if (kDebugMode) {
  //       Get.log('failed $urlPrefix : $e');
  //     }
  //     return ResponseModel(isError: true, result: null, msg: e.toString());
  //   }
  // }

  Future<ResponseModel> getApi(String urlPrefix,
      {bool header = true, Map<String, dynamic>? query}) async {
    var urlS = url + urlPrefix;
    if (kDebugMode) {
      Get.log('ambil data Get : $urlS');
    }
    if (query != null && query.isNotEmpty) {
      int tempCount = 0;
      query.forEach((key, value) {
        if (tempCount == 0) {
          urlS = '$urlS?$key=$value';
        } else {
          urlS = '$urlS&$key=$value';
        }
        tempCount++;
      });
    }
    try {
      Get.log('running here 1');
      final http.Response? response;
      if (kIsWeb) {
        Get.log('running here 2');
        response = await http
            .get(
              Uri.parse(urlS),
              // query: query,
              headers: (header) ? headerMiddleware() : headerNormal(),
            )
            .timeout(Duration(seconds: timeOut));
      } else {
        response = await TrustAllCertificates.getInstance
            .sslClient()
            .get(
              Uri.parse(urlS),
              // query: query,
              headers: (header) ? headerMiddleware() : headerNormal(),
            )
            .timeout(Duration(seconds: timeOut));
      }
      if (kDebugMode) {
        Get.log('response : ${response.body}');
        Get.log('statuscode : ${response.statusCode}');
      }
      if (NetworkStatus.isStatusOkay(response.statusCode)) {
        return ResponseModel(
          isError: false,
          result: response,
          msg: 'Success Get Data',
        );
      }
      if (NetworkStatus.isUnauthorized(response.statusCode)) {
        return ResponseModel(
          isError: true,
          result: response,
          msg: 'Unauthorized',
        );
      }
      String msg = jsonDecode(response.body)['message'] ?? 'Server Error';
      return ResponseModel(
        isError: true,
        result: response,
        msg: msg,
      );
    } on TimeoutException {
      throw 'Connection Timeout, please check your connection';
    } catch (e) {
      if (kDebugMode) {
        Get.log('failed $urlPrefix : $e');
      }
      return ResponseModel(isError: true, result: null, msg: e.toString());
    }
  }

  Future<ResponseModel> patchApi(String urlPrefix,
      {Object? body, bool header = true}) async {
    var urlS = url + urlPrefix;
    if (kDebugMode) {
      Get.log('ambil data Post : $urlS');
      Get.log(body.toString());
    }
    try {
      final http.Response? response;

      if (kIsWeb) {
        response = await http
            .patch(
              Uri.parse(urlS),
              body: jsonEncode(body),
              headers: (header) ? headerMiddleware() : headerNormal(),
            )
            .timeout(Duration(seconds: timeOut));
      } else {
        response = await TrustAllCertificates.getInstance
            .sslClient()
            .patch(
              Uri.parse(urlS),
              body: jsonEncode(body),
              headers: (header) ? headerMiddleware() : headerNormal(),
            )
            .timeout(Duration(seconds: timeOut));
      }
      if (kDebugMode) {
        Get.log('response : ${response.body}');
        Get.log('statuscode : ${response.statusCode}');
      }
      if (NetworkStatus.isStatusOkay(response.statusCode)) {
        return ResponseModel(
          isError: false,
          result: response,
          msg: 'Success Get Data',
        );
      }
      if (NetworkStatus.isUnauthorized(response.statusCode)) {
        return ResponseModel(
          isError: true,
          result: response,
          msg: 'Unauthorized',
        );
      }
      String msg = jsonDecode(response.body)['message'] ?? 'Server Error';
      return ResponseModel(
        isError: true,
        result: response,
        msg: msg,
      );
    } on TimeoutException {
      throw 'Connection Timeout, please check your connection';
    } catch (e) {
      if (kDebugMode) {
        Get.log('failed $urlPrefix : $e');
      }
      return ResponseModel(isError: true, result: null, msg: e.toString());
    }
  }

  Future<ResponseModel> deleteApi(
    String urlPrefix,
    Map<String, dynamic> body, {
    bool header = true,
  }) async {
    var urlS = url + urlPrefix;
    if (kDebugMode) {
      Get.log('ambil data Delete : $urlS');
      Get.log(body.toString());
    }
    try {
      final http.Response? response;

      if (kIsWeb) {
        response = await http
            .delete(
              Uri.parse(urlS),
              body: jsonEncode(body),
              headers: (header) ? headerMiddleware() : headerNormal(),
            )
            .timeout(Duration(seconds: timeOut));
      } else {
        response = await TrustAllCertificates.getInstance
            .sslClient()
            .delete(
              Uri.parse(urlS),
              body: jsonEncode(body),
              headers: (header) ? headerMiddleware() : headerNormal(),
            )
            .timeout(Duration(seconds: timeOut));
      }

      if (kDebugMode) {
        Get.log('response : ${response.body}');
        Get.log('statuscode : ${response.statusCode}');
      }
      if (NetworkStatus.isStatusOkay(response.statusCode)) {
        return ResponseModel(
          isError: false,
          result: response,
          msg: 'Success Get Data',
        );
      }
      if (NetworkStatus.isUnauthorized(response.statusCode)) {
        return ResponseModel(
          isError: true,
          result: response,
          msg: 'Unauthorized',
        );
      }
      String msg = jsonDecode(response.body)['message'] ?? 'Server Error';
      return ResponseModel(
        isError: true,
        result: response,
        msg: msg,
      );
    } on TimeoutException {
      throw 'Connection Timeout, please check your connection';
    } catch (e) {
      if (kDebugMode) {
        Get.log('failed $urlPrefix : $e');
      }
      return ResponseModel(isError: true, result: null, msg: e.toString());
    }
  }

  Map<String, String> headerMiddleware() {
    return {
      'Key': 'oxJMxunHKiElhLwZyPsb',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Map<String, String> headerNormal() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // headerFCM() {
  //   return {
  //     'Authorization': 'key=$apiKeyFcm',
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //   };
  // }

  // headerImage() {
  //   return {
  //     'Authorization': 'Bearer ${Session().getToken()}',
  //     // 'Content-Type': 'application/json',
  //     // 'Accept': 'application/json',
  //   };
  // }

  // Map<String, String>? headerCheck({int choice = 0}) {
  //   if (choice == 1) {
  //     return headerLogin();
  //   }
  //   if (choice == 2) {
  //     return headerFCM();
  //   }
  //   return null;
  // }
}
