import 'package:socket_io_client/socket_io_client.dart';

abstract class SocketRepository {
  Future<Socket> init({
    required String project,
    required String path,
  });

  Socket connect(Socket socket);
  Socket disconnect(Socket socket);

  void listenConnected(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  });

  void listenDisconnected(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  });

  void listenReconnect(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  });

  void listenReconnectAttempt(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  });

  void listenReconnectError(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  });

  void listenConnectError(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  });

  void listenError(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  });

  void sendEvent(
    Socket socket, {
    required String event,
    Map<String, dynamic>? body,
  });

  void subscribeEvent(
    Socket socket, {
    required String event,
    required dynamic Function(dynamic) onData,
  });

  void unsubscribeEvent(Socket socket, {required String event});

  void subscribeNotification({
    required Socket socket,
    required dynamic Function(dynamic) onData,
  });

  void unsubscribeNotification({required Socket socket});
}
