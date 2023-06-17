import 'package:connectivity_watcher/NetworkService/Model/ConnectivityWidgetModel.dart';
import 'package:connectivity_watcher/NetworkService/DefaultNoInternet.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityWatcher {
  ConnectivityWatcher._();

  /// Global context key for getting context throught the app
  static final GlobalKey<NavigatorState> contextKey =
      GlobalKey<NavigatorState>();

  /// Shared instance of Connectivity watcher
  static ConnectivityWatcher shared = ConnectivityWatcher._();

  /// Overlay instance
  OverlayEntry? entry;

  /// list of overlay entries to all the reference of overlays drawn
  List<OverlayEntry> entries = [];

  /// Overlay state
  OverlayState? overlayState;

  /// Custom No Internet widget provided by the user
  NoInternetWidget? userWidget;

  /// SetUp the connection listner
  /// widgetForNoInternet: pass your no internet widget  if not passed default is set

  setup({NoInternetWidget? widgetForNoInternet}) async {
    userWidget = widgetForNoInternet;

    InternetConnectionChecker().onStatusChange.listen((status) {
      overlayState = (contextKey.currentState!.overlay);
      switch (status) {
        /// ConnectedState
        case InternetConnectionStatus.connected:
          try {
            removeNoInternet();
          } catch (e) {}
          print('You are Connected to the internet.');
          break;

        /// DisconnectedState
        case InternetConnectionStatus.disconnected:
          showNoInternet();
          print('You are disconnected from the internet.');
          break;
      }
    });
  }

  /// Checks if the internet connect is back and removes the no internet widget

  shouldRemoveNoInternet() async {
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

  /// Removes the No internet widget from the tree and clears overlay entry
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

  Future<bool> getConnectivityStatus() async {
    bool isconnected = await InternetConnectionChecker().hasConnection;
    return isconnected;
  }
}
