import 'dart:convert';
import 'package:dio/dio.dart';

class CurlInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final curlCommand = options.toCURL();

    print('\n' + '=' * 80);
    print('🔗 CURL COMMAND');
    print('-' * 80);
    print(curlCommand);
    print('=' * 80 + '\n');

    super.onRequest(options, handler);
  }
}

extension DioCurlExtension on RequestOptions {
  String toCURL() {
    List<String> cmd = ['curl'];

    cmd.add('-X ${method.toUpperCase()}');

    headers.forEach((key, value) {
      if (key != 'Cookie') {
        cmd.add("-H '$key: $value'");
      }
    });

    // 3. Add Body
    if (data != null) {
      if (data is FormData) {
        final formData = data as FormData;
        for (var field in formData.fields) {
          cmd.add("-F '${field.key}=${field.value}'");
        }
        for (var file in formData.files) {
          cmd.add("-F '${file.key}=@${file.value.filename}'");
        }
      } else if (data is Map || data is List) {
        try {
          final jsonBody = jsonEncode(data);

          final escapedBody = jsonBody.replaceAll("'", r"'\''");
          cmd.add("--data-raw '$escapedBody'");
        } catch (_) {
          cmd.add("--data-raw '${data.toString()}'");
        }
      } else {
        final String rawData = data.toString();
        final escapedBody = rawData.replaceAll("'", r"'\''");
        cmd.add("--data-raw '$escapedBody'");
      }
    }

    cmd.add("'$uri'");

    return cmd.join(' \\\n  ');
  }
}
