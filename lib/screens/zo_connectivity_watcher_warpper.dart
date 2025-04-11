import 'package:connectivity_watcher/controller/zo_connectivity_controller.dart';
import 'package:connectivity_watcher/core/connectivity_inherited.dart';
import 'package:connectivity_watcher/core/service/zo_connectivity_watcher_service.dart';
import 'package:connectivity_watcher/screens/custom_no_internet.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ZoConnectivityWrapper extends StatelessWidget {
  /// No internet widget thats to be shown
  final CustomNoInternetWrapper? offlineWidget;

  /// Connection Style for the Wrapper : Default to snackbar
  final NoConnectivityStyle? connectivityStyle;

  final ConnectionBuilder builder;

  /// If you already have the navigator key you can pass it here if not passed
  /// the package will assign its own key
  GlobalKey<NavigatorState>? navigationKey;

  Widget? customAlert;

  ZoConnectivityWrapper(
      {super.key,
      required this.builder,
      this.navigationKey,
      this.offlineWidget,
      this.customAlert,
      this.connectivityStyle = NoConnectivityStyle.SNACKBAR});

  @override
  Widget build(BuildContext context) {
    return ZoConnectivityInheritedWidget(
      controller: ZoConnectivityController(),
      child: Builder(builder: (context) {
        ZoConnectivityController controller = context
            .dependOnInheritedWidgetOfExactType<
                ZoConnectivityInheritedWidget>()!
            .controller!;
        controller.setupConnectivityListner(
            offlineWidget: offlineWidget,
            navigatorKey: navigationKey,
            customAlert: customAlert,
            connectivityStyle: connectivityStyle);
        ZoConnectivityWatcher().setNavigatorKey(controller.contextKey);
        return builder(context, controller.contextKey);
      }),
    );
  }
}
