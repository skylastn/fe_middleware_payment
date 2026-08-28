import 'package:socket_io_client/socket_io_client.dart';

class SocketModel {
  Socket? socket;

  SocketModel({this.socket});

  void dispose() {
    try {
      socket?.clearListeners();
      socket?.disconnect();
      socket?.dispose();
    } catch (_) {}
    socket = null;
  }
}
