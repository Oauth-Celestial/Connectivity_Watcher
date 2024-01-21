import 'package:connectivity_watcher/controller/connectivity_controller.dart';
import 'package:connectivity_watcher/utils/enums/enum_connection.dart';
import 'package:connectivity_watcher/watcher_barrel.dart';
import 'package:connectivity_watcher/widgets/custom_no_internet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Builder defination
typedef ConnectionBuilder = Widget Function(
    BuildContext, GlobalKey<NavigatorState>);

class ConnectionAwareApp extends StatelessWidget {
  /// [app] will accept MaterialApp or CupertinoApp must be non-null

  /// No internet widget thats to be shown
  final CustomNoInternetWrapper? offlineWidget;

  /// Connection Style for the Wrapper : Default to snackbar
  final NoConnectivityStyle? connectivityStyle;

  final ConnectionBuilder builder;
 ///
 final  Widget? noInternetText;

  ConnectionAwareApp(
      {super.key,
      required this.builder,
      this.noInternetText,
      this.offlineWidget,
      this.connectivityStyle = NoConnectivityStyle.SNACKBAR});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConnectivityController(),
      builder: (context, child) {
        return Builder(builder: (context) {
          Provider.of<ConnectivityController>(context, listen: false)
              .setupConnectivityListner(
                  offlineWidget: offlineWidget,
                  noInternetText: noInternetText,
                  connectivityStyle: connectivityStyle);
          return builder(
              context, context.read<ConnectivityController>().contextKey);
        });
      },
    );
  }
}
