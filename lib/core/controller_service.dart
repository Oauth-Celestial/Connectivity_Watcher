import 'package:connectivity_watcher/core/connectivity_inherited.dart';
import 'package:flutter/material.dart';
part 'enum_connection.dart';

class ConnectivityWatcher {
  ConnectivityWatcher._();

  static final ConnectivityWatcher _instance = ConnectivityWatcher._();

  factory ConnectivityWatcher() {
    return _instance;
  }

  GlobalKey<NavigatorState>? _contextKey;

  BuildContext get currentContext => _contextKey!.currentContext!;

  setNavigatorKey(GlobalKey<NavigatorState> key) {
    _contextKey = key;
  }

  /// Use this method to forcefully hide the no internet widget
  Future<bool> hideNoInternet() async {
    return await currentContext
        .dependOnInheritedWidgetOfExactType<ConnectivityInheritedWidget>()!
        .controller!
        .hideNoInternetScreen();
  }

  /// get current internet status
  Future<bool> getConnectivityStatus() {
    return currentContext
        .dependOnInheritedWidgetOfExactType<ConnectivityInheritedWidget>()!
        .controller!
        .getConnectivityStatus();
  }

  /// [subscriptionCallback]
  /// The method is use to subscribe to the internet changes
  /// method can be used to call apis on network changes
  subscribeToConnectivityChange(
      {required Function(Stream<ConnectivityWatcherStatus> stream)
          subscriptionCallback}) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Stream<ConnectivityWatcherStatus> stream = currentContext
          .dependOnInheritedWidgetOfExactType<ConnectivityInheritedWidget>()!
          .controller!
          .connectivityController
          .stream;
      subscriptionCallback(stream);
    });
  }
}
