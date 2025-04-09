import 'dart:async';

import 'package:connectivity_watcher/core/connectivity_inherited.dart';
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
  /// The function `hideNoInternet` returns a Future<bool> that hides the no internet screen by
  /// accessing the controller from an inherited widget.
  ///
  /// Returns:
  ///   The function `hideNoInternet()` returns a `Future<bool>` which will eventually resolve to a
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
}
