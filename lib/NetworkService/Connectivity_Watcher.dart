import 'package:connectivity_watcher/NetworkService/Model/ConnectivityWidgetModel.dart';
import 'package:connectivity_watcher/NetworkService/DefaultNoInternet.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityWatcher {
  static final GlobalKey<NavigatorState> contextKey =
      GlobalKey<NavigatorState>();
  static ConnectivityWatcher shared = ConnectivityWatcher();
  OverlayEntry? entry;
  List<OverlayEntry> entries = [];
  OverlayState? overlayState;
  NoInternetWidget? userWidget;

  /// used to setup the connectivity listener and custom internet widget

  setup({NoInternetWidget? widgetForNoInternet}) async {
    userWidget = widgetForNoInternet;

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
    } else {
      final scaffold = ScaffoldMessenger.of(contextKey.currentState!.context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text("No Internet"),
        ),
      );
    }
  }

  /// Removes the No internet widget from the tree
  removeNoInternet() {
    entries.forEach((entry) => entry.remove());
    entries.clear();
  }

  /// Responsible for getting the current context from the tree and draw the  custom widget
  showNoInternet() {
    entry = OverlayEntry(builder: (context) {
      return userWidget?.widget ??
          DefaultNoInternetWidget(
            userWidget: userWidget,
          );
    });
    entries.add(entry!);
    overlayState?.insert(entry!);
  }
}
