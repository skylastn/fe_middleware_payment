import '../global/network_logic.dart';
import 'package:get/get.dart';

import '../../infrastructure/repository/socket_repository.dart';
import '../global/socket_logic.dart';

class DenpendencyInjection {
  static Future<void> start() async {
    try {
      //Local DB
      // Get.put(LocalLogic(), permanent: true);

      // Provider
      Get.put(NetworkLogic(), permanent: true);
      // Get.lazyPut(() => ApiProvider());

      // Repository
      Get.lazyPut(() => SocketRepository());

      // Get.put(GlobalLogic(), permanent: true);
      Get.put(SocketLogic());
      // Get.put(QueueLogic());
    } catch (e) {
      Get.log('error Init Dependency $e');
    }
  }

  static Future<void> inject() async {
    try {
      // await Get.find<LocalLogic>().initLocalDatabase();
      await Get.find<NetworkLogic>().init();
      await Get.find<SocketLogic>().init();
      // await Get.find<GlobalLogic>().initFirstTime();
      // await Get.find<AuthLogic>().initAfterLogin();
    } catch (e) {
      Get.log('error Inject Dependency $e');
    }
  }
}
