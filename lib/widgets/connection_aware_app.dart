import 'package:connectivity_watcher/controller/connectivity_controller.dart';
import 'package:connectivity_watcher/utils/enums/enum_connection.dart';
import 'package:connectivity_watcher/watcher_barrel.dart';
import 'package:connectivity_watcher/widgets/custom_no_internet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable

typedef ConnectionBuilder = Widget Function(
    BuildContext, GlobalKey<NavigatorState>);

class ConnectionAwareApp extends StatelessWidget {
  /// [app] will accept MaterialApp or CupertinoApp must be non-null

  /// No internet widget thats to be shown
  final CustomNoInternetWrapper? noInternetWidget;

  final NoConnectivityStyle? connectivityStyle;

  final ConnectionBuilder builder;

  ConnectionAwareApp(
      {super.key,
      required this.builder,
      this.noInternetWidget,
      this.connectivityStyle = NoConnectivityStyle.SNACKBAR});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConnectivityController(),
      builder: (context, child) {
        return Builder(builder: (context) {
          Provider.of<ConnectivityController>(context, listen: false)
              .setupConnectivityListner(
                  widgetForNoInternet: noInternetWidget,
                  connectivityStyle: connectivityStyle);
          return builder(
              context, context.read<ConnectivityController>().contextKey);
        });
      },
    );
  }
}
