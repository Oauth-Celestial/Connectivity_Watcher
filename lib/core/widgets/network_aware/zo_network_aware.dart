import 'package:connectivity_watcher/core/service/zo_connectivity_watcher_service.dart';
import 'package:flutter/material.dart';

typedef NetworkAwareBuilderWithMode = Widget Function(
    BuildContext context,
    ConnectivityWatcherStatus internetStatus,
    ConnectionMode connectionMode);

typedef NetworkAwareBuilderLegacy = Widget Function(
    BuildContext context, ConnectivityWatcherStatus internetStatus);

/// A reactive widget that listens to network connectivity and connection mode changes,
/// rebuilding its UI dynamically.
///
/// Accepts either a 2-parameter builder:
/// `(context, status) => Widget`
/// or a 3-parameter builder:
/// `(context, status, mode) => Widget`
class ZoNetworkAwareWidget extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    ConnectivityWatcherStatus internetStatus,
    ConnectionMode connectionMode,
  ) builder;

  ZoNetworkAwareWidget({
    super.key,
    required Function builder,
  }) : builder = _wrapBuilder(builder);

  static Widget Function(BuildContext, ConnectivityWatcherStatus, ConnectionMode)
      _wrapBuilder(Function fn) {
    if (fn is Widget Function(
        BuildContext, ConnectivityWatcherStatus, ConnectionMode)) {
      return fn;
    }
    if (fn is Widget Function(BuildContext, ConnectivityWatcherStatus)) {
      return (context, status, mode) => fn(context, status);
    }
    return (context, status, mode) {
      try {
        return (fn as dynamic)(context, status, mode) as Widget;
      } catch (_) {
        return (fn as dynamic)(context, status) as Widget;
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityWatcherEvent>(
      stream: ZoConnectivityWatcher().eventStream,
      initialData: ConnectivityWatcherEvent(
        status: ZoConnectivityWatcher().isInternetAvailable
            ? ConnectivityWatcherStatus.connected
            : ConnectivityWatcherStatus.disconnected,
        mode: ZoConnectivityWatcher().connectionMode,
        activeModes: ZoConnectivityWatcher().activeConnectionModes,
        timestamp: DateTime.now(),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final event = snapshot.data!;
        return builder(context, event.status, event.mode);
      },
    );
  }
}
