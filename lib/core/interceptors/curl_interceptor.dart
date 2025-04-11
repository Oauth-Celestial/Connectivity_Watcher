import 'dart:convert';
import 'package:dio/dio.dart';

class CurlInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final curlCommand = _generateCurlCommand(options);

    print('\n' + '=' * 80);
    print('🔗 CURL COMMAND');
    print('-' * 80);
    print(curlCommand);
    print('=' * 80 + '\n');

    super.onRequest(options, handler);
  }

  String _generateCurlCommand(RequestOptions options) {
    final buffer = StringBuffer();

    buffer.write('curl');

    // Add HTTP method if not GET
    if (options.method.toUpperCase() != 'GET') {
      buffer.write(' -X ${options.method.toUpperCase()}');
    }

    // Add headers
    options.headers.forEach((key, value) {
      buffer.write(' -H "${key}: $value"');
    });

    // Add body
    if (options.data != null) {
      String body = '';
      if (options.data is Map) {
        body = jsonEncode(options.data);
      } else if (options.data is String) {
        body = options.data;
      }
      body = body.replaceAll("'", r"'\''"); // Escape single quotes
      buffer.write(" --data-raw '${body}'");
    }

    // Add URL
    buffer.write(' "${options.uri}"');

    return buffer.toString();
  }
}
