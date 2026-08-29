// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../feature/payment/domain/model/response/orders.dart';
import '../../feature/payment/domain/model/socket_model.dart';
import '../../feature/payment/domain/repository/socket_repository.dart';
import '../utility/snackbar.dart';
import 'network_logic.dart';

class SocketLogic extends GetxController {
  final SocketRepository _services = Get.find<SocketRepository>();
  final networkLogic = Get.find<NetworkLogic>();
  SocketModel socketModel = SocketModel();
  GetStream<Orders?> orderStream = GetStream();
  GetStream<void> reconnectStream = GetStream();
  RxBool isConnected = false.obs;
  StreamSubscription<bool>? isConnectedSubscription;
  bool _hasConnectedOnce = false;

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
    reconnectStream.close();
    isConnectedSubscription?.cancel();
    socketModel.dispose();
  }

  void listenConnectivity() {
    if (networkLogic.isConnected.value) {
      init();
    }
    isConnectedSubscription =
        networkLogic.connectSubscription.listen((isNetworkConnected) {
      if (isNetworkConnected) {
        if (socketModel.socket == null) {
          init();
        } else {
          connect();
        }
      } else {
        isConnected.value = false;
        socketModel.dispose();
      }
    });
  }

  Future<void> init() async {
    try {
      socketModel.dispose();
      final socket = await _services.init(
        project: 'payment',
        path: 'notification',
      );
      socketModel = SocketModel(socket: socket);

      _services.listenConnected(
        socket,
        onData: (_) => onConnect(),
      );
      _services.listenDisconnected(
        socket,
        onData: (data) => onDisconnect(data),
      );
      _services.listenError(
        socket,
        onData: (data) => onErrorSocket(data),
      );
      _services.listenConnectError(
        socket,
        onData: (data) => onConnectError(data),
      );
      _services.listenReconnect(
        socket,
        onData: (data) => onReconnect(data),
      );
      _services.listenReconnectAttempt(
        socket,
        onData: (data) {
          if (kDebugMode) log('Socket Reconnect Attempt: $data');
        },
      );
      _services.listenReconnectError(
        socket,
        onData: (data) {
          if (kDebugMode) log('Socket Reconnect Error: $data');
        },
      );

      await connect();
    } catch (e) {
      if (kDebugMode) log('Error Connecting Socket: $e');
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
    final wasDisconnected = !isConnected.value && _hasConnectedOnce;
    isConnected.value = true;
    subscribeNotification();
    if (wasDisconnected) {
      if (kDebugMode) log('Socket Reconnected successfully (via connect event)');
      reconnectStream.add(null);
    }
    _hasConnectedOnce = true;
  }

  void onDisconnect(dynamic data) {
    if (kDebugMode) log('Socket Disconnected : $data');
    isConnected.value = false;
  }

  void onConnectError(dynamic data) {
    if (kDebugMode) log('Socket Connect Error : $data');
    isConnected.value = false;
  }

  void onErrorSocket(dynamic data) {
    if (kDebugMode) log('Error Socket : $data');
    Snackbar.showInfo(message: 'Error Socket : $data');
  }

  void onReconnect(dynamic data) {
    if (kDebugMode) log('Socket Reconnected : $data');
    isConnected.value = true;
    subscribeNotification();
    reconnectStream.add(null);
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
    _services.unsubscribeNotification(socket: socketModel.socket!);
    _services.subscribeNotification(
      socket: socketModel.socket!,
      onData: (data) {
        if (data == null) {
          return;
        }
        if (kDebugMode) {
          log('Notification received [${data['type']}]: ${jsonEncode(data)}');
        }
        switch (data['type']) {
          case 'order':
            orderStream.add(Orders.fromJson(data['data']));
            break;
          default:
        }
      },
    );
  }
}
