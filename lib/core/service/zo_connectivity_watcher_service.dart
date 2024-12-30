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

  GlobalKey<NavigatorState>? _contextKey;

  BuildContext get currentContext => _contextKey!.currentContext!;

  StreamController<ConnectivityWatcherStatus> connectivityController =
      StreamController<ConnectivityWatcherStatus>.broadcast();

  setNavigatorKey(GlobalKey<NavigatorState> key) {
    _contextKey = key;
  }

  bool isInternetAvailable = false;
  bool isNoInternetWidgetVisible = false;

  /// Use this method to forcefully hide the no internet widget
  Future<bool> hideNoInternet() async {
    return await currentContext
        .dependOnInheritedWidgetOfExactType<ZoConnectivityInheritedWidget>()!
        .controller!
        .hideNoInternetScreen();
  }

  makeApiCall({required Function(bool internetStatus) apiCall}) async {
    bool status = await InternetConnectionChecker().hasConnection;
    apiCall(status);
  }
}
