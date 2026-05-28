import 'dart:io';
import 'package:connectivity_watcher/core/manager/zo_retry_manager.dart';
import 'package:dio/dio.dart';

class ConnectivityRetryInterceptor extends Interceptor {
  final Dio dio;

  ConnectivityRetryInterceptor({required this.dio});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_shouldRetry(err)) {
      ZoRetryManager.instance.enqueue(() async {
        try {
          final response = await dio.fetch(err.requestOptions);
          handler.resolve(response);
        } on DioException catch (e) {
          if (_shouldRetry(e)) {
            // Rethrow so the retry manager attempts again
            throw e;
          } else {
            handler.next(e);
          }
        } catch (e) {
          handler.next(
            DioException(
              requestOptions: err.requestOptions,
              error: e,
            ),
          );
        }
      });
    } else {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.error is SocketException;
  }
}
