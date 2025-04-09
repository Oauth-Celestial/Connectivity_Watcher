import 'dart:convert';

import 'package:dio/dio.dart';

class CurlInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final curlCommand = _generateCurlCommand(options);

    Map<String, dynamic> result = {
      "url": options.uri.toString(),
      "method": options.method,
      "curlCommand": curlCommand,
      "headers": options.headers,
    };
    print("Curl Command   -- >$result");
    super.onRequest(options, handler);
  }

  String _generateCurlCommand(RequestOptions options) {
    final buffer = StringBuffer();

    // Start cURL command
    buffer.write('curl');

    // Add method (e.g., GET, POST)
    buffer.write(' -X ${options.method}');

    // Add headers
    options.headers.forEach((key, value) {
      buffer.write(' -H "${key}: $value"');
    });

    // Add body data (if present)
    if (options.data != null) {
      if (options.data is Map) {
        final jsonData = jsonEncode(options.data);
        buffer.write(' --data-raw \'$jsonData\'');
      } else if (options.data is String) {
        buffer.write(' --data-raw \'${options.data}\'');
      }
    }

    // Add URL (including query parameters)
    buffer.write(' "${options.uri.toString()}"');

    return buffer.toString();
  }
}
