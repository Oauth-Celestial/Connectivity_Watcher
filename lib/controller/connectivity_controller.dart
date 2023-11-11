import 'package:connectivity_watcher/Model/no_internet_model.dart';
import 'package:connectivity_watcher/utils/enums/enum_connection.dart';
import 'package:connectivity_watcher/widgets/default_no_internet.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityController with ChangeNotifier {
  ConnectivityWatcherStatus? internetStatus;
  final GlobalKey<NavigatorState> contextKey = GlobalKey<NavigatorState>();

  OverlayEntry? _entry;

  /// list of overlay entries to all the reference of overlays drawn
  List<OverlayEntry> _entries = [];

  /// Overlay state
  OverlayState? _overlayState;

  /// Custom No Internet widget provided by the user
  NoInternetWidget? _userWidget;
  NoConnectivityStyle? _connectivityStyle;
  InternetConnectionChecker checker = InternetConnectionChecker.createInstance(
      checkInterval: Duration(seconds: 2), checkTimeout: Duration(seconds: 2));
  setupConnectivityListner(
      {NoInternetWidget? widgetForNoInternet,
      NoConnectivityStyle? connectivityStyle =
          NoConnectivityStyle.SNACKBAR}) async {
    _userWidget = widgetForNoInternet;
    _connectivityStyle = connectivityStyle;

    InternetConnectionChecker().onStatusChange.listen((status) {
      _overlayState = (contextKey.currentState!.overlay);
      switch (status) {
        /// ConnectedState
        case InternetConnectionStatus.connected:
          try {
            _removeNoInternet();
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

  /// SetUp the connection listner
  /// widgetForNoInternet: pass your no internet widget  if not passed default is set

  /// Checks if the internet connect is back and removes the no internet widget
  // _shouldRemoveNoInternet() async {
  //   bool isconnected = await InternetConnectionChecker().hasConnection;
  //   if (isconnected) {
  //     ///removes the widget from the overlay state
  //     _removeNoInternet();
  //   } else {
  //     final scaffold = ScaffoldMessenger.of(contextKey.currentState!.context);
  //     scaffold.showSnackBar(
  //       SnackBar(
  //         content: const Text("No Internet"),
  //       ),
  //     );
  //   }
  // }

  /// Removes the No internet widget from the tree and clears overlay entry
  _removeNoInternet() {
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

  /// Get status of conncetion
  Future<bool> getConnectivityStatus() async {
    bool isconnected = await InternetConnectionChecker().hasConnection;
    return isconnected;
  }
}
