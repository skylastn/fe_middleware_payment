import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketRepository {
  final String urlSocket = dotenv.env['SOCKET_URL'] ?? '';

  Future<Socket> init({
    required String project,
    required String path,
  }) async {
    return io(
      urlSocket,
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect() // disable auto-connection
          .enableReconnection()
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

  dynamic Function() listenConnected(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  }) {
    return socket.onConnect(onData);
  }

  dynamic Function() listenDisconnected(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  }) {
    return socket.onDisconnect(onData);
  }

  dynamic Function() listenReconnecting(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  }) {
    return socket.onReconnect(onData);
  }

  dynamic Function() listenError(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  }) {
    return socket.onError(onData);
  }

  void sendEvent(
    Socket socket, {
    required String event,
    Map<String, dynamic>? body,
  }) {
    return socket.emit(
      event,
      body,
    );
  }

  dynamic Function() subscribeEvent(
    Socket socket, {
    required String event,
    required dynamic Function(dynamic) onData,
  }) {
    return socket.on(event, onData);
  }

  dynamic Function() subscribeNotification({
    required Socket socket,
    required dynamic Function(dynamic) onData,
  }) {
    return subscribeEvent(
      socket,
      event: 'notification',
      onData: onData,
    );
  }
}
