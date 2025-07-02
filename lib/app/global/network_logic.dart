import 'dart:async';

import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkLogic extends GetxService {
  RxBool isConnected = false.obs;
  GetStream<bool> connectSubscription = GetStream();
  StreamSubscription<List<ConnectivityResult>>? internetSubscription;

  @override
  void onClose() {
    internetSubscription?.cancel();
    super.onClose();
  }

  Future<void> init() async {
    var result = await Connectivity().checkConnectivity();
    if (result.isEmpty || result.contains(ConnectivityResult.none)) {
      handleConnection(false);
    } else {
      handleConnection(true);
    }
    internetSubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.isEmpty || result.contains(ConnectivityResult.none)) {
        handleConnection(false);
      } else {
        handleConnection(true);
      }
    });
  }

  void handleConnection(bool isConnect) {
    isConnected.value = isConnect;
    connectSubscription.add(isConnect);
  }
}
