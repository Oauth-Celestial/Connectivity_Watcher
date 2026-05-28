import 'package:connectivity_watcher/core/interceptors/curl_interceptor.dart';
import 'package:connectivity_watcher/core/manager/zo_network_log_manager.dart';
import 'package:connectivity_watcher/core/models/network_log_model.dart';
import 'package:dio/dio.dart';

class NetworkLoggerInterceptor extends Interceptor {
  final Map<String, DateTime> _startTimes = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    // Attach the id to the request extra map so we can retrieve it in response/error
    options.extra['network_log_id'] = id;
    _startTimes[id] = DateTime.now();

    final log = NetworkLogModel(
      id: id,
      url: options.uri.toString(),
      method: options.method,
      requestHeaders: options.headers,
      requestBody: options.data,
      startTime: _startTimes[id]!,
      requestOptions: options,
      curlCommand: options.toCURL(),
    );

    ZoNetworkLogManager.instance.addLog(log);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _handleCompletion(response.requestOptions, response: response);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _handleCompletion(err.requestOptions, err: err);
    super.onError(err, handler);
  }

  void _handleCompletion(RequestOptions options, {Response? response, DioException? err}) {
    final id = options.extra['network_log_id'] as String?;
    if (id == null) return;

    final startTime = _startTimes.remove(id);
    final duration = startTime != null ? DateTime.now().difference(startTime) : null;

    final logs = ZoNetworkLogManager.instance.logs;
    final logIndex = logs.indexWhere((l) => l.id == id);
    if (logIndex == -1) return;

    final log = logs[logIndex];
    log.duration = duration;

    if (response != null) {
      log.status = NetworkLogStatus.success;
      log.statusCode = response.statusCode;
      log.responseBody = response.data;
      log.responseHeaders = response.headers.map;
    } else if (err != null) {
      log.status = NetworkLogStatus.error;
      log.statusCode = err.response?.statusCode;
      log.responseBody = err.response?.data;
      log.responseHeaders = err.response?.headers.map;
      log.errorMessage = err.message;
    }

    ZoNetworkLogManager.instance.updateLog(log);
  }
}
