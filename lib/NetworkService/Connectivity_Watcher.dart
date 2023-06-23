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
  OverlayEntry? _entry;

  /// list of overlay entries to all the reference of overlays drawn
  List<OverlayEntry> _entries = [];

  /// Overlay state
  OverlayState? _overlayState;

  /// Custom No Internet widget provided by the user
  NoInternetWidget? _userWidget;

  /// SetUp the connection listner
  /// widgetForNoInternet: pass your no internet widget  if not passed default is set

  setup({NoInternetWidget? widgetForNoInternet}) async {
    _userWidget = widgetForNoInternet;

    InternetConnectionChecker().onStatusChange.listen((status) {
      _overlayState = (contextKey.currentState!.overlay);
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
    _entries.forEach((entry) => entry.remove());
    _entries.clear();
  }

  /// Responsible for getting the current context from the tree and draw the  custom widget
  showNoInternet() {
    _entry = OverlayEntry(builder: (context) {
      return _userWidget?.widget ??
          DefaultNoInternetWidget(
            userWidget: _userWidget,
          );
    });
    _entries.add(_entry!);
    _overlayState?.insert(_entry!);
  }

  Future<bool> getConnectivityStatus() async {
    bool isconnected = await InternetConnectionChecker().hasConnection;
    return isconnected;
  }
}
