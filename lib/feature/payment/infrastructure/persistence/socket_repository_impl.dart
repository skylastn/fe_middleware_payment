import 'package:socket_io_client/socket_io_client.dart';

import '../../domain/repository/socket_repository.dart';
import '../data_source/socket_remote_data_source.dart';

class SocketRepositoryImpl implements SocketRepository {
  final SocketRemoteDataSource remoteDataSource;

  SocketRepositoryImpl({SocketRemoteDataSource? remoteDataSource})
      : remoteDataSource = remoteDataSource ?? SocketRemoteDataSource();

  @override
  Future<Socket> init({
    required String project,
    required String path,
  }) async {
    return remoteDataSource.init(project: project, path: path);
  }

  @override
  Socket connect(Socket socket) {
    return socket.connect();
  }

  @override
  Socket disconnect(Socket socket) {
    return socket.disconnect();
  }

  @override
  void listenConnected(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  }) {
    socket.onConnect(onData);
  }

  @override
  void listenDisconnected(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  }) {
    socket.onDisconnect(onData);
  }

  @override
  void listenReconnect(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  }) {
    socket.onReconnect(onData);
  }

  @override
  void listenReconnectAttempt(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  }) {
    socket.onReconnectAttempt(onData);
  }

  @override
  void listenReconnectError(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  }) {
    socket.onReconnectError(onData);
  }

  @override
  void listenConnectError(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  }) {
    socket.onConnectError(onData);
  }

  @override
  void listenError(
    Socket socket, {
    required dynamic Function(dynamic) onData,
  }) {
    socket.onError(onData);
  }

  @override
  void sendEvent(
    Socket socket, {
    required String event,
    Map<String, dynamic>? body,
  }) {
    socket.emit(event, body);
  }

  @override
  void subscribeEvent(
    Socket socket, {
    required String event,
    required dynamic Function(dynamic) onData,
  }) {
    socket.on(event, onData);
  }

  @override
  void unsubscribeEvent(Socket socket, {required String event}) {
    socket.off(event);
  }

  @override
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

  @override
  void unsubscribeNotification({required Socket socket}) {
    unsubscribeEvent(socket, event: 'notification');
  }
}
