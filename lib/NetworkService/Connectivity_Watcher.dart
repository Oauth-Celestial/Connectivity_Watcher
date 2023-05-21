import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityWatcher {
  static final GlobalKey<NavigatorState> contextKey =
      GlobalKey<NavigatorState>();
  static ConnectivityWatcher shared = ConnectivityWatcher();
  OverlayEntry? entry;
  List<OverlayEntry> entries = [];
  OverlayState? overlayState;
  Widget? noInternetWidget;

  /// used to setup the connectivity listener and custom internet widget

  setup({Widget? widgetForNoInternet}) async {
    noInternetWidget = widgetForNoInternet;

    InternetConnectionChecker().onStatusChange.listen((status) {
      overlayState = (contextKey.currentState!.overlay);
      switch (status) {
        case InternetConnectionStatus.connected:
          try {
            removeNoInternet();
          } catch (e) {}
          print('You are Connected to the internet.');
          break;
        case InternetConnectionStatus.disconnected:
          showNoInternet();
          print('You are disconnected from the internet.');
          break;
      }
    });
  }

  /// Checks if the internet connect is back and removes the no internet widget

  isConnectedtoNetwork() async {
    bool isconnected = await InternetConnectionChecker().hasConnection;
    if (isconnected) {
      removeNoInternet();
    } else {}
  }

  /// Removes the No internet widget from the tree
  removeNoInternet() {
    entries.forEach((entry) => entry.remove());
    entries.clear();
  }

  /// Responsible for getting the current context from the tree and draw the  custom widget
  showNoInternet() {
    entry = OverlayEntry(builder: (context) {
      return noInternetWidget ?? Container();
    });
    entries.add(entry!);
    overlayState?.insert(entry!);
  }
}
