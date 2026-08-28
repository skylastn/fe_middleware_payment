// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../domain/model/response_model.dart';
import '../../shared/constants/network_status.dart';
import '../../shared/utils/env.dart';
import 'http_config.dart';

enum HttpMethod { get, post, put, patch, delete }

class RemoteSource {
  late final dio.Dio _dio;
  final String url = '${Env.apiUrl}/api/';
  final int timeoutSeconds = 120;

  RemoteSource() {
    _dio = dio.Dio(
      dio.BaseOptions(
        baseUrl: url,
        connectTimeout: Duration(seconds: timeoutSeconds),
        receiveTimeout: Duration(seconds: timeoutSeconds),
        sendTimeout: kIsWeb ? null : Duration(seconds: timeoutSeconds),
        responseType: dio.ResponseType.plain,
        validateStatus: (_) => true,
      ),
    );

    if (!kIsWeb) {
      _dio.httpClientAdapter = TrustAllCertificates.getInstance.dioAdapter();
    }

    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers.putIfAbsent('Accept', () => 'application/json');
          if (options.data is! dio.FormData) {
            options.headers.putIfAbsent(
              'Content-Type',
              () => 'application/json',
            );
          }

          final token = Get.parameters['token'];
          if (token != null && token.isNotEmpty) {
            options.headers.putIfAbsent('Token', () => token);
          }

          if (kDebugMode) {
            log('[${options.method}] ${options.uri}');
            if (options.data != null) log('Body: ${_formatBody(options.data)}');
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            final request = response.requestOptions;
            log(
              'Response (${response.statusCode})\n'
              'URL: ${request.uri}\n'
              'Params: ${_formatBody(request.queryParameters)}\n'
              'Body: ${_formatBody(request.data)}\n'
              'Result: ${response.data}',
            );
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            log('Request failed: ${error.message}');
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<ResponseModel> request(
    HttpMethod method,
    String endpoint, {
    Map<String, dynamic>? query,
    Object? body,
    Map<String, String>? headers,
  }) async {
    try {
      final dioResponse = await _dio.request<dynamic>(
        endpoint,
        queryParameters: query,
        data: body,
        options: dio.Options(
          method: method.name.toUpperCase(),
          headers: headers,
          responseType: dio.ResponseType.plain,
          sendTimeout: _sendTimeoutForBody(body),
        ),
      );
      final response = _toHttpResponse(dioResponse);

      if (NetworkStatus.isStatusOkay(response.statusCode)) {
        return ResponseModel(
          isError: false,
          result: response,
          msg: 'Success',
        );
      }

      if (NetworkStatus.isUnauthorized(response.statusCode)) {
        return ResponseModel(
          isError: true,
          result: response,
          msg: 'Unauthorized',
        );
      }

      final decoded = _decodeBody(response.body);
      final msg = decoded['error_message'] ??
          (decoded['message'] is List
              ? decoded['message'][0]
              : decoded['message']) ??
          'Server Error';
      return ResponseModel(isError: true, result: response, msg: msg);
    } on TimeoutException {
      throw 'Connection Timeout, please check your connection';
    } on dio.DioException catch (e) {
      if (_isTimeout(e)) {
        throw 'Connection Timeout, please check your connection';
      }
      final response =
          e.response == null ? null : _toHttpResponse(e.response!);
      return ResponseModel(
        isError: true,
        result: response,
        msg: e.message ?? e.toString(),
      );
    } catch (e) {
      if (kDebugMode) {
        log('Request failed: $e');
      }
      return ResponseModel(isError: true, result: null, msg: e.toString());
    }
  }

  // 🔹 Shortcut methods for existing repositories
  Future<ResponseModel> getApi(
    String urlPrefix, {
    bool header = true,
    Map<String, dynamic>? query,
  }) =>
      request(
        HttpMethod.get,
        urlPrefix,
        query: query,
        headers: header ? headerMiddleware() : headerNormal(),
      );

  Future<ResponseModel> postApi(
    String urlPrefix, {
    Object? body,
    bool header = true,
  }) =>
      request(
        HttpMethod.post,
        urlPrefix,
        body: body,
        headers: header ? headerMiddleware() : headerNormal(),
      );

  Future<ResponseModel> patchApi(
    String urlPrefix, {
    Object? body,
    bool header = true,
  }) =>
      request(
        HttpMethod.patch,
        urlPrefix,
        body: body,
        headers: header ? headerMiddleware() : headerNormal(),
      );

  Future<ResponseModel> deleteApi(
    String urlPrefix,
    Map<String, dynamic> body, {
    bool header = true,
  }) =>
      request(
        HttpMethod.delete,
        urlPrefix,
        body: body,
        headers: header ? headerMiddleware() : headerNormal(),
      );

  http.Response _toHttpResponse(dio.Response<dynamic> response) {
    final headers = response.headers.map.map(
      (key, value) => MapEntry(key, value.join(',')),
    );
    final body = _formatBody(response.data);
    final uri = response.realUri;
    final request = http.Request(response.requestOptions.method, uri);

    return http.Response(
      body,
      response.statusCode ?? 0,
      headers: headers,
      request: request,
      reasonPhrase: response.statusMessage,
    );
  }

  Map<String, dynamic> _decodeBody(String body) {
    if (body.isEmpty) return {};
    try {
      final decoded = jsonDecode(body);
      return decoded is Map<String, dynamic> ? decoded : {};
    } catch (_) {
      return {};
    }
  }

  String _formatBody(dynamic data) {
    if (data == null) return '';
    if (data is String) return data;
    if (data is dio.FormData) {
      return jsonEncode({
        'fields': Map.fromEntries(data.fields),
        'files': data.files.map((file) => file.key).toList(),
      });
    }
    return jsonEncode(data);
  }

  bool _isTimeout(dio.DioException e) {
    return e.type == dio.DioExceptionType.connectionTimeout ||
        e.type == dio.DioExceptionType.receiveTimeout ||
        e.type == dio.DioExceptionType.sendTimeout;
  }

  Duration? _sendTimeoutForBody(Object? body) {
    if (kIsWeb && body == null) return null;
    return Duration(seconds: timeoutSeconds);
  }

  Map<String, String> headerMiddleware() {
    return {
      'Token': Get.parameters['token'] ?? '',
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
}
