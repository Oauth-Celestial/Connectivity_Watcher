import 'package:dio/dio.dart';

class InternetChecker {
  static final _dio = Dio();

  /// Checks real internet and measures ping using Dio.
  static Future<InternetStatus> check({
    Duration timeout = const Duration(seconds: 3),
    String url = 'https://www.google.com',
  }) async {
    try {
      final stopwatch = Stopwatch()..start();
      final response = await _dio.get(url,
          options: Options(sendTimeout: timeout, receiveTimeout: timeout));
      stopwatch.stop();

      final ping = stopwatch.elapsedMilliseconds;
      final online = response.statusCode == 200;

      return InternetStatus(isOnline: online, pingMs: ping);
    } catch (_) {
      return InternetStatus(isOnline: false);
    }
  }
}

class InternetStatus {
  final bool isOnline;
  final int? pingMs;

  InternetStatus({required this.isOnline, this.pingMs});

  @override
  String toString() =>
      isOnline ? '✅ Online — Ping: ${pingMs}ms' : '⚠️ Offline or Unreachable';
}
