import 'dart:async';

import 'package:connectivity_watcher/controller/zo_connectivity_controller.dart';
import 'package:connectivity_watcher/core/manager/socket_internet_checker.dart';
import 'package:connectivity_watcher/core/manager/zo_retry_manager.dart';
import 'package:connectivity_watcher/core/interceptors/connectivity_retry_interceptor.dart';
import 'package:connectivity_watcher/core/interceptors/network_logger_interceptor.dart';
import 'package:connectivity_watcher/core/manager/zo_network_log_manager.dart';
import 'package:connectivity_watcher/core/models/network_log_model.dart';
import 'package:connectivity_watcher/core/service/zo_ping_service.dart';
import 'package:connectivity_watcher/screens/network_logs_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

part '../../controller/enum_connection.dart';

class ZoConnectivityWatcher {
  ZoConnectivityWatcher._();

  static final ZoConnectivityWatcher _instance = ZoConnectivityWatcher._();

  factory ZoConnectivityWatcher() {
    return _instance;
  }

  GlobalKey<NavigatorState>? _navigationKey;

  BuildContext get currentContext => _navigationKey!.currentContext!;

  StreamController<ConnectivityWatcherStatus> _connectivityController =
      StreamController<ConnectivityWatcherStatus>.broadcast();

  Stream<ConnectivityWatcherStatus> get stream =>
      _connectivityController.stream;

  void setNavigatorKey(GlobalKey<NavigatorState> key) {
    _navigationKey = key;
  }

  void setUp({StealthInternetChecker? internetChecker}) {
    ZoConnectivityController().setUp(internetChecker: internetChecker);
  }

  /// Set up a Dio client to automatically track and retry failed network requests
  /// when the internet connection is restored.
  void setupDio(Dio dio) {
    dio.interceptors.add(ConnectivityRetryInterceptor(dio: dio));
  }

  /// Set up a Dio client to automatically log network requests for the Network Inspector.
  void setupDioLogger(Dio dio) {
    dio.interceptors.add(NetworkLoggerInterceptor());
  }

  /// Get all the stored network logs.
  List<NetworkLogModel> getNetworkLogs() {
    return ZoNetworkLogManager.instance.logs;
  }

  /// Open the Network Logs Inspector screen.
  void showNetworkLogsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ZoNetworkLogsScreen()),
    );
  }

  /// Initializes the real-time ping monitoring system.
  /// If parameters are null, defaults to pinging Google DNS (8.8.8.8) every 2 seconds.
  void initPingService({
    String? targetIp,
    int? targetPort,
    Duration? interval,
    Duration? timeout,
  }) {
    ZoPingService.instance.init(
      targetIp: targetIp,
      targetPort: targetPort,
      interval: interval,
      timeout: timeout,
    );
  }

  void updateStream(ConnectivityWatcherStatus status) {
    _connectivityController.sink.add(status);
  }

  bool isInternetAvailable = false;

  bool isNoInternetWidgetVisible = false;

  /// Use this method to forcefully hide the no internet widget
  /// The function `hideNoInternet` returns a Future bool  that hides the no internet screen by
  /// accessing the controller from an inherited widget.
  ///
  /// Returns:
  ///   The function `hideNoInternet()` returns a `Future bool` which will eventually resolve to a
  /// boolean value. The value returned will be the result of calling the `hideNoInternetScreen()`
  /// method on the controller obtained from the `ZoConnectivityInheritedWidget` found in the current
  /// context.
  Future<bool> hideNoInternet() async {
    return ZoConnectivityController().hideNoInternetScreen();
  }

  /// The function `makeApiCall` checks for internet connection status and calls the provided API function
  /// with the status.
  ///
  /// Args:
  ///   apiCall (Function(bool internetStatus)): The `apiCall` parameter is a function that takes a
  /// boolean parameter `internetStatus` as input. This function is used to make an API call and pass the
  /// internet connection status to it.
  makeApiCall({required Function(bool internetStatus) apiCall}) async {
    bool status = await ZoConnectivityController().getConnectivityStatus();
    apiCall(status);
  }

  /// The function `makeApiCallWithRetry` retries an API call with a specified maximum number of retries
  /// and delay duration.
  ///
  /// Args:
  ///   apiCall (Future<void> Function()): The `apiCall` parameter is a required function that
  /// represents the API call you want to make. It is a function that returns a `Future<void>`.
  ///   maxRetries (int): The `maxRetries` parameter specifies the maximum number of times the API call
  /// should be retried in case of failure before giving up. In this case, the default value is set to
  /// 3, meaning the API call will be retried up to 3 times if it fails initially. Defaults to 3
  ///   delay (Duration): The `delay` parameter specifies the duration to wait before retrying the API
  /// call in case of a failure. In this case, the default delay is set to 2 seconds. Defaults to const
  /// Duration(seconds: 2)
  makeApiCallWithRetry(
      {required Future<void> Function() apiCall,
      int maxRetries = 3,
      Duration delay = const Duration(seconds: 2)}) async {
    ZoRetryManager.instance
        .retryWhenOnline(apiCall, maxRetries: maxRetries, delay: delay);
  }
}
