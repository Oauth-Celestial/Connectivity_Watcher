import 'package:connectivity_watcher/NetworkService/connectivity_enum.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityController with ChangeNotifier {
  ConnectivityWatcherStatus? internetStatus;
  setupConnectivityListner() {
    /// Add Internet Connectivity listner
    InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          try {
            internetStatus = ConnectivityWatcherStatus.connected;
          } catch (e) {}
          print('You are Connected to the internet.');
          break;
        case InternetConnectionStatus.disconnected:
          internetStatus = ConnectivityWatcherStatus.disconnected;
          notifyListeners();
          print('You are disconnected from the internet.');
          break;
      }
      notifyListeners();
    });
  }
}
