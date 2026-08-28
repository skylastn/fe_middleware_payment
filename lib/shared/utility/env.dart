class Env {
  static String get apiUrl => const String.fromEnvironment('API_URL');
  static String get socketUrl => const String.fromEnvironment('SOCKET_URL');
}
