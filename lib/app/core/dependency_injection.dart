import 'dart:developer';
import 'package:flutter/foundation.dart';
import '../global/network_logic.dart';
import 'package:get/get.dart';

import '../../infrastructure/repository/socket_repository.dart';
import '../global/socket_logic.dart';

class DenpendencyInjection {
  static Future<void> start() async {
    try {
      Get.put(NetworkLogic(), permanent: true);
      Get.lazyPut(() => SocketRepository());
      Get.put(SocketLogic());
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
