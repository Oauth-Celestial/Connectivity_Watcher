import 'package:connectivity_watcher/controller/connectivity_controller.dart';
import 'package:connectivity_watcher/network_check.dart';
import 'package:connectivity_watcher/utils/enums/enum_connection.dart';
import 'package:connectivity_watcher/watcher_barrel.dart';
import 'package:connectivity_watcher/widgets/custom_no_internet.dart';
import 'package:flutter/material.dart';

/// Builder defination
typedef ConnectionBuilder = Widget Function(
    BuildContext, GlobalKey<NavigatorState>);

// ignore: must_be_immutable
class ConnectivityInheritedWidget extends InheritedWidget {
  ConnectivityInheritedWidget({
    this.controller,
    required Widget child,
  }) : super(child: child);
  ConnectivityController? controller;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class ConnectionAwareApp extends StatelessWidget {
  /// [app] will accept MaterialApp or CupertinoApp must be non-null

  /// No internet widget thats to be shown
  final CustomNoInternetWrapper? offlineWidget;

  /// Connection Style for the Wrapper : Default to snackbar
  final NoConnectivityStyle? connectivityStyle;

  final ConnectionBuilder builder;

  ///
  final Widget? noInternetText;

  ConnectionAwareApp(
      {super.key,
      required this.builder,
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
            connectivityStyle: connectivityStyle);
        return builder(context, controller.contextKey);
      }),
    );
  }
}
