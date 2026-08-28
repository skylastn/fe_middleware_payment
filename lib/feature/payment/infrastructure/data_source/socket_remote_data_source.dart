import 'package:socket_io_client/socket_io_client.dart';
import '../../../../shared/utility/env.dart';

class SocketRemoteDataSource {
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
}
