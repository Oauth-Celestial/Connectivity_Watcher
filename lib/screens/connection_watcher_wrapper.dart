import 'package:connectivity_watcher/core/connectivity_controller.dart';
import 'package:connectivity_watcher/core/connectivity_inherited.dart';
import 'package:connectivity_watcher/core/controller_service.dart';
import 'package:connectivity_watcher/screens/custom_no_internet.dart';
import 'package:flutter/material.dart';

/// Builder defination

// ignore: must_be_immutable
class ConnectivityWatcherWrapper extends StatelessWidget {
  /// [app] will accept MaterialApp or CupertinoApp must be non-null

  /// No internet widget thats to be shown
  final CustomNoInternetWrapper? offlineWidget;

  /// Connection Style for the Wrapper : Default to snackbar
  final NoConnectivityStyle? connectivityStyle;

  final ConnectionBuilder builder;

  /// Pass Nointernet widget
  final Widget? noInternetText;

  /// If you already have the navigator key you can pass it here if not passed
  /// the package will assign its own key
  GlobalKey<NavigatorState>? navigationKey;

  ConnectivityWatcherWrapper(
      {super.key,
      required this.builder,
      this.navigationKey,
      this.noInternetText,
      this.offlineWidget,
      this.connectivityStyle = NoConnectivityStyle.SNACKBAR});

// ConnectivityController()
  @override
  Widget build(BuildContext context) {
    return ConnectivityInheritedWidget(
      controller: ConnectivityController(),
      child: Builder(builder: (context) {
        ConnectivityController controller = context
            .dependOnInheritedWidgetOfExactType<ConnectivityInheritedWidget>()!
            .controller!;
        controller.setupConnectivityListner(
            offlineWidget: offlineWidget,
            noInternetText: noInternetText,
            navigatorKey: navigationKey,
            connectivityStyle: connectivityStyle);
        ConnectivityWatcher().setNavigatorKey(controller.contextKey);
        return builder(context, controller.contextKey);
      }),
    );
  }
}
