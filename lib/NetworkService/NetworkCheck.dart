import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:network_check/NetworkService/NoInternet.dart';

class NetworkCheck {
  static final GlobalKey<NavigatorState> contextKey =
      GlobalKey<NavigatorState>();
  static NetworkCheck shared = NetworkCheck();
  OverlayEntry? entry;
  OverlayState? overlayState;
  Widget? noInternetWidget;

  setup({Widget? widgetForNoInternet}) async {
    noInternetWidget = widgetForNoInternet;

    InternetConnectionChecker().onStatusChange.listen((status) {
      overlayState = (contextKey.currentState!.overlay);
      switch (status) {
        case InternetConnectionStatus.connected:
          removeNoInternet();
          print('You are Connected to the internet.');
          break;
        case InternetConnectionStatus.disconnected:
          showNoInternet();
          print('You are disconnected from the internet.');
          break;
      }
    });
  }

  isConnectedtoNetwork() async {
    bool isconnected = await InternetConnectionChecker().hasConnection;
    if (isconnected) {
      removeNoInternet();
    }
  }

  removeNoInternet() {
    entry?.remove();
    entry = null;
    overlayState = null;
  }

  showNoInternet() {
    BuildContext? insertcontext;
    entry = OverlayEntry(builder: (context) {
      insertcontext = context;
      return noInternetWidget ?? NoInternet();
    });

    overlayState?.insert(entry!);
  }
}
