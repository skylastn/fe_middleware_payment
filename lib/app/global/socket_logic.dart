// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

// import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import '../../domain/model/response/orders.dart';
import '../../domain/model/socket_model.dart';
import '../../infrastructure/repository/socket_repository.dart';
import '../../shared/utils/snackbar.dart';
import 'network_logic.dart';

class SocketLogic extends GetxController {
  final _services = SocketRepository();
  final networkLogic = Get.find<NetworkLogic>();
  SocketModel socketModel = SocketModel();
  GetStream<Orders?> orderStream = GetStream();
  RxBool isConnected = false.obs;
  void Function()? notificationSubscribition;
  StreamSubscription<bool>? isConnectedSubscription;

  @override
  void onClose() {
    disposeCall();
    super.onClose();
  }

  @override
  void onInit() {
    listenConnectivity();
    super.onInit();
  }

  void disposeCall() {
    disconnect();
    orderStream.close();
    isConnectedSubscription?.cancel();
    notificationSubscribition?.call();
    socketModel.dispose();
  }

  void listenConnectivity() {
    if (networkLogic.isConnected.value) {
      init();
    }
    isConnectedSubscription =
        networkLogic.connectSubscription.listen((isConnected) {
      if (isConnected) {
        init();
      } else {
        socketModel.dispose();
      }
    });
  }

  Future<void> init() async {
    try {
      print('Connecting Socket .... ');
      socketModel = SocketModel(
        socket: await _services.init(
          project: 'payment',
          path: 'notification',
        ),
      );
      socketModel.onConnect = _services.listenConnected(
        socketModel.socket!,
        onData: (_) => onConnect(),
      );
      socketModel.onDisconnected = _services.listenDisconnected(
        socketModel.socket!,
        onData: (_) => onDisconnect(),
      );
      socketModel.onError = _services.listenError(
        socketModel.socket!,
        onData: (data) => onErrorSocket(data),
      );
      socketModel.onReconnecting = _services.listenReconnecting(
        socketModel.socket!,
        onData: (data) => onReconnect(data),
      );
      await connect();
    } catch (e) {
      log('error Connecting Socket');
    }
  }

  Future<void> connect() async {
    if (socketModel.socket == null) {
      return;
    }
    if (socketModel.socket!.connected == true) {
      return;
    }
    socketModel.socket = _services.connect(socketModel.socket!);
  }

  void disconnect() {
    if (socketModel.socket == null) {
      return;
    }
    if (socketModel.socket!.connected == false) {
      return;
    }
    socketModel.socket = _services.disconnect(socketModel.socket!);
  }

  void onConnect() {
    print('Socket Connected');
    isConnected.value = true;
    isConnected.subject.add(true);
    subscribeNotification();
  }

  void onDisconnect() {
    print('Socket Disconnected');
    isConnected.value = false;
    isConnected.subject.add(false);
    notificationSubscribition?.call();
  }

  void onErrorSocket(dynamic data) {
    print('error Socket : $data');
    Snackbar.showInfo(message: 'Error Socket : $data');
  }

  void onReconnect(dynamic data) {
    print('reconnect Socket : $data');
  }

  void sendEvent({required String event, Map<String, dynamic>? data}) {
    if (socketModel.socket == null) {
      return;
    }
    _services.sendEvent(socketModel.socket!, event: event, body: data);
  }

  void subscribeNotification() {
    if (socketModel.socket == null) {
      return;
    }
    notificationSubscribition?.call();
    notificationSubscribition = _services.subscribeNotification(
      socket: socketModel.socket!,
      onData: (data) {
        // try {
        if (data == null) {
          return;
        }
        Get.log(
            'data notification ${data['type']} (${data.runtimeType}) : ${jsonEncode(data)}');
        switch (data['type']) {
          case 'order':
            orderStream.add(Orders.fromJson(data['data']));
            break;
          default:
        }
        // } catch (e) {
        //   Get.log('error receiving notification : $e');
        // }
      },
    );
  }
}
