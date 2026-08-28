import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../feature/payment/domain/repository/order_repository.dart';
import '../../feature/payment/domain/repository/payment_repository.dart';
import '../../feature/payment/domain/repository/socket_repository.dart';
import '../../feature/payment/infrastructure/persistence/order_repository_impl.dart';
import '../../feature/payment/infrastructure/persistence/payment_repository_impl.dart';
import '../../feature/payment/infrastructure/persistence/socket_repository_impl.dart';
import '../logic/network_logic.dart';
import '../logic/socket_logic.dart';
import '../provider/api_provider.dart';

class DenpendencyInjection {
  static Future<void> start() async {
    try {
      // Core Providers
      Get.put<ApiProvider>(ApiProvider(), permanent: true);
      Get.put<NetworkLogic>(NetworkLogic(), permanent: true);

      // Repositories
      Get.lazyPut<OrderRepository>(() => OrderRepositoryImpl(), fenix: true);
      Get.lazyPut<PaymentRepository>(() => PaymentRepositoryImpl(), fenix: true);
      Get.lazyPut<SocketRepository>(() => SocketRepositoryImpl(), fenix: true);

      // Global Services
      Get.put<SocketLogic>(SocketLogic());
    } catch (e) {
      if (kDebugMode) {
        log('Error Init Dependency: $e');
      }
    }
  }

  static Future<void> inject() async {
    try {
      await Get.find<NetworkLogic>().init();
    } catch (e) {
      if (kDebugMode) {
        log('Error Inject Dependency: $e');
      }
    }
  }
}
