import 'package:socket_io_client/socket_io_client.dart';

import '../../shared/utils/env.dart';

class SocketRepository {
  final String urlSocket = Env.socketUrl;

  Future<Socket> init({
    required String project,
    required String path,
  }) async {
    return io(
      urlSocket,
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(999999)
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          .setQuery({'project': project, 'path': path})
          .build(),
    );
  }

  Socket connect(Socket socket) {
    return socket.connect();
  }

  Socket disconnect(Socket socket) {
    return socket.disconnect();
  }

  void listenConnected(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  }) {
    socket.onConnect(onData);
  }

  void listenDisconnected(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  }) {
    socket.onDisconnect(onData);
  }

  void listenReconnect(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  }) {
    socket.onReconnect(onData);
  }

  void listenReconnectAttempt(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  }) {
    socket.onReconnectAttempt(onData);
  }

  void listenReconnectError(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  }) {
    socket.onReconnectError(onData);
  }

  void listenConnectError(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  }) {
    socket.onConnectError(onData);
  }

  void listenError(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  }) {
    socket.onError(onData);
  }

  void sendEvent(
    Socket socket, {
    required String event,
    Map<String, dynamic>? body,
  }) {
    socket.emit(
      event,
      body,
    );
  }

  void subscribeEvent(
    Socket socket, {
    required String event,
    required dynamic Function(dynamic) onData,
  }) {
    socket.on(event, onData);
  }

  void unsubscribeEvent(Socket socket, {required String event}) {
    socket.off(event);
  }

  void subscribeNotification({
    required Socket socket,
    required dynamic Function(dynamic) onData,
  }) {
    subscribeEvent(
      socket,
      event: 'notification',
      onData: onData,
    );
  }

  void unsubscribeNotification({required Socket socket}) {
    unsubscribeEvent(socket, event: 'notification');
  }
}
