import 'package:dio/dio.dart';

enum NetworkLogStatus { pending, success, error }

class NetworkLogModel {
  final String id;
  final String url;
  final String method;
  final Map<String, dynamic> requestHeaders;
  final dynamic requestBody;
  final DateTime startTime;

  NetworkLogStatus status;
  int? statusCode;
  dynamic responseBody;
  Map<String, dynamic>? responseHeaders;
  Duration? duration;
  String? curlCommand;
  String? errorMessage;
  RequestOptions requestOptions;

  NetworkLogModel({
    required this.id,
    required this.url,
    required this.method,
    required this.requestHeaders,
    this.requestBody,
    required this.startTime,
    required this.requestOptions,
    this.status = NetworkLogStatus.pending,
    this.curlCommand,
  });
}
