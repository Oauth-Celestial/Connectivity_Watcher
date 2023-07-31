import 'package:connectivity_watcher/NetworkService/Model/connectivity_enum.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityController with ChangeNotifier {
  ConnectivityWatcherStatus? internetStatus;
  InternetConnectionChecker checker = InternetConnectionChecker.createInstance(
    checkInterval: Duration(seconds: 2),
    checkTimeout: Duration(seconds: 2)
    
  );
  setupConnectivityListner() {
    /// Add Internet Connectivity listner
   checker.onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          try {
            internetStatus = ConnectivityWatcherStatus.connected;
          } catch (e) {}
         
          break;
        case InternetConnectionStatus.disconnected:
          internetStatus = ConnectivityWatcherStatus.disconnected;
          break;
      }
      notifyListeners();
    });
  }
}
