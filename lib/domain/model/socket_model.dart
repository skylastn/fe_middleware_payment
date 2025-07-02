import 'package:socket_io_client/socket_io_client.dart';

class SocketModel {
  Socket? socket;
  dynamic Function()? onConnect;
  dynamic Function()? onDisconnected;
  dynamic Function()? onReconnecting;
  dynamic Function()? onError;

  SocketModel({
    this.socket,
    this.onConnect,
    this.onDisconnected,
    this.onReconnecting,
    this.onError,
  });

  void dispose() {
    onConnect?.call();
    onDisconnected?.call();
    onReconnecting?.call();
    onError?.call();
    socket = null;
    onConnect = null;
    onDisconnected = null;
    onReconnecting = null;
    onError = null;
  }
}
