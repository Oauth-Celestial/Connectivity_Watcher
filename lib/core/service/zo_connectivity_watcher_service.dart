import 'dart:async';

import 'package:connectivity_watcher/core/connectivity_inherited.dart';
import 'package:connectivity_watcher/core/manager/zo_retry_manager.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
part '../../controller/enum_connection.dart';

class ZoConnectivityWatcher {
  ZoConnectivityWatcher._();

  static final ZoConnectivityWatcher _instance = ZoConnectivityWatcher._();

  factory ZoConnectivityWatcher() {
    return _instance;
  }

  GlobalKey<NavigatorState>? _navigationKey;

  BuildContext get currentContext => _navigationKey!.currentContext!;

  StreamController<ConnectivityWatcherStatus> connectivityController =
      StreamController<ConnectivityWatcherStatus>.broadcast();

  setNavigatorKey(GlobalKey<NavigatorState> key) {
    _navigationKey = key;
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
    return await currentContext
        .dependOnInheritedWidgetOfExactType<ZoConnectivityInheritedWidget>()!
        .controller!
        .hideNoInternetScreen();
  }

  /// The function `makeApiCall` checks for internet connection status and calls the provided API function
  /// with the status.
  ///
  /// Args:
  ///   apiCall (Function(bool internetStatus)): The `apiCall` parameter is a function that takes a
  /// boolean parameter `internetStatus` as input. This function is used to make an API call and pass the
  /// internet connection status to it.
  makeApiCall({required Function(bool internetStatus) apiCall}) async {
    bool status = await InternetConnectionChecker().hasConnection;
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
