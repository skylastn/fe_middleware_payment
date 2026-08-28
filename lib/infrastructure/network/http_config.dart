// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:dio/io.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class TrustAllCertificates {
  TrustAllCertificates._privateConstructor();

  static final TrustAllCertificates _instance =
      TrustAllCertificates._privateConstructor();

  static TrustAllCertificates get getInstance => _instance;

  HttpClient createHttpClient() {
    bool trustSelfSigned = true;
    return HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => trustSelfSigned;
  }

  http.Client sslClient() {
    var ioClient = createHttpClient();
    http.Client client = IOClient(ioClient);
    return client;
  }

  IOHttpClientAdapter dioAdapter() {
    return IOHttpClientAdapter(createHttpClient: () => createHttpClient());
  }
}
